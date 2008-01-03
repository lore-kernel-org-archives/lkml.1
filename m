Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbYACH0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbYACH0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbYACHYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:32 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:42078 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYACHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:20 -0500
Message-Id: <20080103072226.934978594@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:11 -0500
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
Subject: [RFC PATCH 02/11] Add fastcall to do_IRQ for i386
Content-Disposition: inline; filename=mcount-fix-i386-do_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCOUNT will disable the regparm parameters of the i386 compile
options. When doing so, this breaks the prototype of do_IRQ
where the fastcall must be explicitly called.

Also fixed some whitespace damage in the call to do_IRQ.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/irq_32.c |    2 +-
 include/asm-x86/irq_32.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-compile.git/arch/x86/kernel/irq_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/irq_32.c	2007-12-20 00:20:29.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/irq_32.c	2007-12-20 00:21:55.000000000 -0500
@@ -67,7 +67,7 @@ static union irq_ctx *softirq_ctx[NR_CPU
  * handlers).
  */
 fastcall unsigned int do_IRQ(struct pt_regs *regs)
-{	
+{
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
Index: linux-compile.git/include/asm-x86/irq_32.h
===================================================================
--- linux-compile.git.orig/include/asm-x86/irq_32.h	2007-12-20 00:20:29.000000000 -0500
+++ linux-compile.git/include/asm-x86/irq_32.h	2007-12-20 00:21:55.000000000 -0500
@@ -41,7 +41,7 @@ extern int irqbalance_disable(char *str)
 extern void fixup_irqs(cpumask_t map);
 #endif
 
-unsigned int do_IRQ(struct pt_regs *regs);
+fastcall unsigned int do_IRQ(struct pt_regs *regs);
 void init_IRQ(void);
 void __init native_init_IRQ(void);
 

-- 
