Return-Path: <linux-kernel-owner+w=401wt.eu-S1762448AbXK2Alb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762448AbXK2Alb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbXK2AlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:41:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000AbXK2AlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:41:07 -0500
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
Subject: [PATCH x86/mm 2/6] x86-64 ptrace whitespace
In-Reply-To: Roland McGrath's message of  Wednesday, 28 November 2007 16:38:49 -0800 <20071129003849.428E026F8E7@magilla.localdomain>
References: <20071129003849.428E026F8E7@magilla.localdomain>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20071129004028.006B026F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 16:40:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This canonicalizes the indentation in the getreg and putreg functions.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_64.c |  224 +++++++++++++++++++++---------------------
 1 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 56b31cd..2427548 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -2,7 +2,7 @@
 /*
  * Pentium III FXSR, SSE support
  *	Gareth Hughes <gareth@valinux.com>, May 2000
- * 
+ *
  * x86-64 port 2000-2002 Andi Kleen
  */
 
@@ -48,7 +48,7 @@
  * Make sure the single step bit is not set.
  */
 void ptrace_disable(struct task_struct *child)
-{ 
+{
 	user_disable_single_step(child);
 }
 
@@ -63,69 +63,69 @@ static int putreg(struct task_struct *child,
 {
 	struct pt_regs *regs = task_pt_regs(child);
 	switch (regno) {
-		case offsetof(struct user_regs_struct,fs):
-			if (value && (value & 3) != 3)
-				return -EIO;
-			child->thread.fsindex = value & 0xffff; 
-			return 0;
-		case offsetof(struct user_regs_struct,gs):
-			if (value && (value & 3) != 3)
-				return -EIO;
-			child->thread.gsindex = value & 0xffff;
-			return 0;
-		case offsetof(struct user_regs_struct,ds):
-			if (value && (value & 3) != 3)
-				return -EIO;
-			child->thread.ds = value & 0xffff;
-			return 0;
-		case offsetof(struct user_regs_struct,es): 
-			if (value && (value & 3) != 3)
-				return -EIO;
-			child->thread.es = value & 0xffff;
-			return 0;
-		case offsetof(struct user_regs_struct,ss):
-			if ((value & 3) != 3)
-				return -EIO;
-			value &= 0xffff;
-			return 0;
-		case offsetof(struct user_regs_struct,fs_base):
-			if (value >= TASK_SIZE_OF(child))
-				return -EIO;
-			/*
-			 * When changing the segment base, use do_arch_prctl
-			 * to set either thread.fs or thread.fsindex and the
-			 * corresponding GDT slot.
-			 */
-			if (child->thread.fs != value)
-				return do_arch_prctl(child, ARCH_SET_FS, value);
-			return 0;
-		case offsetof(struct user_regs_struct,gs_base):
-			/*
-			 * Exactly the same here as the %fs handling above.
-			 */
-			if (value >= TASK_SIZE_OF(child))
-				return -EIO;
-			if (child->thread.gs != value)
-				return do_arch_prctl(child, ARCH_SET_GS, value);
-			return 0;
-		case offsetof(struct user_regs_struct,flags):
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
-		case offsetof(struct user_regs_struct,cs): 
-			if ((value & 3) != 3)
-				return -EIO;
-			value &= 0xffff;
-			break;
+	case offsetof(struct user_regs_struct,fs):
+		if (value && (value & 3) != 3)
+			return -EIO;
+		child->thread.fsindex = value & 0xffff;
+		return 0;
+	case offsetof(struct user_regs_struct,gs):
+		if (value && (value & 3) != 3)
+			return -EIO;
+		child->thread.gsindex = value & 0xffff;
+		return 0;
+	case offsetof(struct user_regs_struct,ds):
+		if (value && (value & 3) != 3)
+			return -EIO;
+		child->thread.ds = value & 0xffff;
+		return 0;
+	case offsetof(struct user_regs_struct,es):
+		if (value && (value & 3) != 3)
+			return -EIO;
+		child->thread.es = value & 0xffff;
+		return 0;
+	case offsetof(struct user_regs_struct,ss):
+		if ((value & 3) != 3)
+			return -EIO;
+		value &= 0xffff;
+		return 0;
+	case offsetof(struct user_regs_struct,fs_base):
+		if (value >= TASK_SIZE_OF(child))
+			return -EIO;
+		/*
+		 * When changing the segment base, use do_arch_prctl
+		 * to set either thread.fs or thread.fsindex and the
+		 * corresponding GDT slot.
+		 */
+		if (child->thread.fs != value)
+			return do_arch_prctl(child, ARCH_SET_FS, value);
+		return 0;
+	case offsetof(struct user_regs_struct,gs_base):
+		/*
+		 * Exactly the same here as the %fs handling above.
+		 */
+		if (value >= TASK_SIZE_OF(child))
+			return -EIO;
+		if (child->thread.gs != value)
+			return do_arch_prctl(child, ARCH_SET_GS, value);
+		return 0;
+	case offsetof(struct user_regs_struct,flags):
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
+	case offsetof(struct user_regs_struct,cs):
+		if ((value & 3) != 3)
+			return -EIO;
+		value &= 0xffff;
+		break;
 	}
 	*pt_regs_access(regs, regno) = value;
 	return 0;
@@ -136,49 +136,49 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 	struct pt_regs *regs = task_pt_regs(child);
 	unsigned long val;
 	switch (regno) {
-		case offsetof(struct user_regs_struct, fs):
-			return child->thread.fsindex;
-		case offsetof(struct user_regs_struct, gs):
-			return child->thread.gsindex;
-		case offsetof(struct user_regs_struct, ds):
-			return child->thread.ds;
-		case offsetof(struct user_regs_struct, es):
-			return child->thread.es; 
-		case offsetof(struct user_regs_struct, fs_base):
-			/*
-			 * do_arch_prctl may have used a GDT slot instead of
-			 * the MSR.  To userland, it appears the same either
-			 * way, except the %fs segment selector might not be 0.
-			 */
-			if (child->thread.fs != 0)
-				return child->thread.fs;
-			if (child->thread.fsindex != FS_TLS_SEL)
-				return 0;
-			return get_desc_base(&child->thread.tls_array[FS_TLS]);
-		case offsetof(struct user_regs_struct, gs_base):
-			/*
-			 * Exactly the same here as the %fs handling above.
-			 */
-			if (child->thread.gs != 0)
-				return child->thread.gs;
-			if (child->thread.gsindex != GS_TLS_SEL)
-				return 0;
-			return get_desc_base(&child->thread.tls_array[GS_TLS]);
-		case offsetof(struct user_regs_struct, flags):
-			/*
-			 * If the debugger set TF, hide it from the readout.
-			 */
-			val = regs->flags;
-			if (test_tsk_thread_flag(child, TIF_IA32))
-				val &= 0xffffffff;
-			if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-				val &= ~X86_EFLAGS_TF;
-			return val;
-		default:
-			val = *pt_regs_access(regs, regno);
-			if (test_tsk_thread_flag(child, TIF_IA32))
-				val &= 0xffffffff;
-			return val;
+	case offsetof(struct user_regs_struct, fs):
+		return child->thread.fsindex;
+	case offsetof(struct user_regs_struct, gs):
+		return child->thread.gsindex;
+	case offsetof(struct user_regs_struct, ds):
+		return child->thread.ds;
+	case offsetof(struct user_regs_struct, es):
+		return child->thread.es;
+	case offsetof(struct user_regs_struct, fs_base):
+		/*
+		 * do_arch_prctl may have used a GDT slot instead of
+		 * the MSR.  To userland, it appears the same either
+		 * way, except the %fs segment selector might not be 0.
+		 */
+		if (child->thread.fs != 0)
+			return child->thread.fs;
+		if (child->thread.fsindex != FS_TLS_SEL)
+			return 0;
+		return get_desc_base(&child->thread.tls_array[FS_TLS]);
+	case offsetof(struct user_regs_struct, gs_base):
+		/*
+		 * Exactly the same here as the %fs handling above.
+		 */
+		if (child->thread.gs != 0)
+			return child->thread.gs;
+		if (child->thread.gsindex != GS_TLS_SEL)
+			return 0;
+		return get_desc_base(&child->thread.tls_array[GS_TLS]);
+	case offsetof(struct user_regs_struct, flags):
+		/*
+		 * If the debugger set TF, hide it from the readout.
+		 */
+		val = regs->flags;
+		if (test_tsk_thread_flag(child, TIF_IA32))
+			val &= 0xffffffff;
+		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			val &= ~X86_EFLAGS_TF;
+		return val;
+	default:
+		val = *pt_regs_access(regs, regno);
+		if (test_tsk_thread_flag(child, TIF_IA32))
+			val &= 0xffffffff;
+		return val;
 	}
 
 }
@@ -244,7 +244,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
+	case PTRACE_PEEKTEXT: /* read word at location addr. */
 	case PTRACE_PEEKDATA:
 		ret = generic_ptrace_peekdata(child, addr, data);
 		break;
@@ -310,10 +310,10 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					 (struct user_desc __user *) data, 0);
 		break;
 #endif
-		/* normal 64bit interface to access TLS data. 
+		/* normal 64bit interface to access TLS data.
 		   Works just like arch_prctl, except that the arguments
 		   are reversed. */
-	case PTRACE_ARCH_PRCTL: 
+	case PTRACE_ARCH_PRCTL:
 		ret = do_arch_prctl(child, data, addr);
 		break;
 
@@ -386,7 +386,7 @@ static void syscall_trace(struct pt_regs *regs)
 	printk("trace %s ip %lx sp %lx ax %d origrax %d caller %lx tiflags %x ptrace %x\n",
 	       current->comm,
 	       regs->ip, regs->sp, regs->ax, regs->orig_ax, __builtin_return_address(0),
-	       current_thread_info()->flags, current->ptrace); 
+	       current_thread_info()->flags, current->ptrace);
 #endif
 
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
