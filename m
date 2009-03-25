Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZCYBVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZCYBVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZCYBVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:21:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbZCYBVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:21:24 -0400
Message-ID: <49C98727.9050802@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 09:21:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] blktrace: fix off-by-one bug
References: <49C893FC.9080905@cn.fujitsu.com> <49C89447.5060303@cn.fujitsu.com>
In-Reply-To: <49C89447.5060303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> 'what' is used as the index of array what2act, so it can't >= the array size.
> 

I think this patch is needed no matter we support output of "abort"
event or not?

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 9af4143..0e91caa 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1149,7 +1149,7 @@ static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
>  	if (!trace_print_context(iter))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
> +	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
>  		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
>  	else {
>  		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
> @@ -1196,7 +1196,7 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
>  	t = (const struct blk_io_trace *)iter->ent;
>  	what = t->action & ((1 << BLK_TC_SHIFT) - 1);
>  
> -	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
> +	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
>  		ret = trace_seq_printf(&iter->seq, "Bad pc action %x\n", what);
>  	else {
>  		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);

