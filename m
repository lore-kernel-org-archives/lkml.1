Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZCTM7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZCTM7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 08:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZCTM7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 08:59:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZCTM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 08:59:12 -0400
Date: Fri, 20 Mar 2009 09:58:46 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] blktrace: make blk_tracer_enabled a bool flag
Message-ID: <20090320125846.GI30407@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F5D3.8090104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F5D3.8090104@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 20, 2009 at 09:48:03AM +0800, Li Zefan escreveu:
> It doesn't have to be a counter, and it can be a bool flag instead.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index fb3bc53..73845b7 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -30,7 +30,7 @@
>  static unsigned int blktrace_seq __read_mostly = 1;
>  
>  static struct trace_array *blk_tr;
> -static int __read_mostly  blk_tracer_enabled;
> +static bool blk_tracer_enabled __read_mostly;
>  
>  /* Select an alternative, minimalistic output than the original one */
>  #define TRACE_BLK_OPT_CLASSIC	0x1
> @@ -1111,9 +1111,7 @@ static int blk_tracer_init(struct trace_array *tr)
>  {
>  	blk_tr = tr;
>  	blk_tracer_start(tr);
> -	mutex_lock(&blk_probe_mutex);
> -	blk_tracer_enabled++;
> -	mutex_unlock(&blk_probe_mutex);
> +	blk_tracer_enabled = true;
>  	return 0;
>  }
>  
> @@ -1131,11 +1129,7 @@ static void blk_tracer_reset(struct trace_array *tr)
>  	if (!atomic_read(&blk_probes_ref))
>  		return;
>  
> -	mutex_lock(&blk_probe_mutex);
> -	blk_tracer_enabled--;
> -	WARN_ON(blk_tracer_enabled < 0);
> -	mutex_unlock(&blk_probe_mutex);
> -
> +	blk_tracer_enabled = false;
>  	blk_tracer_stop(tr);
>  }

Copy'n'pasted code, some other tracer still have this style:

enable_branch_tracing, enable_mmiotrace,
tracing_start_sched_switch_record

Anyway, thanks,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
