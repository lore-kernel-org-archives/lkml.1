Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYJPX4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYJPX4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYJPXzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48783 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbYJPXza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:30 -0400
Message-Id: <20081016234657.210268948@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       benh@kernel.crashing.org, paulus@samba.org
Subject: [RFC patch 11/15] LTTng timestamp powerpc
Content-Disposition: inline; filename=lttng-timestamp-powerpc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: linux-arch@vger.kernel.org
---
 arch/powerpc/Kconfig      |    1 +
 include/asm-powerpc/ltt.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/ltt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/ltt.h	2008-10-16 19:18:51.000000000 -0400
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2005, Mathieu Desnoyers
+ *
+ * POWERPC definitions for tracing system
+ */
+
+#ifndef _ASM_POWERPC_LTT_H
+#define _ASM_POWERPC_LTT_H
+
+#include <linux/timex.h>
+#include <asm/time.h>
+#include <asm/processor.h>
+
+static inline u32 ltt_get_timestamp32(void)
+{
+	return get_tbl();
+}
+
+static inline u64 ltt_get_timestamp64(void)
+{
+	return get_tb();
+}
+
+static inline void ltt_add_timestamp(unsigned long ticks)
+{ }
+
+static inline unsigned int ltt_frequency(void)
+{
+	return tb_ticks_per_sec;
+}
+
+static inline u32 ltt_freq_scale(void)
+{
+	return 1;
+}
+
+#endif /* _ASM_POWERPC_LTT_H */
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2008-10-16 19:14:07.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2008-10-16 19:20:22.000000000 -0400
@@ -115,6 +115,7 @@ config PPC
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_KPROBES
+	select HAVE_LTT_CLOCK
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
