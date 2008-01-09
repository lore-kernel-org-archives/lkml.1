Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYAIXfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYAIXfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYAIXbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:07 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37805 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbYAIXay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:54 -0500
Message-Id: <20080109233043.021631030@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:19 -0500
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
Subject: [RFC PATCH 05/22 -v2] add notrace annotations for NMI routines
Content-Disposition: inline; filename=mcount-nmi-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This annotates NMI functions with notrace. Some tracers may be able
to live with this, but some cannot. So we turn off NMI tracing.

One solution might be to make a notrace_nmi which would only turn
off NMI tracing if a trace utility needed it off.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 arch/x86/kernel/nmi_32.c   |    2 +-
 arch/x86/kernel/nmi_64.c   |    2 +-
 arch/x86/kernel/traps_32.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-compile-i386.git/arch/x86/kernel/nmi_32.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/nmi_32.c	2008-01-09 14:07:36.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/nmi_32.c	2008-01-09 14:10:29.000000000 -0500
@@ -323,7 +323,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 extern void die_nmi(struct pt_regs *, const char *msg);
 
-__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 
 	/*
Index: linux-compile-i386.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/traps_32.c	2008-01-09 14:07:36.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/traps_32.c	2008-01-09 14:10:29.000000000 -0500
@@ -722,7 +722,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	do_exit(SIGSEGV);
 }
 
-static __kprobes void default_do_nmi(struct pt_regs * regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -762,7 +762,7 @@ static __kprobes void default_do_nmi(str
 
 static int ignore_nmis;
 
-fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
+notrace fastcall __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 
Index: linux-compile-i386.git/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/nmi_64.c	2008-01-09 14:07:36.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/nmi_64.c	2008-01-09 14:10:29.000000000 -0500
@@ -314,7 +314,7 @@ void touch_nmi_watchdog(void)
  	touch_softlockup_watchdog();
 }
 
-int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 	int sum;
 	int touched = 0;

-- 
