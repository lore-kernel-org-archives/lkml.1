Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbXGEMJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbXGEMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbXGEMJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:09:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2312 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756363AbXGEMJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:09:51 -0400
Date: Thu, 5 Jul 2007 12:09:39 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Robert P. J. Day" <rpjday@mindspring.com>, ak@suse.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] X86: Update alignment when 4K stacks are used.
Message-ID: <20070705120938.GA5167@ucw.cz>
References: <Pine.LNX.4.64.0706250642050.3880@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706250642050.3880@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-25 06:43:37, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   it's not clear from MAINTAINERS who's responsible for something this
> generic.

I'd cc andi here...
							Pavel

> diff --git a/arch/i386/kernel/irq.c b/arch/i386/kernel/irq.c
> index d2daf67..504f134 100644
> --- a/arch/i386/kernel/irq.c
> +++ b/arch/i386/kernel/irq.c
> @@ -149,15 +149,11 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
> 
>  #ifdef CONFIG_4KSTACKS
> 
> -/*
> - * These should really be __section__(".bss.page_aligned") as well, but
> - * gcc's 3.0 and earlier don't handle that correctly.
> - */
>  static char softirq_stack[NR_CPUS * THREAD_SIZE]
> -		__attribute__((__aligned__(THREAD_SIZE)));
> +		__attribute__((__section__(".bss.page_aligned")));
> 
>  static char hardirq_stack[NR_CPUS * THREAD_SIZE]
> -		__attribute__((__aligned__(THREAD_SIZE)));
> +		__attribute__((__section__(".bss.page_aligned")));
> 
>  /*
>   * allocate per-cpu stacks for hardirq and for softirq processing
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
