Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYKLXeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYKLXeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYKLXd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:33:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48424 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbYKLXd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:33:56 -0500
Message-Id: <20081112232259.532205434@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:15:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, benh@kernel.crashing.org,
       paulus@samba.org, linux-arch@vger.kernel.org
Subject: [patch 08/17] Powerpc : Trace clock
Content-Disposition: inline; filename=powerpc-trace-clock.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc implementation of trace clock with get_tb().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: linux-arch@vger.kernel.org
---
 arch/powerpc/Kconfig                   |    1 
 arch/powerpc/include/asm/trace-clock.h |   47 +++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig	2008-11-12 18:00:10.000000000 -0500
+++ linux.trees.git/arch/powerpc/Kconfig	2008-11-12 18:01:20.000000000 -0500
@@ -114,6 +114,7 @@ config PPC
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_KPROBES
+	select HAVE_TRACE_CLOCK
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
Index: linux.trees.git/arch/powerpc/include/asm/trace-clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/powerpc/include/asm/trace-clock.h	2008-11-12 18:01:20.000000000 -0500
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2005,2008 Mathieu Desnoyers
+ *
+ * Trace clock PowerPC definitions.
+ *
+ * Use get_tb() directly to insure reading a 64-bits value on powerpc 32.
+ */
+
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <linux/timex.h>
+#include <linux/time.h>
+#include <asm/processor.h>
+
+static inline u32 trace_clock_read32(void)
+{
+	return get_tbl();
+}
+
+static inline u64 trace_clock_read64(void)
+{
+	return get_tb();
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
+#endif /* _ASM_TRACE_CLOCK_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
