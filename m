Return-Path: <linux-kernel-owner+w=401wt.eu-S1764590AbZFQHLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764590AbZFQHLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZFQHLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:11:11 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60169 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbZFQHLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:11:10 -0400
Date: Wed, 17 Jun 2009 17:10:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200906170710.n5H7AxxV009015@localhost.localdomain>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h

There is nothing different required between the non-mmu and mmu
versions of hardirq.h, so merge them back into a single file.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/{hardirq_mm.h => hardirq.h} |    2 +
 arch/m68k/include/asm/hardirq_no.h                |   27 ---------------------
 2 files changed, 2 insertions(+), 27 deletions(-)
 rename arch/m68k/include/asm/{hardirq_mm.h => hardirq.h} (90%)
 delete mode 100644 arch/m68k/include/asm/hardirq_no.h

diff --git a/arch/m68k/include/asm/hardirq_mm.h b/arch/m68k/include/asm/hardirq.h
similarity index 90%
rename from arch/m68k/include/asm/hardirq_mm.h
rename to arch/m68k/include/asm/hardirq.h
index 394ee94..7167ed2 100644
--- a/arch/m68k/include/asm/hardirq_mm.h
+++ b/arch/m68k/include/asm/hardirq.h
@@ -13,4 +13,6 @@ typedef struct {
 
 #define HARDIRQ_BITS	8
 
+void ack_bad_irq(unsigned int irq);
+
 #endif
diff --git a/arch/m68k/include/asm/hardirq_no.h b/arch/m68k/include/asm/hardirq_no.h
deleted file mode 100644
index bfad281..0000000
--- a/arch/m68k/include/asm/hardirq_no.h
+++ /dev/null
@@ -1,27 +0,0 @@
-#ifndef __M68K_HARDIRQ_H
-#define __M68K_HARDIRQ_H
-
-#include <linux/cache.h>
-#include <linux/threads.h>
-#include <asm/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-#define HARDIRQ_BITS	8
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
-void ack_bad_irq(unsigned int irq);
-
-#endif /* __M68K_HARDIRQ_H */
