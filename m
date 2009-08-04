Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZHDOvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZHDOvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZHDOvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:51:54 -0400
Received: from verein.lst.de ([213.95.11.210]:39708 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbZHDOvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:51:54 -0400
Date: Tue, 4 Aug 2009 16:51:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-m32r@ml.linux-m32r.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] m32r: convert to asm-generic/hardirq.h
Message-ID: <20090804145136.GF20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/m32r/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/hardirq.h	2009-07-27 14:32:58.529148904 +0200
+++ linux-2.6/arch/m32r/include/asm/hardirq.h	2009-07-27 14:56:01.648152212 +0200
@@ -2,14 +2,7 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+#include <asm/irq.h>
 
 #if NR_IRQS > 256
 #define HARDIRQ_BITS	9
@@ -26,11 +19,7 @@ typedef struct {
 # error HARDIRQ_BITS is too low!
 #endif
 
-static inline void ack_bad_irq(int irq)
-{
-	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
-	BUG();
-}
+#include <asm-generic/hardirq.h>
 
 #endif /* __ASM_HARDIRQ_H */
 #endif /* __KERNEL__ */
