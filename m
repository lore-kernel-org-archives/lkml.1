Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbZHECGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbZHECGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933314AbZHECGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:06:49 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45131 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933311AbZHECGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:06:47 -0400
Message-ID: <4A78E934.6040106@snapgear.com>
Date: Wed, 05 Aug 2009 12:06:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: gerg@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: convert to asm-generic/hardirq.h
References: <20090804145244.GH20487@lst.de>
In-Reply-To: <20090804145244.GH20487@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks, I'll include that in my "for-linus" patches for
the next merge window.

Regards
Greg



> Index: linux-2.6/arch/m68k/include/asm/hardirq_no.h
> ===================================================================
> --- linux-2.6.orig/arch/m68k/include/asm/hardirq_no.h	2009-07-27 14:35:39.630898799 +0200
> +++ linux-2.6/arch/m68k/include/asm/hardirq_no.h	2009-07-27 14:56:09.546901120 +0200
> @@ -1,16 +1,8 @@
>  #ifndef __M68K_HARDIRQ_H
>  #define __M68K_HARDIRQ_H
>  
> -#include <linux/cache.h>
> -#include <linux/threads.h>
>  #include <asm/irq.h>
>  
> -typedef struct {
> -	unsigned int __softirq_pending;
> -} ____cacheline_aligned irq_cpustat_t;
> -
> -#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
> -
>  #define HARDIRQ_BITS	8
>  
>  /*
> @@ -23,5 +15,8 @@ typedef struct {
>  #endif
>  
>  void ack_bad_irq(unsigned int irq);
> +#define ack_bad_irq ack_bad_irq
> +
> +#include <asm-generic/hardirq.h>
>  
>  #endif /* __M68K_HARDIRQ_H */
> Index: linux-2.6/arch/m68knommu/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/m68knommu/kernel/irq.c	2009-07-27 14:53:45.783148910 +0200
> +++ linux-2.6/arch/m68knommu/kernel/irq.c	2009-07-27 14:56:18.687931620 +0200
> @@ -29,11 +29,6 @@ asmlinkage void do_IRQ(int irq, struct p
>  	set_irq_regs(oldregs);
>  }
>  
> -void ack_bad_irq(unsigned int irq)
> -{
> -	printk(KERN_ERR "IRQ: unexpected irq=%d\n", irq);
> -}
> -
>  static struct irq_chip m_irq_chip = {
>  	.name		= "M68K-INTC",
>  	.enable		= enable_vector,
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
