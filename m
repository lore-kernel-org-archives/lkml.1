Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYAIXd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYAIXd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbYAIXa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:30:57 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33560 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbYAIXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:51 -0500
Message-Id: <20080109233042.700978988@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:17 -0500
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
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 03/22 -v2] x86_64: notrace annotations
Content-Disposition: inline; filename=mcount-add-x86_64-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "notrace" annotation to x86_64 specific files.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/head64.c     |    2 +-
 arch/x86/kernel/setup64.c    |    4 ++--
 arch/x86/kernel/smpboot_64.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-compile-i386.git/arch/x86/kernel/head64.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/head64.c	2008-01-09 14:09:35.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/head64.c	2008-01-09 14:10:14.000000000 -0500
@@ -46,7 +46,7 @@ static void __init copy_bootdata(char *r
 	}
 }
 
-void __init x86_64_start_kernel(char * real_mode_data)
+notrace void __init x86_64_start_kernel(char *real_mode_data)
 {
 	int i;
 
Index: linux-compile-i386.git/arch/x86/kernel/setup64.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/setup64.c	2008-01-09 14:09:35.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/setup64.c	2008-01-09 14:10:14.000000000 -0500
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
Index: linux-compile-i386.git/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/smpboot_64.c	2008-01-09 14:09:35.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/smpboot_64.c	2008-01-09 14:10:14.000000000 -0500
@@ -317,7 +317,7 @@ static inline void set_cpu_sibling_map(i
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
-void __cpuinit start_secondary(void)
+notrace __cpuinit void start_secondary(void)
 {
 	/*
 	 * Dont put anything before smp_callin(), SMP

-- 
