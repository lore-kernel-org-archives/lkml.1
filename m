Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbYACH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbYACH1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYACHYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:23 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:60193 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYACHYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:15 -0500
Message-Id: <20080103072227.408558115@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 05/11] x86_64: notrace annotations
Content-Disposition: inline; filename=mcount-add-x86_64-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "notrace" annotation to x86_64 specific files.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/head64.c      |    2 +-
 arch/x86/kernel/nmi_64.c      |    2 +-
 arch/x86/kernel/setup64.c     |    4 ++--
 arch/x86/kernel/smpboot_64.c  |    2 +-
 arch/x86/kernel/tsc_64.c      |    4 ++--
 arch/x86/kernel/vsyscall_64.c |    3 ++-
 6 files changed, 9 insertions(+), 8 deletions(-)

Index: linux-compile.git/arch/x86/kernel/head64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/head64.c	2007-12-19 21:44:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/head64.c	2007-12-20 00:52:47.000000000 -0500
@@ -46,7 +46,7 @@ static void __init copy_bootdata(char *r
 	}
 }
 
-void __init x86_64_start_kernel(char * real_mode_data)
+notrace void __init x86_64_start_kernel(char *real_mode_data)
 {
 	int i;
 
Index: linux-compile.git/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/nmi_64.c	2007-12-19 21:44:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/nmi_64.c	2007-12-20 00:51:50.000000000 -0500
@@ -314,7 +314,7 @@ void touch_nmi_watchdog(void)
  	touch_softlockup_watchdog();
 }
 
-int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 	int sum;
 	int touched = 0;
Index: linux-compile.git/arch/x86/kernel/setup64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/setup64.c	2007-12-19 21:44:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/setup64.c	2007-12-20 00:52:32.000000000 -0500
@@ -114,7 +114,7 @@ void __init setup_per_cpu_areas(void)
 	}
 } 
 
-void pda_init(int cpu)
+notrace void pda_init(int cpu)
 { 
 	struct x8664_pda *pda = cpu_pda(cpu);
 
@@ -197,7 +197,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist
  * 'CPU state barrier', nothing should get across.
  * A lot of state is already set up in PDA init.
  */
-void __cpuinit cpu_init (void)
+notrace void __cpuinit cpu_init(void)
 {
 	int cpu = stack_smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
Index: linux-compile.git/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/smpboot_64.c	2007-12-19 21:44:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/smpboot_64.c	2007-12-20 00:49:57.000000000 -0500
@@ -317,7 +317,7 @@ static inline void set_cpu_sibling_map(i
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
-void __cpuinit start_secondary(void)
+notrace __cpuinit void start_secondary(void)
 {
 	/*
 	 * Dont put anything before smp_callin(), SMP
Index: linux-compile.git/arch/x86/kernel/tsc_64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/tsc_64.c	2007-12-19 21:44:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/tsc_64.c	2007-12-20 00:49:57.000000000 -0500
@@ -248,13 +248,13 @@ __setup("notsc", notsc_setup);
 
 
 /* clock source code: */
-static cycle_t read_tsc(void)
+static notrace cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
 	return ret;
 }
 
-static cycle_t __vsyscall_fn vread_tsc(void)
+static notrace cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
 	return ret;
Index: linux-compile.git/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/vsyscall_64.c	2007-12-19 21:44:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/vsyscall_64.c	2007-12-20 00:54:53.000000000 -0500
@@ -42,7 +42,8 @@
 #include <asm/topology.h>
 #include <asm/vgtod.h>
 
-#define __vsyscall(nr) __attribute__ ((unused,__section__(".vsyscall_" #nr)))
+#define __vsyscall(nr) \
+		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
 #define __syscall_clobber "r11","rcx","memory"
 #define __pa_vsymbol(x)			\
 	({unsigned long v;  		\

-- 
