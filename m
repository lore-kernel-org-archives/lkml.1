Return-Path: <linux-kernel-owner+w=401wt.eu-S1751595AbYKGFrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbYKGFrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYKGFol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:41 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60987 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbYKGFoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:39 -0500
Message-Id: <20081107053348.889354279@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [RFC patch 02/18] get_cycles() : x86 HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-x86-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:22 +0000
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
--- linux.trees.git.orig/arch/x86/Kconfig	2008-11-07 00:06:06.000000000 -0500
+++ linux.trees.git/arch/x86/Kconfig	2008-11-07 00:09:33.000000000 -0500
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
--- linux.trees.git.orig/arch/x86/include/asm/tsc.h	2008-10-30 20:22:50.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/tsc.h	2008-11-07 00:09:33.000000000 -0500
@@ -50,6 +50,18 @@ extern void mark_tsc_unstable(char *reas
 extern int unsynchronized_tsc(void);
 int check_tsc_unstable(void);
 
+static inline cycles_t get_cycles_rate(void)
+{
+	if (check_tsc_unstable())
+		return 0;
+	return tsc_khz;
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
