Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbXLLT1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbXLLT1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXLLT1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:27:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:6911 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXLLT1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S5hLHNJPC8oQMTHPDNSZEKkQW80AjCJdxIsDRxPn6yuehmOJ44rnjcg5HCSt0OG32GjO789MbgeV6YqvpxvANB72lHYcuV4cxQd39oXajQA7p5gotyCq1laZJVO9n7t8v6aHfvF3824YhZSiYn66skH3W/K1YHVVgkcV1s6iyuQ=
Subject: [PATCH] x86: Remove 'e' from kprope structure members
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47602776.10408@zytor.com>
References: <1197421087.8761.27.camel@brick>  <47602776.10408@zytor.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 11:27:22 -0800
Message-Id: <1197487642.21291.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kprobe structure members had a superfluous e in their
name.

eflags -> flags
esp -> sp

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this applies on top of my kprobes unification patch.

 arch/x86/kernel/kprobes_32.c |   34 +++++++++++++++++-----------------
 arch/x86/kernel/kprobes_64.c |   34 +++++++++++++++++-----------------
 include/asm-x86/kprobes.h    |   10 +++++-----
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 6585ec5..44bc600 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -195,26 +195,26 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_eflags = kcb->kprobe_old_eflags;
-	kcb->prev_kprobe.saved_eflags = kcb->kprobe_saved_eflags;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
 	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_eflags = kcb->prev_kprobe.old_eflags;
-	kcb->kprobe_saved_eflags = kcb->prev_kprobe.saved_eflags;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_eflags = kcb->kprobe_old_eflags
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (TF_MASK | IF_MASK));
 	if (is_IF_modifier(p->opcode))
-		kcb->kprobe_saved_eflags &= ~IF_MASK;
+		kcb->kprobe_saved_flags &= ~IF_MASK;
 }
 
 static __always_inline void clear_btf(void)
@@ -280,7 +280,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
 				regs->flags &= ~TF_MASK;
-				regs->flags |= kcb->kprobe_saved_eflags;
+				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 			}
 			/* We have reentered the kprobe_handler(), since
@@ -501,7 +501,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 	switch (p->ainsn.insn[0]) {
 	case 0x9c:		/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_eflags;
+		*tos |= kcb->kprobe_old_flags;
 		break;
 	case 0xc2:		/* iret/ret/lret */
 	case 0xc3:
@@ -578,7 +578,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	}
 
 	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_eflags;
+	regs->flags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->flags);
 
 	/*Restore back the original saved kprobes variables and continue. */
@@ -617,7 +617,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * normal page fault.
 		 */
 		regs->ip = (unsigned long)cur->addr;
-		regs->flags |= kcb->kprobe_old_eflags;
+		regs->flags |= kcb->kprobe_old_flags;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
 		else
@@ -703,8 +703,8 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_esp = &regs->sp;
-	addr = (unsigned long)(kcb->jprobe_saved_esp);
+	kcb->jprobe_saved_sp = &regs->sp;
+	addr = (unsigned long)(kcb->jprobe_saved_sp);
 
 	/*
 	 * TBD: As Linus pointed out, gcc assumes that the callee
@@ -730,23 +730,23 @@ void __kprobes jprobe_return(void)
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_esp):"memory");
+		      (kcb->jprobe_saved_sp):"memory");
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_esp);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->sp != kcb->jprobe_saved_esp) {
+		if (&regs->sp != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_esp,
+			    container_of(kcb->jprobe_saved_sp,
 					    struct pt_regs, sp);
 			printk("current sp %p does not match saved sp %p\n",
-			       &regs->sp, kcb->jprobe_saved_esp);
+			       &regs->sp, kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index a0ec7c2..3d1f1fa 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -234,26 +234,26 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_eflags = kcb->kprobe_old_eflags;
-	kcb->prev_kprobe.saved_eflags = kcb->kprobe_saved_eflags;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
 	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_eflags = kcb->prev_kprobe.old_eflags;
-	kcb->kprobe_saved_eflags = kcb->prev_kprobe.saved_eflags;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_eflags = kcb->kprobe_old_eflags
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (TF_MASK | IF_MASK));
 	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_eflags &= ~IF_MASK;
+		kcb->kprobe_saved_flags &= ~IF_MASK;
 }
 
 static __always_inline void clear_btf(void)
@@ -312,7 +312,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
 				regs->flags &= ~TF_MASK;
-				regs->flags |= kcb->kprobe_saved_eflags;
+				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 				/* TODO: Provide re-entrancy from
@@ -510,7 +510,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 	switch (*insn) {
 	case 0x9c:		/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_eflags;
+		*tos |= kcb->kprobe_old_flags;
 		break;
 	case 0xc3:		/* ret/lret */
 	case 0xcb:
@@ -565,7 +565,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	}
 
 	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_eflags;
+	regs->flags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->flags);
 
 	/* Restore the original saved kprobes variables and continue. */
@@ -605,7 +605,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * normal page fault.
 		 */
 		regs->ip = (unsigned long)cur->addr;
-		regs->flags |= kcb->kprobe_old_eflags;
+		regs->flags |= kcb->kprobe_old_flags;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
 		else
@@ -694,8 +694,8 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_esp = (long *) regs->sp;
-	addr = (unsigned long)(kcb->jprobe_saved_esp);
+	kcb->jprobe_saved_sp = (long *) regs->sp;
+	addr = (unsigned long)(kcb->jprobe_saved_sp);
 	/*
 	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
@@ -720,23 +720,23 @@ void __kprobes jprobe_return(void)
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_esp):"memory");
+		      (kcb->jprobe_saved_sp):"memory");
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_esp);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if ((long *)regs->sp != kcb->jprobe_saved_esp) {
+		if ((long *)regs->sp != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_esp,
+			    container_of(kcb->jprobe_saved_sp,
 					    struct pt_regs, sp);
 			printk("current sp %p does not match saved sp %p\n",
-			       (long *)regs->sp, kcb->jprobe_saved_esp);
+			       (long *)regs->sp, kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index 074ac7d..87b9d1b 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -73,16 +73,16 @@ struct arch_specific_insn {
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
-	unsigned long old_eflags;
-	unsigned long saved_eflags;
+	unsigned long old_flags;
+	unsigned long saved_flags;
 };
 
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
-	unsigned long kprobe_old_eflags;
-	unsigned long kprobe_saved_eflags;
-	long *jprobe_saved_esp;
+	unsigned long kprobe_old_flags;
+	unsigned long kprobe_saved_flags;
+	long *jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
-- 
1.5.3.7.2212.gd092



