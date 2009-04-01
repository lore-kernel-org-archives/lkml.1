Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZDAMrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZDAMrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZDAMq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:46:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZDAMq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:46:58 -0400
Date: Wed, 1 Apr 2009 09:46:23 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] blktrace: fix output of unknown events
Message-ID: <20090401124623.GC25493@ghostprotocols.net>
References: <49D3236D.3090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3236D.3090705@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 01, 2009 at 04:18:53PM +0800, Li Zefan escreveu:
> Not all events are pc (packet command) events. An event is a pc
> event only if it has BLK_TC_PC bit set.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 947c5b3..464a6e5 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1181,7 +1181,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
>  	}
>  
>  	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
> -		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
> +		ret = trace_seq_printf(s, "Unknown action %x\n", what);
>  	else {
>  		ret = log_action(iter, what2act[what].act[long_act]);
>  		if (ret)

Looks ok,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
