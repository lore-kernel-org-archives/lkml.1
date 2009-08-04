Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZHDOuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZHDOuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZHDOup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:50:45 -0400
Received: from verein.lst.de ([213.95.11.210]:39700 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZHDOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:50:45 -0400
Date: Tue, 4 Aug 2009 16:50:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] frv: convert to asm-generic/hardirq.h
Message-ID: <20090804145030.GD20487@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And also remove the unused idle_timestamp field in irq_cpustat.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/frv/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/hardirq.h	2009-07-27 14:32:58.319148966 +0200
+++ linux-2.6/arch/frv/include/asm/hardirq.h	2009-07-27 14:55:22.007149596 +0200
@@ -12,24 +12,13 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned long idle_timestamp;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-#ifdef CONFIG_SMP
-#error SMP not available on FR-V
-#endif /* CONFIG_SMP */
-
 extern atomic_t irq_err_count;
 static inline void ack_bad_irq(int irq)
 {
 	atomic_inc(&irq_err_count);
 }
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif
Index: linux-2.6/arch/frv/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/process.c	2009-07-27 14:49:00.504898870 +0200
+++ linux-2.6/arch/frv/kernel/process.c	2009-07-27 14:49:06.778921938 +0200
@@ -88,8 +88,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		while (!need_resched()) {
-			irq_stat[cpu].idle_timestamp = jiffies;
-
 			check_pgt_cache();
 
 			if (!frv_dma_inprogress && idle)
