Return-Path: <linux-kernel-owner+w=401wt.eu-S1750984AbYKGFqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbYKGFqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYKGFoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:22 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60941 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbYKGFoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:19 -0500
Message-Id: <20081107053350.207895822@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org
Subject: [RFC patch 10/18] Sparc64 : Trace clock
Content-Disposition: inline; filename=sparc64-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement sparc64 trace clock.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: David Miller <davem@davemloft.net>
CC: linux-arch@vger.kernel.org
---
 arch/sparc/include/asm/trace-clock.h |   46 +++++++++++++++++++++++++++++++++++
 arch/sparc64/Kconfig                 |    1 
 2 files changed, 47 insertions(+)

Index: linux.trees.git/arch/sparc64/Kconfig
===================================================================
--- linux.trees.git.orig/arch/sparc64/Kconfig	2008-11-07 00:09:35.000000000 -0500
+++ linux.trees.git/arch/sparc64/Kconfig	2008-11-07 00:12:26.000000000 -0500
@@ -16,6 +16,7 @@ config SPARC64
 	select HAVE_GET_CYCLES
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
+	select HAVE_TRACE_CLOCK
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_ARCH_TRACEHOOK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
Index: linux.trees.git/arch/sparc/include/asm/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/sparc/include/asm/trace-clock.h	2008-11-07 00:12:04.000000000 -0500
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2008, Mathieu Desnoyers
+ *
+ * Trace clock definitions for Sparc64.
+ */
+
+#ifndef _ASM_SPARC_TRACE_CLOCK_H
+#define _ASM_SPARC_TRACE_CLOCK_H
+
+#include <linux/timex.h>
+
+static inline u32 trace_clock_read32(void)
+{
+	return get_cycles();
+}
+
+static inline u64 trace_clock_read64(void)
+{
+	return get_cycles();
+}
+
+static inline void trace_clock_add_timestamp(unsigned long ticks)
+{ }
+
+static inline unsigned int trace_clock_frequency(void)
+{
+	return get_cycles_rate();
+}
+
+static inline u32 trace_clock_freq_scale(void)
+{
+	return 1;
+}
+
+static inline void get_trace_clock(void)
+{
+}
+
+static inline void put_trace_clock(void)
+{
+}
+
+static inline void set_trace_clock_is_sync(int state)
+{
+}
+#endif /* _ASM_SPARC_TRACE_CLOCK_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
