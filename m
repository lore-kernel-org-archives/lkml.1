Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZHFVAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZHFVAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZHFVAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:00:45 -0400
Received: from verein.lst.de ([213.95.11.210]:57857 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbZHFVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:00:45 -0400
Date: Thu, 6 Aug 2009 23:00:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [microblaze-uclinux] [PATCH] microblaze: convert to asm-generic/hardirq.h
Message-ID: <20090806210038.GA5147@lst.de>
References: <20090804145319.GI20487@lst.de> <4A7AEEEC.2040400@monstr.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AEEEC.2040400@monstr.eu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 04:55:40PM +0200, Michal Simek wrote:
> Hi Christoph,
> 
> Can you please change your patch title?
> You are removing ack_bad_irq not convert to hardirq.h
> 
> But anyway will be worth to remove it from other archs too.

Oh sorry, I copied the patch from various other architectures I touched
at the same time.  I have been wading throug all architectures to
convert them to asm-generic/hardirq.h and the generic ack_bad_irq and
sent out lots of patches for it.  A couple of architectures do count
bad irqs instead of just printing a message, but even those counters
could be unified.  The only genirq architectecture that does something
weird in ack_bad_irq is mips.

--


Subject: microblaze: use the generic ack_bad_irq implementation
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/microblaze/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/hardirq.h	2009-07-27 14:32:58.596148711 +0200
+++ linux-2.6/arch/microblaze/include/asm/hardirq.h	2009-07-27 14:56:30.691912378 +0200
@@ -12,8 +12,6 @@
 /* should be defined in each interrupt controller driver */
 extern unsigned int get_irq(struct pt_regs *regs);
 
-#define ack_bad_irq ack_bad_irq
-void ack_bad_irq(unsigned int irq);
 #include <asm-generic/hardirq.h>
 
 #endif /* _ASM_MICROBLAZE_HARDIRQ_H */
Index: linux-2.6/arch/microblaze/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/irq.c	2009-07-27 14:53:45.847149312 +0200
+++ linux-2.6/arch/microblaze/kernel/irq.c	2009-07-27 14:56:37.121902184 +0200
@@ -30,15 +30,6 @@ unsigned int irq_of_parse_and_map(struct
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 
-/*
- * 'what should we do if we get a hw irq event on an illegal vector'.
- * each architecture has to answer this themselves.
- */
-void ack_bad_irq(unsigned int irq)
-{
-	printk(KERN_WARNING "unexpected IRQ trap at vector %02x\n", irq);
-}
-
 static u32 concurrent_irq;
 
 void do_IRQ(struct pt_regs *regs)
