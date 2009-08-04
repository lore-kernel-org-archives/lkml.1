Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZHDOv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZHDOv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZHDOv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:51:26 -0400
Received: from verein.lst.de ([213.95.11.210]:39705 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbZHDOv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:51:26 -0400
Date: Tue, 4 Aug 2009 16:51:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] h8300: convert to asm-generic/hardirq.h
Message-ID: <20090804145104.GE20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/h8300/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/hardirq.h	2009-07-27 14:32:58.383148670 +0200
+++ linux-2.6/arch/h8300/include/asm/hardirq.h	2009-07-27 14:55:42.321901764 +0200
@@ -1,18 +1,7 @@
 #ifndef __H8300_HARDIRQ_H
 #define __H8300_HARDIRQ_H
 
-#include <linux/kernel.h>
-#include <linux/threads.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-extern void ack_bad_irq(unsigned int irq);
+#include <asm/irq.h>
 
 #define HARDIRQ_BITS	8
 
@@ -25,4 +14,6 @@ extern void ack_bad_irq(unsigned int irq
 # error HARDIRQ_BITS is too low!
 #endif
 
+#include <asm-generic/hardirq.h>
+
 #endif
Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c	2009-07-27 14:53:45.658148907 +0200
+++ linux-2.6/arch/h8300/kernel/irq.c	2009-07-27 14:55:35.116901397 +0200
@@ -81,11 +81,6 @@ struct irq_chip h8300irq_chip = {
 	.end		= h8300_end_irq,
 };
 
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
 #if defined(CONFIG_RAMKERNEL)
 static unsigned long __init *get_vector_address(void)
 {
