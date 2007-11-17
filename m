Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbXKQXHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbXKQXHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 18:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXKQXH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 18:07:27 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:21122 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbXKQXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 18:07:26 -0500
Date: Sun, 18 Nov 2007 00:07:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: annotate do_debug() trap handler
Message-ID: <20071117230722.GC25905@dyad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: annotate do_debug() trap handler

Ensure the hardirq state is consistent before using locks. Use the rare
trace_hardirqs_fixup() because the trap can happen in any context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/traps_32.c |    2 ++
 arch/x86/kernel/traps_64.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6/arch/x86/kernel/traps_32.c
@@ -830,6 +830,8 @@ fastcall void __kprobes do_debug(struct 
 	unsigned int condition;
 	struct task_struct *tsk = current;
 
+	trace_hardirqs_fixup();
+
 	get_debugreg(condition, 6);
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
Index: linux-2.6/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6/arch/x86/kernel/traps_64.c
@@ -840,6 +840,8 @@ asmlinkage void __kprobes do_debug(struc
 	struct task_struct *tsk = current;
 	siginfo_t info;
 
+	trace_hardirqs_fixup();
+
 	get_debugreg(condition, 6);
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
