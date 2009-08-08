Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZHHAiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZHHAiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZHHAiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:38:20 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:43828 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZHHAiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mjYgRcmAP1jKSwjxX8bz0Eb0Xhz28LjHsFpjsZnb2Aiq5bbJ65ow/mtox7LXbH/2D1
         O8H0DVFNPHfSZxOfZVMXY1w+oLGw0wEcRAMCOT5PXy1uR8i35f2GS1Q5R/b6qbpnmgbU
         jWKgHuFaMd+/QNgPmcfBAP7OcConfMf729X4g=
Date: Sat, 8 Aug 2009 02:38:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ftrace: Rename set_tracer_flags()'s local
	variable trace_flags
Message-ID: <20090808003816.GL4999@nowhere>
References: <4A7A4D7B.7010706@cn.fujitsu.com> <4A7A4DBC.6020403@cn.fujitsu.com> <4A7A6470.60305@cn.fujitsu.com> <4A7C07A1.6070807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7C07A1.6070807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 06:53:21PM +0800, Zhaolei wrote:
> set_tracer_flags() have a local variable named trace_flags which have
> same name with global one.
> Actually, using tracer_flags should be better by its meaning.
> 
> Changelog:
> v1->v2: Simplied another patch in this patchset, no change in this patch.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>


Queued for .32, thanks!


> ---
>  kernel/trace/trace.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6344573..6c5f67f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2117,23 +2117,23 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
>  /* Try to assign a tracer specific option */
>  static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
>  {
> -	struct tracer_flags *trace_flags = trace->flags;
> +	struct tracer_flags *tracer_flags = trace->flags;
>  	struct tracer_opt *opts = NULL;
>  	int ret = 0, i = 0;
>  	int len;
>  
> -	for (i = 0; trace_flags->opts[i].name; i++) {
> -		opts = &trace_flags->opts[i];
> +	for (i = 0; tracer_flags->opts[i].name; i++) {
> +		opts = &tracer_flags->opts[i];
>  		len = strlen(opts->name);
>  
>  		if (strncmp(cmp, opts->name, len) == 0) {
> -			ret = trace->set_flag(trace_flags->val,
> +			ret = trace->set_flag(tracer_flags->val,
>  				opts->bit, !neg);
>  			break;
>  		}
>  	}
>  	/* Not found */
> -	if (!trace_flags->opts[i].name)
> +	if (!tracer_flags->opts[i].name)
>  		return -EINVAL;
>  
>  	/* Refused to handle */
> @@ -2141,9 +2141,9 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
>  		return ret;
>  
>  	if (neg)
> -		trace_flags->val &= ~opts->bit;
> +		tracer_flags->val &= ~opts->bit;
>  	else
> -		trace_flags->val |= opts->bit;
> +		tracer_flags->val |= opts->bit;
>  
>  	return 0;
>  }
> -- 
> 1.5.5.3
> 
> 

