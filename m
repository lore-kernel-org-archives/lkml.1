Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbXK2AlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbXK2AlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbXK2AlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:41:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbXK2AlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:41:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 3/6] x86-32 ptrace whitespace
In-Reply-To: Roland McGrath's message of  Wednesday, 28 November 2007 16:38:49 -0800 <20071129003849.428E026F8E7@magilla.localdomain>
References: <20071129003849.428E026F8E7@magilla.localdomain>
X-Shopping-List: (1) Hypothetical approval
   (2) Odious persecuters
   (3) Fat erosion
Message-Id: <20071129004052.65B3026F8EA@magilla.localdomain>
Date: Wed, 28 Nov 2007 16:40:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This canonicalizes the indentation in the getreg and putreg functions.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |  110 +++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index f81e2f1..5aca84e 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -51,37 +51,37 @@ static int putreg(struct task_struct *child,
 	struct pt_regs *regs = task_pt_regs(child);
 	regno >>= 2;
 	switch (regno) {
-		case GS:
-			if (value && (value & 3) != 3)
-				return -EIO;
-			child->thread.gs = value;
-			return 0;
-		case DS:
-		case ES:
-		case FS:
-			if (value && (value & 3) != 3)
-				return -EIO;
-			value &= 0xffff;
-			break;
-		case SS:
-		case CS:
-			if ((value & 3) != 3)
-				return -EIO;
-			value &= 0xffff;
-			break;
-		case EFL:
-			value &= FLAG_MASK;
-			/*
-			 * If the user value contains TF, mark that
-			 * it was not "us" (the debugger) that set it.
-			 * If not, make sure it stays set if we had.
-			 */
-			if (value & X86_EFLAGS_TF)
-				clear_tsk_thread_flag(child, TIF_FORCED_TF);
-			else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-				value |= X86_EFLAGS_TF;
-			value |= regs->flags & ~FLAG_MASK;
-			break;
+	case GS:
+		if (value && (value & 3) != 3)
+			return -EIO;
+		child->thread.gs = value;
+		return 0;
+	case DS:
+	case ES:
+	case FS:
+		if (value && (value & 3) != 3)
+			return -EIO;
+		value &= 0xffff;
+		break;
+	case SS:
+	case CS:
+		if ((value & 3) != 3)
+			return -EIO;
+		value &= 0xffff;
+		break;
+	case EFL:
+		value &= FLAG_MASK;
+		/*
+		 * If the user value contains TF, mark that
+		 * it was not "us" (the debugger) that set it.
+		 * If not, make sure it stays set if we had.
+		 */
+		if (value & X86_EFLAGS_TF)
+			clear_tsk_thread_flag(child, TIF_FORCED_TF);
+		else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			value |= X86_EFLAGS_TF;
+		value |= regs->flags & ~FLAG_MASK;
+		break;
 	}
 	*pt_regs_access(regs, regno) = value;
 	return 0;
@@ -94,26 +94,26 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 
 	regno >>= 2;
 	switch (regno) {
-		case EFL:
-			/*
-			 * If the debugger set TF, hide it from the readout.
-			 */
-			retval = regs->flags;
-			if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-				retval &= ~X86_EFLAGS_TF;
-			break;
-		case GS:
-			retval = child->thread.gs;
-			break;
-		case DS:
-		case ES:
-		case FS:
-		case SS:
-		case CS:
-			retval = 0xffff;
-			/* fall through */
-		default:
-			retval &= *pt_regs_access(regs, regno);
+	case EFL:
+		/*
+		 * If the debugger set TF, hide it from the readout.
+		 */
+		retval = regs->flags;
+		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			retval &= ~X86_EFLAGS_TF;
+		break;
+	case GS:
+		retval = child->thread.gs;
+		break;
+	case DS:
+	case ES:
+	case FS:
+	case SS:
+	case CS:
+		retval = 0xffff;
+		/* fall through */
+	default:
+		retval &= *pt_regs_access(regs, regno);
 	}
 	return retval;
 }
@@ -190,7 +190,7 @@ static int ptrace_set_debugreg(struct task_struct *child,
  * Make sure the single step bit is not set.
  */
 void ptrace_disable(struct task_struct *child)
-{ 
+{
 	user_disable_single_step(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 }
@@ -203,7 +203,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
+	case PTRACE_PEEKTEXT: /* read word at location addr. */
 	case PTRACE_PEEKDATA:
 		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
@@ -213,7 +213,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 || 
+		if ((addr & 3) || addr < 0 ||
 		    addr > sizeof(struct user) - 3)
 			break;
 
@@ -238,7 +238,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 || 
+		if ((addr & 3) || addr < 0 ||
 		    addr > sizeof(struct user) - 3)
 			break;
 
