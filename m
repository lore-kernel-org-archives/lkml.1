Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZHDOty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZHDOty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZHDOtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:49:53 -0400
Received: from verein.lst.de ([213.95.11.210]:39697 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZHDOtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:49:53 -0400
Date: Tue, 4 Aug 2009 16:49:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cris: convert to asm-generic/hardirq.h
Message-ID: <20090804144952.GC20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/cris/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/hardirq.h	2009-07-27 14:32:58.267148765 +0200
+++ linux-2.6/arch/cris/include/asm/hardirq.h	2009-07-27 14:55:19.652910119 +0200
@@ -2,16 +2,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-#include <linux/threads.h>
-#include <linux/cache.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
-
-void ack_bad_irq(unsigned int irq);
 
 #define HARDIRQ_BITS	8
 
@@ -24,4 +14,6 @@ void ack_bad_irq(unsigned int irq);
 # error HARDIRQ_BITS is too low!
 #endif
 
+#include <asm-generic/hardirq.h>
+
 #endif /* __ASM_HARDIRQ_H */
Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c	2009-07-27 14:53:45.590898928 +0200
+++ linux-2.6/arch/cris/kernel/irq.c	2009-07-27 14:54:58.635901441 +0200
@@ -38,11 +38,6 @@
 
 #include <asm/io.h>
 
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
