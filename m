Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYKLXgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYKLXgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYKLXeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48454 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYKLXeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:04 -0500
Message-Id: <20081112232259.696466804@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:16:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "David S. Miller" <davem@davemloft.net>, linux-arch@vger.kernel.org
Subject: [patch 09/17] Sparc64 : Trace clock
Content-Disposition: inline; filename=sparc64-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement sparc64 trace clock.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: David S. Miller <davem@davemloft.net>
CC: linux-arch@vger.kernel.org
---
 arch/sparc/include/asm/trace-clock.h |   43 +++++++++++++++++++++++++++++++++++
 arch/sparc64/Kconfig                 |    1 
 2 files changed, 44 insertions(+)

Index: linux.trees.git/arch/sparc64/Kconfig
===================================================================
--- linux.trees.git.orig/arch/sparc64/Kconfig	2008-11-12 18:00:04.000000000 -0500
+++ linux.trees.git/arch/sparc64/Kconfig	2008-11-12 18:01:51.000000000 -0500
@@ -18,6 +18,7 @@ config SPARC64
 	select HAVE_ARCH_KGDB
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_TRACE_CLOCK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
Index: linux.trees.git/arch/sparc/include/asm/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/sparc/include/asm/trace-clock.h	2008-11-12 18:01:27.000000000 -0500
@@ -0,0 +1,43 @@
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
