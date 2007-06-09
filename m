Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbXFIR7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbXFIR7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbXFIR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:59:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21562 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbXFIR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=henPfqWZKL0BMEPl2P/0Mjy+LYJyO/I/3jLhNP1ZXCOOCqdFAhhJmsCjnzEXv0EEFNPWPDNTELo6lsa5AJxc1v+X6AI+Fe7RUjOBbahfM50JdIeSS9DnYlnyARkbwuSfecL8JLhg3s9zEMdDzoMSa1jTGIvr1m8g7IrZnLmTwfk=
Date: Sat, 9 Jun 2007 22:00:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 2/7] Replace DPRINTK with pr_debug in alternative.c
Message-ID: <20070609180025.GA5760@martell.zuzino.mipt.ru>
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org> <466A600E.9020109@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466A600E.9020109@hawkeye.stone.uk.eu.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:08:46AM +0100, Jack Stone wrote:
> This patch converts all DPRINTKs in alternative.c to pr_debug

, rendering "debug-alternative" option useless.

> --- linux/arch/i386/kernel/alternative.c
> +++ linux/arch/i386/kernel/alternative.c
> @@ -1,3 +1,4 @@
> +#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/spinlock.h>
> @@ -41,9 +42,6 @@
>  __setup("noreplace-paravirt", setup_noreplace_paravirt);
>  #endif
> 
> -#define DPRINTK(fmt, args...) if (debug_alternative) \
> -	printk(KERN_DEBUG fmt, args)
> -
>  #ifdef GENERIC_NOP1
>  /* Use inline assembly to define this because the nops are defined
>     as inline assembly strings in the include files and we cannot
> @@ -165,7 +163,7 @@
>  	u8 *instr;
>  	int diff;
> 
> -	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
> +	pr_debug("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
>  	for (a = start; a < end; a++) {
>  		BUG_ON(a->replacementlen > a->instrlen);
>  		if (!boot_cpu_has(a->cpuid))
> @@ -175,7 +173,7 @@
>  		/* vsyscall code is not mapped yet. resolve it manually. */
>  		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
>  			instr = __va(instr - (u8*)VSYSCALL_START +
> (u8*)__pa_symbol(&__vsyscall_0));
> -			DPRINTK("%s: vsyscall fixup: %p => %p\n",
> +			pr_debug("%s: vsyscall fixup: %p => %p\n",
>  				__FUNCTION__, a->instr, instr);
>  		}
>  #endif
> @@ -261,7 +259,7 @@
>  	smp->locks_end	= locks_end;
>  	smp->text	= text;
>  	smp->text_end	= text_end;
> -	DPRINTK("%s: locks %p -> %p, text %p -> %p, name %s\n",
> +	pr_debug("%s: locks %p -> %p, text %p -> %p, name %s\n",
>  		__FUNCTION__, smp->locks, smp->locks_end,
>  		smp->text, smp->text_end, smp->name);
> 
> @@ -287,7 +285,7 @@
>  			continue;
>  		list_del(&item->next);
>  		spin_unlock_irqrestore(&smp_alt, flags);
> -		DPRINTK("%s: %s\n", __FUNCTION__, item->name);
> +		pr_debug("%s: %s\n", __FUNCTION__, item->name);

