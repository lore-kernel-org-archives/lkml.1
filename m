Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZHDOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZHDOxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZHDOxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:53:41 -0400
Received: from verein.lst.de ([213.95.11.210]:60756 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbZHDOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:53:41 -0400
Date: Tue, 4 Aug 2009 16:53:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] microblaze: convert to asm-generic/hardirq.h
Message-ID: <20090804145319.GI20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
