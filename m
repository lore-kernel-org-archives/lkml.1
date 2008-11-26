Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYKZNDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYKZNDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYKZM6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:58:33 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46290 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYKZM6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:58:31 -0500
Message-Id: <20081126124634.617634769@polymtl.ca>
References: <20081126124246.800751190@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 07:42:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [patch 02/17] get_cycles() : x86 HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-x86-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 26 Nov 2008 12:57:40 +0000
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
 arch/x86/Kconfig           |    1 +
 arch/x86/include/asm/tsc.h |   12 ++++++++++++
 2 files changed, 13 insertions(+)

Index: linux.trees.git/arch/x86/Kconfig
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig	2008-11-26 05:46:29.000000000 -0500
+++ linux.trees.git/arch/x86/Kconfig	2008-11-26 06:48:49.000000000 -0500
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
+	select HAVE_GET_CYCLES
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
Index: linux.trees.git/arch/x86/include/asm/tsc.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/tsc.h	2008-11-14 17:38:28.000000000 -0500
+++ linux.trees.git/arch/x86/include/asm/tsc.h	2008-11-26 06:48:49.000000000 -0500
@@ -50,6 +50,18 @@ extern void mark_tsc_unstable(char *reas
 extern int unsynchronized_tsc(void);
 int check_tsc_unstable(void);
 
+static inline cycles_t get_cycles_rate(void)
+{
+	if (check_tsc_unstable())
+		return 0;
+	return (cycles_t)tsc_khz * 1000;
+}
+
+static inline void get_cycles_barrier(void)
+{
+	rdtsc_barrier();
+}
+
 /*
  * Boot-time check whether the TSCs are synchronized across
  * all CPUs/cores:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
