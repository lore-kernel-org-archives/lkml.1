Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbXIJNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbXIJNBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXIJNB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:01:28 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43622
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758135AbXIJNB1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:01:27 -0400
Message-Id: <46E55C79.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Sep 2007 14:02:17 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: constify stacktrace_ops
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. as they're never written to.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/traps.c        |    6 +++---
 arch/x86_64/kernel/stacktrace.c |    2 +-
 arch/x86_64/kernel/traps.c      |    4 ++--
 include/asm-x86_64/stacktrace.h |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.23-rc5/arch/i386/kernel/traps.c	2007-09-07 16:44:45.000000000 +0200
+++ 2.6.23-rc5-x86-const-stacktrace_ops/arch/i386/kernel/traps.c	2007-08-28 17:39:12.000000000 +0200
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
--- linux-2.6.23-rc5/arch/x86_64/kernel/stacktrace.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc5-x86-const-stacktrace_ops/arch/x86_64/kernel/stacktrace.c	2007-08-28 17:38:06.000000000 +0200
@@ -35,7 +35,7 @@ static void save_stack_address(void *dat
 		trace->entries[trace->nr_entries++] = addr;
 }
 
-static struct stacktrace_ops save_stack_ops = {
+static const struct stacktrace_ops save_stack_ops = {
 	.warning = save_stack_warning,
 	.warning_symbol = save_stack_warning_symbol,
 	.stack = save_stack_stack,
--- linux-2.6.23-rc5/arch/x86_64/kernel/traps.c	2007-09-07 16:45:27.000000000 +0200
+++ 2.6.23-rc5-x86-const-stacktrace_ops/arch/x86_64/kernel/traps.c	2007-08-28 17:38:39.000000000 +0200
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
--- linux-2.6.23-rc5/include/asm-x86_64/stacktrace.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.23-rc5-x86-const-stacktrace_ops/include/asm-x86_64/stacktrace.h	2007-08-28 17:37:55.000000000 +0200
@@ -15,6 +15,6 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
-		struct stacktrace_ops *ops, void *data);
+		const struct stacktrace_ops *ops, void *data);
 
 #endif



