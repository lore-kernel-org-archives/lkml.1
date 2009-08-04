Return-Path: <linux-kernel-owner+w=401wt.eu-S932831AbZHDO5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbZHDO5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932822AbZHDO53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:57:29 -0400
Received: from verein.lst.de ([213.95.11.210]:60786 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814AbZHDO51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:57:27 -0400
Date: Tue, 4 Aug 2009 16:57:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] xtensa: convert to asm-generic/hardirq.h
Message-ID: <20090804145726.GO20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also remove lots of unused irq_cpustat fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/xtensa/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/hardirq.h	2009-07-27 14:32:59.096148862 +0200
+++ linux-2.6/arch/xtensa/include/asm/hardirq.h	2009-07-27 14:57:53.327900849 +0200
@@ -11,18 +11,9 @@
 #ifndef _XTENSA_HARDIRQ_H
 #define _XTENSA_HARDIRQ_H
 
-#include <linux/cache.h>
-#include <asm/irq.h>
-
-/* headers.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned int __syscall_count;
-	struct task_struct * __ksoftirqd_task; /* waitqueue is too large */
-	unsigned int __nmi_count;	       /* arch dependent */
-} ____cacheline_aligned irq_cpustat_t;
-
 void ack_bad_irq(unsigned int irq);
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif	/* _XTENSA_HARDIRQ_H */
Index: linux-2.6/arch/xtensa/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/irq.c	2009-07-27 14:53:46.241148947 +0200
+++ linux-2.6/arch/xtensa/kernel/irq.c	2009-07-27 14:58:01.261901510 +0200
@@ -27,15 +27,6 @@ static unsigned int cached_irq_mask;
 atomic_t irq_err_count;
 
 /*
- * 'what should we do if we get a hw irq event on an illegal vector'.
- * each architecture has to answer this themselves.
- */
-void ack_bad_irq(unsigned int irq)
-{
-          printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
-/*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
