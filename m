Return-Path: <linux-kernel-owner+w=401wt.eu-S934129AbXHFUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbXHFUiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933246AbXHFUh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:37:56 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:28986 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932856AbXHFUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:37:55 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 16:37:55 EDT
X-YMail-OSG: xXORfYEVM1lcjtATSUFI0Kr4qWazxknLc6rpcUEz0OP0aiPZ0pzXIjF_JhGWX6uHl7_SrH0hIZ07Qmlk7i8U6Wif0pu93eO6EGQ3qHk-
Date: Mon, 6 Aug 2007 15:31:12 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ifdef struct task_struct::security
Message-ID: <20070806203112.GA12726@vino.hallyn.com>
References: <20070806185514.GA5842@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806185514.GA5842@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> For those who don't care about CONFIG_SECURITY.

I'm quite sure we started that way, but the ifdefs were considered
too much of an eyesore.

If this is now acceptable, then the same thing might be considered
for inode->i_security, kern_ipc_perm.security, etc.  Getting rid of
just the task->security seems overly half-hearted.

-serge

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  include/linux/sched.h |    3 ++-
>  kernel/fork.c         |    2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1086,8 +1086,9 @@ struct task_struct {
>  	int (*notifier)(void *priv);
>  	void *notifier_data;
>  	sigset_t *notifier_mask;
> -	
> +#ifdef CONFIG_SECURITY
>  	void *security;
> +#endif
>  	struct audit_context *audit_context;
>  	seccomp_t seccomp;
>  
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	do_posix_clock_monotonic_gettime(&p->start_time);
>  	p->real_start_time = p->start_time;
>  	monotonic_to_bootbased(&p->real_start_time);
> +#ifdef CONFIG_SECURITY
>  	p->security = NULL;
> +#endif
>  	p->io_context = NULL;
>  	p->io_wait = NULL;
>  	p->audit_context = NULL;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
