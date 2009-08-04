Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZHDOtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZHDOtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZHDOtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:49:17 -0400
Received: from verein.lst.de ([213.95.11.210]:39694 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZHDOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:49:17 -0400
Date: Tue, 4 Aug 2009 16:49:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] avr32: convert to asm-generic/hardirq.h
Message-ID: <20090804144915.GB20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/avr32/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/hardirq.h	2009-07-27 14:32:58.176148833 +0200
+++ linux-2.6/arch/avr32/include/asm/hardirq.h	2009-07-27 14:55:09.473900894 +0200
@@ -1,23 +1,6 @@
 #ifndef __ASM_AVR32_HARDIRQ_H
 #define __ASM_AVR32_HARDIRQ_H
-
-#include <linux/threads.h>
-#include <asm/irq.h>
-
 #ifndef __ASSEMBLY__
-
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-void ack_bad_irq(unsigned int irq);
-
-/* Standard mappings for irq_cpustat_t above */
-#include <linux/irq_cpustat.h>
-
+#include <asm-generic/hardirq.h>
 #endif /* __ASSEMBLY__ */
-
 #endif /* __ASM_AVR32_HARDIRQ_H */
Index: linux-2.6/arch/avr32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/irq.c	2009-07-27 14:53:45.527898583 +0200
+++ linux-2.6/arch/avr32/kernel/irq.c	2009-07-27 14:54:14.923902819 +0200
@@ -16,15 +16,6 @@
 #include <linux/seq_file.h>
 #include <linux/sysdev.h>
 
-/*
- * 'what should we do if we get a hw irq event on an illegal vector'.
- * each architecture has to answer this themselves.
- */
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ %u\n", irq);
-}
-
 /* May be overridden by platform code */
 int __weak nmi_enable(void)
 {
