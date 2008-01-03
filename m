Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYACHZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYACHZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYACHYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:19 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:60169 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYACHYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:13 -0500
Message-Id: <20080103072227.246140689@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:13 -0500
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
Subject: [RFC PATCH 04/11] i386: notrace annotations
Content-Disposition: inline; filename=mcount-add-i386-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From patch-2.6.21.5-rt20. Annotates functions that should not be profiler
instrumented, i.e. where mcount should not be called at function entry.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/apic_32.c  |    2 +-
 arch/x86/kernel/hpet.c     |    2 +-
 arch/x86/kernel/irq_32.c   |    2 +-
 arch/x86/kernel/nmi_32.c   |    2 +-
 arch/x86/kernel/smp_32.c   |    2 +-
 arch/x86/kernel/time_32.c  |    2 +-
 arch/x86/kernel/traps_32.c |    4 ++--
 arch/x86/kernel/tsc_32.c   |    2 +-
 arch/x86/lib/delay_32.c    |    6 +++---
 arch/x86/mm/fault_32.c     |    4 ++--
 arch/x86/mm/init_32.c      |    2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)
---

Index: linux-compile.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/apic_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/apic_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -577,7 +577,7 @@ static void local_apic_timer_interrupt(v
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
 
-void fastcall smp_apic_timer_interrupt(struct pt_regs *regs)
+notrace fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
Index: linux-compile.git/arch/x86/kernel/hpet.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/hpet.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/hpet.c	2008-01-02 22:56:41.000000000 -0500
@@ -295,7 +295,7 @@ static int hpet_legacy_next_event(unsign
 /*
  * Clock source related code
  */
-static cycle_t read_hpet(void)
+static notrace cycle_t read_hpet(void)
 {
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
Index: linux-compile.git/arch/x86/kernel/irq_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/irq_32.c	2008-01-02 22:56:34.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/irq_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -66,7 +66,7 @@ static union irq_ctx *softirq_ctx[NR_CPU
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-fastcall unsigned int do_IRQ(struct pt_regs *regs)
+notrace fastcall unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
Index: linux-compile.git/arch/x86/kernel/nmi_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/nmi_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/nmi_32.c	2008-01-02 22:57:52.000000000 -0500
@@ -323,7 +323,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 extern void die_nmi(struct pt_regs *, const char *msg);
 
-__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 
 	/*
Index: linux-compile.git/arch/x86/kernel/smp_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/smp_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/smp_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -638,7 +638,7 @@ static void native_smp_send_stop(void)
  * all the work is done automatically when
  * we return from the interrupt.
  */
-fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
+notrace fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	__get_cpu_var(irq_stat).irq_resched_count++;
Index: linux-compile.git/arch/x86/kernel/time_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/time_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/time_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -122,7 +122,7 @@ static int set_rtc_mmss(unsigned long no
 
 int timer_ack;
 
-unsigned long profile_pc(struct pt_regs *regs)
+notrace unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
 
Index: linux-compile.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/traps_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/traps_32.c	2008-01-02 22:58:19.000000000 -0500
@@ -723,7 +723,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	do_exit(SIGSEGV);
 }
 
-static __kprobes void default_do_nmi(struct pt_regs * regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -763,7 +763,7 @@ static __kprobes void default_do_nmi(str
 
 static int ignore_nmis;
 
-fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
+notrace fastcall __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 
Index: linux-compile.git/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/tsc_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/tsc_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -269,7 +269,7 @@ core_initcall(cpufreq_tsc);
 
 static unsigned long current_tsc_khz = 0;
 
-static cycle_t read_tsc(void)
+static notrace cycle_t read_tsc(void)
 {
 	cycle_t ret;
 
Index: linux-compile.git/arch/x86/lib/delay_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/lib/delay_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/lib/delay_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -24,7 +24,7 @@
 #endif
 
 /* simple loop based delay: */
-static void delay_loop(unsigned long loops)
+static notrace void delay_loop(unsigned long loops)
 {
 	int d0;
 
@@ -39,7 +39,7 @@ static void delay_loop(unsigned long loo
 }
 
 /* TSC based delay: */
-static void delay_tsc(unsigned long loops)
+static notrace void delay_tsc(unsigned long loops)
 {
 	unsigned long bclock, now;
 
@@ -72,7 +72,7 @@ int read_current_timer(unsigned long *ti
 	return -1;
 }
 
-void __delay(unsigned long loops)
+notrace void __delay(unsigned long loops)
 {
 	delay_fn(loops);
 }
Index: linux-compile.git/arch/x86/mm/fault_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/mm/fault_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/mm/fault_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -293,8 +293,8 @@ int show_unhandled_signals = 1;
  *	bit 3 == 1 means use of reserved bit detected
  *	bit 4 == 1 means fault was an instruction fetch
  */
-fastcall void __kprobes do_page_fault(struct pt_regs *regs,
-				      unsigned long error_code)
+notrace fastcall void __kprobes do_page_fault(struct pt_regs *regs,
+					      unsigned long error_code)
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
Index: linux-compile.git/arch/x86/mm/init_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/mm/init_32.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/mm/init_32.c	2008-01-02 22:56:41.000000000 -0500
@@ -200,7 +200,7 @@ static inline int page_kills_ppro(unsign
 	return 0;
 }
 
-int page_is_ram(unsigned long pagenr)
+notrace int page_is_ram(unsigned long pagenr)
 {
 	int i;
 	unsigned long addr, end;

-- 
