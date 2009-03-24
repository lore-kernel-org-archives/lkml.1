Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZCXI2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZCXI2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZCXI2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:28:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZCXI2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:28:17 -0400
Date: Tue, 24 Mar 2009 09:27:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] blktrace: fix off-by-one bug
Message-ID: <20090324082754.GA13016@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89447.5060303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C89447.5060303@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> 'what' is used as the index of array what2act, so it can't >= the array size.
> 
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

ah, nice. How did you notice - did we miss "remap" events due to 
this bug?

	Ingo
