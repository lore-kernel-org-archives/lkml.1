Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbXIUUps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbXIUUps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761429AbXIUUop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:45 -0400
Received: from mail.suse.de ([195.135.220.2]:50007 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448AbXIUUoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:44 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/45] x86: constify stacktrace_ops
Message-Id: <20070921204443.1637914EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
.. as they're never written to.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/traps.c        |    6 +++---
 arch/x86_64/kernel/stacktrace.c |    2 +-
 arch/x86_64/kernel/traps.c      |    4 ++--
 include/asm-x86_64/stacktrace.h |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -114,7 +114,7 @@ struct stack_frame {
 
 static inline unsigned long print_context_stack(struct thread_info *tinfo,
 				unsigned long *stack, unsigned long ebp,
-				struct stacktrace_ops *ops, void *data)
+				const struct stacktrace_ops *ops, void *data)
 {
 #ifdef	CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)ebp;
@@ -151,7 +151,7 @@ static inline unsigned long print_contex
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	        unsigned long *stack,
-		struct stacktrace_ops *ops, void *data)
+		const struct stacktrace_ops *ops, void *data)
 {
 	unsigned long ebp = 0;
 
@@ -223,7 +223,7 @@ static void print_trace_address(void *da
 	touch_nmi_watchdog();
 }
 
-static struct stacktrace_ops print_trace_ops = {
+static const struct stacktrace_ops print_trace_ops = {
 	.warning = print_trace_warning,
 	.warning_symbol = print_trace_warning_symbol,
 	.stack = print_trace_stack,
Index: linux/arch/x86_64/kernel/stacktrace.c
===================================================================
--- linux.orig/arch/x86_64/kernel/stacktrace.c
+++ linux/arch/x86_64/kernel/stacktrace.c
@@ -35,7 +35,7 @@ static void save_stack_address(void *dat
 		trace->entries[trace->nr_entries++] = addr;
 }
 
-static struct stacktrace_ops save_stack_ops = {
+static const struct stacktrace_ops save_stack_ops = {
 	.warning = save_stack_warning,
 	.warning_symbol = save_stack_warning_symbol,
 	.stack = save_stack_stack,
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -217,7 +217,7 @@ static inline int valid_stack_ptr(struct
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 		unsigned long *stack,
-		struct stacktrace_ops *ops, void *data)
+		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
 	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
@@ -338,7 +338,7 @@ static void print_trace_address(void *da
 	printk_address(addr);
 }
 
-static struct stacktrace_ops print_trace_ops = {
+static const struct stacktrace_ops print_trace_ops = {
 	.warning = print_trace_warning,
 	.warning_symbol = print_trace_warning_symbol,
 	.stack = print_trace_stack,
Index: linux/include/asm-x86_64/stacktrace.h
===================================================================
--- linux.orig/include/asm-x86_64/stacktrace.h
+++ linux/include/asm-x86_64/stacktrace.h
@@ -15,6 +15,6 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
-		struct stacktrace_ops *ops, void *data);
+		const struct stacktrace_ops *ops, void *data);
 
 #endif
