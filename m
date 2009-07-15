Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbZGOO2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbZGOO2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZGOO2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:28:51 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:41745 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZGOO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KDltOv73BEjK3LIseadokcm0WkDN/WlDrzVYLedD51bfCuUVmoRti8gfMZ0bQZGcBa
         /7yK3AfeVpl3mSWVJ2KzVXslBrOFLdZe8JZUmYHagiRYGErgOVauHjRjfmfLB9wDRQPA
         YIyb8vAgiu/VhIDiOx9etAX9ANM07ufTWAeUI=
Date: Wed, 15 Jul 2009 10:28:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function: fix the return value of
	ftrace_trace_onoff_callback()
Message-ID: <20090715142814.GA6184@nowhere>
References: <4A5D5B12.2050802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5D5B12.2050802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:29:06PM +0800, Xiao Guangrong wrote:
> ftrace_trace_onoff_callback() will return error even if we do the
> right operation, for example:
> 
> # echo _spin_*:traceon:10 > set_ftrace_filter
> -bash: echo: write error: Invalid argument
> # cat set_ftrace_filter
> #### all functions enabled ####
> _spin_trylock_bh:traceon:count=10
> _spin_unlock_irq:traceon:count=10
> _spin_unlock_bh:traceon:count=10
> _spin_lock_irq:traceon:count=10
> _spin_unlock:traceon:count=10
> _spin_trylock:traceon:count=10
> _spin_unlock_irqrestore:traceon:count=10
> _spin_lock_irqsave:traceon:count=10
> _spin_lock_bh:traceon:count=10
> _spin_lock:traceon:count=10
> 
> We want to set _spin_*:traceon:10 to set_ftrace_filter, it complain
> with "Invalid argument", but the operation is successful.
> So, this patch fix it.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>



Looks good, thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/trace_functions.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 7402144..75ef000 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -363,7 +363,7 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
>   out_reg:
>  	ret = register_ftrace_function_probe(glob, ops, count);
>  
> -	return ret;
> +	return ret < 0 ? ret : 0;
>  }
>  
>  static struct ftrace_func_command ftrace_traceon_cmd = {
> -- 
> 1.6.1.2
> 

