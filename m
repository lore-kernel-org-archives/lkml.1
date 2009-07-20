Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZGTP70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZGTP70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZGTP7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:59:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZGTP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:59:25 -0400
Date: Mon, 20 Jul 2009 11:59:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: cleanup for tracing_trace_options_read()
In-Reply-To: <4A3EED63.3090908@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907201158350.7595@gandalf.stny.rr.com>
References: <4A3EED63.3090908@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Jun 2009, Xiao Guangrong wrote:

> '\n' is already appended, and what we need is just an extra
> space for the '\0'.

Hi Xiao,

I'm going through old email (or email lost in the shuffle) and I came 
across this lost patch. I'll go ahead an apply it.

Thanks,

-- Steve


> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/trace/trace.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 076fa6f..4c3f856 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2266,8 +2266,8 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
>  		len += 3; /* "no" and newline */
>  	}
>  
> -	/* +2 for \n and \0 */
> -	buf = kmalloc(len + 2, GFP_KERNEL);
> +	/* +1 for \0 */
> +	buf = kmalloc(len + 1, GFP_KERNEL);
>  	if (!buf) {
>  		mutex_unlock(&trace_types_lock);
>  		return -ENOMEM;
> @@ -2290,7 +2290,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
>  	}
>  	mutex_unlock(&trace_types_lock);
>  
> -	WARN_ON(r >= len + 2);
> +	WARN_ON(r >= len + 1);
>  
>  	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
>  
> -- 
> 1.6.1.2
> 
> 
