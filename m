Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbXGYMIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbXGYMIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXGYMIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:12 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33027 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059AbXGYMIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:11 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7KBX032182@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix tick timer definition for coldfire
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CLOCK_TICK_RATE should give the underlying frequency of the tick timer,
to make ntp happy.  For Coldfires, that's the main clock.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/include/asm-m68knommu/timex.h linux-2.6.22-uc0/include/asm-m68knommu/timex.h
--- linux-2.6.22/include/asm-m68knommu/timex.h	2007-07-12 15:21:55.000000000 +1000
+++ linux-2.6.22-uc0/include/asm-m68knommu/timex.h	2007-07-12 15:23:59.000000000 +1000
@@ -1 +1,23 @@
-#include <asm-m68k/timex.h>
+/*
+ * linux/include/asm-m68knommu/timex.h
+ *
+ * m68knommu architecture timex specifications
+ */
+#ifndef _ASM_M68KNOMMU_TIMEX_H
+#define _ASM_M68KNOMMU_TIMEX_H
+
+#ifdef CONFIG_COLDFIRE
+#include <asm/coldfire.h>
+#define CLOCK_TICK_RATE	MCF_CLK
+#else
+#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+#endif
+
+typedef unsigned long cycles_t;
+
+static inline cycles_t get_cycles(void)
+{
+	return 0;
+}
+
+#endif
