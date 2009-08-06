Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZHFOzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZHFOzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZHFOzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:55:48 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:53821 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbZHFOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:55:47 -0400
Message-ID: <4A7AEEEC.2040400@monstr.eu>
Date: Thu, 06 Aug 2009 16:55:40 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [microblaze-uclinux] [PATCH] microblaze: convert to asm-generic/hardirq.h
References: <20090804145319.GI20487@lst.de>
In-Reply-To: <20090804145319.GI20487@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Can you please change your patch title?
You are removing ack_bad_irq not convert to hardirq.h

But anyway will be worth to remove it from other archs too.

Thanks,
Michal

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/arch/microblaze/include/asm/hardirq.h
> ===================================================================
> --- linux-2.6.orig/arch/microblaze/include/asm/hardirq.h	2009-07-27 14:32:58.596148711 +0200
> +++ linux-2.6/arch/microblaze/include/asm/hardirq.h	2009-07-27 14:56:30.691912378 +0200
> @@ -12,8 +12,6 @@
>  /* should be defined in each interrupt controller driver */
>  extern unsigned int get_irq(struct pt_regs *regs);
>  
> -#define ack_bad_irq ack_bad_irq
> -void ack_bad_irq(unsigned int irq);
>  #include <asm-generic/hardirq.h>
>  
>  #endif /* _ASM_MICROBLAZE_HARDIRQ_H */
> Index: linux-2.6/arch/microblaze/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/microblaze/kernel/irq.c	2009-07-27 14:53:45.847149312 +0200
> +++ linux-2.6/arch/microblaze/kernel/irq.c	2009-07-27 14:56:37.121902184 +0200
> @@ -30,15 +30,6 @@ unsigned int irq_of_parse_and_map(struct
>  }
>  EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
>  
> -/*
> - * 'what should we do if we get a hw irq event on an illegal vector'.
> - * each architecture has to answer this themselves.
> - */
> -void ack_bad_irq(unsigned int irq)
> -{
> -	printk(KERN_WARNING "unexpected IRQ trap at vector %02x\n", irq);
> -}
> -
>  static u32 concurrent_irq;
>  
>  void do_IRQ(struct pt_regs *regs)
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
