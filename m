Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYEDQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYEDQoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYEDQo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:44:29 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60010 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753845AbYEDQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:44:27 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 25/56] microblaze_v2: ptrace support
Date: Sun,  4 May 2008 13:41:14 +0200
Message-Id: <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ptrace.c |  206 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/ptrace.h |   70 +++++++++++++
 2 files changed, 276 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/ptrace.c
 create mode 100644 include/asm-microblaze/ptrace.h

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
new file mode 100644
index 0000000..958f076
--- /dev/null
+++ b/arch/microblaze/kernel/ptrace.c
@@ -0,0 +1,206 @@
+/*
+ * arch/microblaze/kernel/ptrace.c -- `ptrace' system call
+ *
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2004-07 John Williams <john.williams@petalogix.com>
+ *
+ * derived from arch/v850/kernel/ptrace.c
+ *
+ * Copyright (C) 2002,03 NEC Electronics Corporation
+ * Copyright (C) 2002,03 Miles Bader <miles@gnu.org>
+ *
+ * Derived from arch/mips/kernel/ptrace.c:
+ *
+ * Copyright (C) 1992 Ross Biro
+ * Copyright (C) Linus Torvalds
+ * Copyright (C) 1994, 95, 96, 97, 98, 2000 Ralf Baechle
+ * Copyright (C) 1996 David S. Miller
+ * Kevin D. Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
+ * Copyright (C) 1999 MIPS Technologies, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/smp_lock.h>
+#include <linux/ptrace.h>
+#include <linux/signal.h>
+
+#include <asm/errno.h>
+#include <asm/ptrace.h>
+#include <asm/processor.h>
+#include <asm/uaccess.h>
+#include <asm/asm-offsets.h>
+
+/* Returns the address where the register at REG_OFFS in P is stashed away. */
+static microblaze_reg_t *reg_save_addr(unsigned reg_offs,
+					struct task_struct *t)
+{
+	struct pt_regs *regs;
+
+	/*
+	 * Three basic cases:
+	 *
+	 * (1)	A register normally saved before calling the scheduler, is
+	 *	available in the kernel entry pt_regs structure at the top
+	 *	of the kernel stack. The kernel trap/irq exit path takes
+	 *	care to save/restore almost all registers for ptrace'd
+	 *	processes.
+	 *
+	 * (2)	A call-clobbered register, where the process P entered the
+	 *	kernel via [syscall] trap, is not stored anywhere; that's
+	 *	OK, because such registers are not expected to be preserved
+	 *	when the trap returns anyway (so we don't actually bother to
+	 *	test for this case).
+	 *
+	 * (3)	A few registers not used at all by the kernel, and so
+	 *	normally never saved except by context-switches, are in the
+	 *	context switch state.
+	 */
+
+	/* Register saved during kernel entry (or not available). */
+	regs = task_pt_regs(t);
+
+	return (microblaze_reg_t *)((char *)regs + reg_offs);
+}
+
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+{
+	int rval;
+
+	switch (request) {
+		unsigned long val, copied;
+
+	case PTRACE_PEEKTEXT: /* read word at location addr. */
+	case PTRACE_PEEKDATA:
+		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
+		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
+		rval = -EIO;
+		if (copied != sizeof(val))
+			break;
+		rval = put_user(val, (unsigned long *)data);
+		goto out;
+
+	case PTRACE_POKETEXT: /* write the word at location addr. */
+	case PTRACE_POKEDATA:
+		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
+		rval = 0;
+		if (access_process_vm(child, addr, &data, sizeof(data), 1)
+			== sizeof(data))
+			break;
+		rval = -EIO;
+		goto out;
+
+	/* Read/write the word at location ADDR in the registers. */
+	case PTRACE_PEEKUSR:
+	case PTRACE_POKEUSR:
+		pr_debug("PEEKUSR/POKEUSR : 0x%08lx\n", addr);
+		rval = 0;
+		if (addr >= PT_SIZE && request == PTRACE_PEEKUSR) {
+			/* Special requests that don't actually correspond
+			 to offsets in struct pt_regs. */
+			if (addr == PT_TEXT_ADDR) {
+				val = child->mm->start_code;
+			} else if (addr == PT_DATA_ADDR) {
+				val = child->mm->start_data;
+			} else if (addr == PT_TEXT_LEN) {
+				val = child->mm->end_code
+					- child->mm->start_code;
+			} else {
+				rval = -EIO;
+			}
+		} else if (addr >= 0 && addr < PT_SIZE && (addr & 0x3) == 0) {
+			microblaze_reg_t *reg_addr = reg_save_addr(addr, child);
+			if (request == PTRACE_PEEKUSR)
+				val = *reg_addr;
+			else
+				*reg_addr = data;
+		} else
+			rval = -EIO;
+
+		if (rval == 0 && request == PTRACE_PEEKUSR)
+			rval = put_user(val, (unsigned long *)data);
+		goto out;
+
+	/* Continue and stop at next (return from) syscall */
+	case PTRACE_SYSCALL:
+		pr_debug("PTRACE_SYSCALL\n");
+	case PTRACE_SINGLESTEP:
+		pr_debug("PTRACE_SINGLESTEP\n");
+	/* Restart after a signal. */
+	case PTRACE_CONT:
+		pr_debug("PTRACE_CONT\n");
+		rval = -EIO;
+		if (!valid_signal(data))
+			break;
+
+		if (request == PTRACE_SYSCALL)
+			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+		else
+			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
+		child->exit_code = data;
+		pr_debug("wakeup_process\n");
+		wake_up_process(child);
+		rval = 0;
+		break;
+
+	/*
+	 * make the child exit. Best I can do is send it a sigkill.
+	 * perhaps it should be put in the status that it wants to
+	 * exit.
+	 */
+	case PTRACE_KILL:
+		pr_debug("PTRACE_KILL\n");
+		rval = 0;
+		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
+			break;
+		child->exit_code = SIGKILL;
+		wake_up_process(child);
+		break;
+
+	case PTRACE_DETACH: /* detach a process that was attached. */
+		pr_debug("PTRACE_DETACH\n");
+		rval = ptrace_detach(child, data);
+		break;
+
+	default:
+		rval = -EIO;
+		goto out;
+	}
+ out:
+	return rval;
+}
+
+#if 0
+static asmlinkage void syscall_trace(void)
+{
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return;
+	if (!(current->ptrace & PT_PTRACED))
+		return;
+	/* The 0x80 provides a way for the tracing parent to distinguish
+	 between a syscall stop and SIGTRAP delivery */
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
+				? 0x80 : 0));
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use. strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP. -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+#endif
+
+void ptrace_disable(struct task_struct *child)
+{
+	/* nothing to do */
+}
diff --git a/include/asm-microblaze/ptrace.h b/include/asm-microblaze/ptrace.h
new file mode 100644
index 0000000..f7ba49c
--- /dev/null
+++ b/include/asm-microblaze/ptrace.h
@@ -0,0 +1,70 @@
+/*
+ * include/asm-microblaze/ptrace.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_PTRACE_H
+#define _ASM_MICROBLAZE_PTRACE_H
+
+#ifndef __ASSEMBLY__
+#include <asm/types.h>
+
+typedef unsigned long microblaze_reg_t;
+
+struct pt_regs {
+	microblaze_reg_t r0;
+	microblaze_reg_t r1;
+	microblaze_reg_t r2;
+	microblaze_reg_t r3;
+	microblaze_reg_t r4;
+	microblaze_reg_t r5;
+	microblaze_reg_t r6;
+	microblaze_reg_t r7;
+	microblaze_reg_t r8;
+	microblaze_reg_t r9;
+	microblaze_reg_t r10;
+	microblaze_reg_t r11;
+	microblaze_reg_t r12;
+	microblaze_reg_t r13;
+	microblaze_reg_t r14;
+	microblaze_reg_t r15;
+	microblaze_reg_t r16;
+	microblaze_reg_t r17;
+	microblaze_reg_t r18;
+	microblaze_reg_t r19;
+	microblaze_reg_t r20;
+	microblaze_reg_t r21;
+	microblaze_reg_t r22;
+	microblaze_reg_t r23;
+	microblaze_reg_t r24;
+	microblaze_reg_t r25;
+	microblaze_reg_t r26;
+	microblaze_reg_t r27;
+	microblaze_reg_t r28;
+	microblaze_reg_t r29;
+	microblaze_reg_t r30;
+	microblaze_reg_t r31;
+	microblaze_reg_t pc;
+	microblaze_reg_t msr;
+	microblaze_reg_t ear;
+	microblaze_reg_t esr;
+	microblaze_reg_t fsr;
+	int kernel_mode;
+};
+
+#define kernel_mode(regs)		((regs)->kernel_mode)
+#define user_mode(regs)			(!kernel_mode(regs))
+
+#define instruction_pointer(regs)	((regs)->pc)
+#define profile_pc(regs)		instruction_pointer(regs)
+
+extern void show_regs(struct pt_regs *);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_MICROBLAZE_PTRACE_H */
-- 
1.5.4.GIT

