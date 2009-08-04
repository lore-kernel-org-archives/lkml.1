Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZHDOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZHDOw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZHDOw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:52:56 -0400
Received: from verein.lst.de ([213.95.11.210]:39714 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZHDOwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:52:55 -0400
Date: Tue, 4 Aug 2009 16:52:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: gerg@uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] m68knommu: convert to asm-generic/hardirq.h
Message-ID: <20090804145244.GH20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 1.051 (*) BAYES_40,DOMAIN_BODY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/m68k/include/asm/hardirq_no.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/hardirq_no.h	2009-07-27 14:35:39.630898799 +0200
+++ linux-2.6/arch/m68k/include/asm/hardirq_no.h	2009-07-27 14:56:09.546901120 +0200
@@ -1,16 +1,8 @@
 #ifndef __M68K_HARDIRQ_H
 #define __M68K_HARDIRQ_H
 
-#include <linux/cache.h>
-#include <linux/threads.h>
 #include <asm/irq.h>
 
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 #define HARDIRQ_BITS	8
 
 /*
@@ -23,5 +15,8 @@ typedef struct {
 #endif
 
 void ack_bad_irq(unsigned int irq);
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif /* __M68K_HARDIRQ_H */
Index: linux-2.6/arch/m68knommu/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/irq.c	2009-07-27 14:53:45.783148910 +0200
+++ linux-2.6/arch/m68knommu/kernel/irq.c	2009-07-27 14:56:18.687931620 +0200
@@ -29,11 +29,6 @@ asmlinkage void do_IRQ(int irq, struct p
 	set_irq_regs(oldregs);
 }
 
-void ack_bad_irq(unsigned int irq)
-{
-	printk(KERN_ERR "IRQ: unexpected irq=%d\n", irq);
-}
-
 static struct irq_chip m_irq_chip = {
 	.name		= "M68K-INTC",
 	.enable		= enable_vector,
