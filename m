Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbZCRVzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbZCRVzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZCRVoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:44:03 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758550AbZCRVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:44:00 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 26/57] microblaze_v7: ptrace support
Date: Wed, 18 Mar 2009 21:30:53 +0100
Message-Id: <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/ptrace.h |   68 +++++++++
 arch/microblaze/kernel/ptrace.c      |  252 ++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/ptrace.h
 create mode 100644 arch/microblaze/kernel/ptrace.c

diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/include/asm/ptrace.h
new file mode 100644
index 0000000..f1f0348
--- /dev/null
+++ b/arch/microblaze/include/asm/ptrace.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PTRACE_H
+#define _ASM_MICROBLAZE_PTRACE_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
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
+void show_regs(struct pt_regs *);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_MICROBLAZE_PTRACE_H */
diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
new file mode 100644
index 0000000..b046309
--- /dev/null
+++ b/arch/microblaze/kernel/ptrace.c
@@ -0,0 +1,252 @@
+/*
+ * `ptrace' system call
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
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <asm/processor.h>
+#include <linux/uaccess.h>
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
+#if 0
+static inline microblaze_reg_t getreg(struct task_struct *child, unsigned reg_off)
+{
+	microblaze_reg_t *reg_addr = reg_save_addr(reg_off, child);
+	return *reg_addr;
+}
+
+static inline void putreg(struct task_struct *child, unsigned reg_off, microblaze_reg_t reg_val)
+{
+	microblaze_reg_t *reg_addr = reg_save_addr(reg_off, child);
+	*reg_addr = reg_val;
+}
+#endif
+
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+{
+	int rval;
+	unsigned long val = 0;
+	unsigned long copied;
+
+	switch (request) {
+	case PTRACE_PEEKTEXT: /* read word at location addr. */
+	case PTRACE_PEEKDATA:
+		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
+		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
+		rval = -EIO;
+		if (copied != sizeof(val))
+			break;
+		rval = put_user(val, (unsigned long *)data);
+		break;
+
+	case PTRACE_POKETEXT: /* write the word at location addr. */
+	case PTRACE_POKEDATA:
+		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
+		rval = 0;
+		if (access_process_vm(child, addr, &data, sizeof(data), 1)
+		    == sizeof(data))
+			break;
+		rval = -EIO;
+		break;
+
+	/* Read/write the word at location ADDR in the registers. */
+	case PTRACE_PEEKUSR:
+	case PTRACE_POKEUSR:
+		pr_debug("PEEKUSR/POKEUSR : 0x%08lx\n", addr);
+		rval = 0;
+		if (addr >= PT_SIZE && request == PTRACE_PEEKUSR) {
+			/*
+			 * Special requests that don't actually correspond
+			 * to offsets in struct pt_regs.
+			 */
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
+		break;
+	/* Continue and stop at next (return from) syscall */
+	case PTRACE_SYSCALL:
+		pr_debug("PTRACE_SYSCALL\n");
+	case PTRACE_SINGLESTEP:
+		pr_debug("PTRACE_SINGLESTEP\n");
+	/* Restart after a signal.  */
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
+	 * make the child exit.  Best I can do is send it a sigkill.
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
+#if 0
+/*	#define PTRACE_GETREGS            12*/
+	case PTRACE_GETREGS: /* get gp regs from the tracee */
+		if (!access_ok(VERIFY_WRITE, datap, PT_SIZE)) {
+			rval = -EIO;
+			break;
+		}
+		for (i = 0; i < PT_SIZE; i += sizeof(long)) {
+			__put_user(getreg(child, i), datap++);
+		}
+		rval = 0;
+		break;
+#endif
+
+#if 0
+/*	#define PTRACE_SETREGS            13*/
+	case PTRACE_SETREGS: /* Set gp regs for the tracee */
+		if (!access_ok(VERIFY_READ, datap, PT_SIZE)) {
+			rval = -EIO;
+			break;
+		}
+		for (i = 0; i < PT_SIZE; i += sizeof(long)) {
+			__get_user(val, datap++);
+			if (i == PT_MSR) { /* may only change C and CC bits in MSR */
+				val = (val & 0x80000004) | (getreg(child,i) & ~0x80000004);
+			}
+			putreg(child, i, val);
+		}
+		rval = 0;
+		break;
+#endif
+
+	default:
+		/* rval = ptrace_request(child, request, addr, data); noMMU */
+		rval = -EIO;
+	}
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
-- 
1.5.5.1

