Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZHFDu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZHFDu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZHFDu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:50:27 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61363 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZHFDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iG01SznoqI1tR9gTptdiWj8RKOCMWSafa1o5Uacpnch7BJlFSBUP6AoYrzkt8IWEws
         jF5bWlJ3XBU7QE5GmoHkyKcrhSU8L9MdOWw6XWhFt5yEcugGSrEnPzMb6WIdOfhnH3f3
         4o9pOMwy8EtbuSush+sANsBawkvPyi5yUQ7iM=
Date: Thu, 6 Aug 2009 05:50:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ftrace: Rename set_tracer_flags()'s local variable
	trace_flags
Message-ID: <20090806035021.GC24609@nowhere>
References: <4A7A4D7B.7010706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A4D7B.7010706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 11:26:51AM +0800, Zhaolei wrote:
> set_tracer_flags() have a local variable named trace_flags which have
> same name with global one.
> Actually, using tracer_flags should be better by its meaning.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/trace.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e30e6b1..464b7bb 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2291,23 +2291,23 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
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
> @@ -2315,9 +2315,9 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
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

