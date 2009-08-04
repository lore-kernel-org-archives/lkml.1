Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZHDOyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZHDOyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZHDOyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:54:50 -0400
Received: from verein.lst.de ([213.95.11.210]:60767 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbZHDOyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:54:49 -0400
Date: Tue, 4 Aug 2009 16:54:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: convert to asm-generic/hardirq.h
Message-ID: <20090804145441.GK20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/parisc/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/hardirq.h	2009-07-27 14:32:58.773149123 +0200
+++ linux-2.6/arch/parisc/include/asm/hardirq.h	2009-07-27 14:57:11.262901883 +0200
@@ -1,29 +1,11 @@
 /* hardirq.h: PA-RISC hard IRQ support.
  *
  * Copyright (C) 2001 Matthew Wilcox <matthew@wil.cx>
- *
- * The locking is really quite interesting.  There's a cpu-local
- * count of how many interrupts are being handled, and a global
- * lock.  An interrupt can only be serviced if the global lock
- * is free.  You can't be sure no more interrupts are being
- * serviced until you've acquired the lock and then checked
- * all the per-cpu interrupt counts are all zero.  It's a specialised
- * br_lock, and that's exactly how Sparc does it.  We don't because
- * it's more locking for us.  This way is lock-free in the interrupt path.
  */
 
 #ifndef _PARISC_HARDIRQ_H
 #define _PARISC_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned long __softirq_pending; /* set_bit is used on this */
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-void ack_bad_irq(unsigned int irq);
+#include <asm-generic/hardirq.h>
 
 #endif /* _PARISC_HARDIRQ_H */
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c	2009-07-27 14:53:45.982148913 +0200
+++ linux-2.6/arch/parisc/kernel/irq.c	2009-07-27 14:57:16.782158085 +0200
@@ -423,8 +423,3 @@ void __init init_IRQ(void)
         set_eiem(cpu_eiem);	/* EIEM : enable all external intr */
 
 }
-
-void ack_bad_irq(unsigned int irq)
-{
-	printk(KERN_WARNING "unexpected IRQ %d\n", irq);
-}
