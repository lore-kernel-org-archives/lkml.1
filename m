Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYJPX5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYJPX5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYJPXzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48838 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYJPXzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:40 -0400
Message-Id: <20081016234655.893647148@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 19:27:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>
Subject: [RFC patch 03/15] get_cycles() : sparc64 HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-sparc64-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 16 Oct 2008 23:54:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
get_cycles_rate() are implemented.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 arch/sparc/include/asm/timex_64.h |   17 ++++++++++++++++-
 arch/sparc64/Kconfig              |    1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2008-10-16 13:07:04.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2008-10-16 18:14:45.000000000 -0400
@@ -14,6 +14,7 @@ config SPARC64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_IDE
+	select HAVE_GET_CYCLES
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
 	select USE_GENERIC_SMP_HELPERS if SMP
Index: linux-2.6-lttng/arch/sparc/include/asm/timex_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/timex_64.h	2008-10-16 13:07:04.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/include/asm/timex_64.h	2008-10-16 18:14:25.000000000 -0400
@@ -12,7 +12,22 @@
 
 /* Getting on the cycle counter on sparc64. */
 typedef unsigned long cycles_t;
-#define get_cycles()	tick_ops->get_tick()
+
+static inline cycles_t get_cycles(void)
+{
+	return tick_ops->get_tick();
+}
+
+/* get_cycles instruction is synchronized on sparc64 */
+static inline void get_cycles_barrier(void)
+{
+	return;
+}
+
+static inline cycles_t get_cycles_rate(void)
+{
+	return CLOCK_TICK_RATE;
+}
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
