Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578AbYKGFsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbYKGFsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbYKGFoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:46 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60993 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbYKGFol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:41 -0500
Message-Id: <20081107053349.215096700@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [RFC patch 04/18] get_cycles() : powerpc64 HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-powerpc-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:22 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
get_cycles_rate() are implemented.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 arch/powerpc/Kconfig             |    1 +
 arch/powerpc/include/asm/timex.h |   11 +++++++++++
 2 files changed, 12 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig	2008-11-07 00:09:44.000000000 -0500
+++ linux.trees.git/arch/powerpc/Kconfig	2008-11-07 00:09:46.000000000 -0500
@@ -121,6 +121,7 @@ config PPC
 	select HAVE_DMA_ATTRS if PPC64
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select HAVE_GET_CYCLES if PPC64
 
 config EARLY_PRINTK
 	bool
Index: linux.trees.git/arch/powerpc/include/asm/timex.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/timex.h	2008-11-07 00:09:44.000000000 -0500
+++ linux.trees.git/arch/powerpc/include/asm/timex.h	2008-11-07 00:09:46.000000000 -0500
@@ -7,6 +7,7 @@
  * PowerPC architecture timex specifications
  */
 
+#include <linux/time.h>
 #include <asm/cputable.h>
 #include <asm/reg.h>
 
@@ -46,5 +47,15 @@ static inline cycles_t get_cycles(void)
 #endif
 }
 
+static inline cycles_t get_cycles_rate(void)
+{
+	return tb_ticks_per_sec;
+}
+
+static inline void get_cycles_barrier(void)
+{
+	isync();
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TIMEX_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
