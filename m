Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYGHMNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYGHMNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbYGHMKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:10:40 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:26447 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758374AbYGHMKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:10:37 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 27/58] microblaze_v5: ptrace support
Date: Tue,  8 Jul 2008 13:59:27 +0200
Message-Id: <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ptrace.c |  142 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/ptrace.h |   68 +++++++++++++++++++
 2 files changed, 210 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/ptrace.c
 create mode 100644 include/asm-microblaze/ptrace.h

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
new file mode 100644
index 0000000..4e8823d
--- /dev/null
+++ b/arch/microblaze/kernel/ptrace.c
@@ -0,0 +1,142 @@
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
+	int ret;
+	unsigned long val = 0;
+
+	switch (request) {
+	/* Read/write the word at location ADDR in the registers. */
+	case PTRACE_PEEKUSR:
+	case PTRACE_POKEUSR:
+		pr_debug("PEEKUSR/POKEUSR : 0x%08lx\n", addr);
+		ret = 0;
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
+				ret = -EIO;
+			}
+		} else if (addr >= 0 && addr < PT_SIZE && (addr & 0x3) == 0) {
+			microblaze_reg_t *reg_addr = reg_save_addr(addr, child);
+			if (request == PTRACE_PEEKUSR)
+				val = *reg_addr;
+			else
+				*reg_addr = data;
+		} else
+			ret = -EIO;
+
+		if (ret == 0 && request == PTRACE_PEEKUSR)
+			ret = put_user(val, (unsigned long *)data);
+		goto out;
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+ out:
+	return ret;
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
index 0000000..122f4af
--- /dev/null
+++ b/include/asm-microblaze/ptrace.h
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

