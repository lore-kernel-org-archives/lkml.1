Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYAZQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYAZQAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbYAZPzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:12 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583AbYAZPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:08 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 22/52] [microblaze] asm-offsets
Date: Thu, 24 Jan 2008 16:02:57 +0100
Message-Id: <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |  118 ++++++++++++++++++++++++++++++++++
 1 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/asm-offsets.c

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
new file mode 100644
index 0000000..f01aa3b
--- /dev/null
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -0,0 +1,118 @@
+/*
+ * arch/microblaze/kernel/asm-offset.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/stddef.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/ptrace.h>
+#include <linux/hardirq.h>
+#include <linux/thread_info.h>
+
+#define DEFINE(sym, val) asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+#define BLANK() asm volatile("\n->" : :)
+
+int main(int argc, char *argv[])
+{
+	/* struct pt_regs */
+	DEFINE(PT_SIZE, sizeof(struct pt_regs));
+	DEFINE(PT_MSR, offsetof(struct pt_regs, msr));
+	DEFINE(PT_EAR, offsetof(struct pt_regs, ear));
+	DEFINE(PT_ESR, offsetof(struct pt_regs, esr));
+	DEFINE(PT_FSR, offsetof(struct pt_regs, fsr));
+	DEFINE(PT_PC, offsetof(struct pt_regs, pc));
+	DEFINE(PT_R0, offsetof(struct pt_regs, r0));
+	DEFINE(PT_R1, offsetof(struct pt_regs, r1));
+	DEFINE(PT_R2, offsetof(struct pt_regs, r2));
+	DEFINE(PT_R3, offsetof(struct pt_regs, r3));
+	DEFINE(PT_R4, offsetof(struct pt_regs, r4));
+	DEFINE(PT_R5, offsetof(struct pt_regs, r5));
+	DEFINE(PT_R6, offsetof(struct pt_regs, r6));
+	DEFINE(PT_R7, offsetof(struct pt_regs, r7));
+	DEFINE(PT_R8, offsetof(struct pt_regs, r8));
+	DEFINE(PT_R9, offsetof(struct pt_regs, r9));
+	DEFINE(PT_R10, offsetof(struct pt_regs, r10));
+	DEFINE(PT_R11, offsetof(struct pt_regs, r11));
+	DEFINE(PT_R12, offsetof(struct pt_regs, r12));
+	DEFINE(PT_R13, offsetof(struct pt_regs, r13));
+	DEFINE(PT_R14, offsetof(struct pt_regs, r14));
+	DEFINE(PT_R15, offsetof(struct pt_regs, r15));
+	DEFINE(PT_R16, offsetof(struct pt_regs, r16));
+	DEFINE(PT_R17, offsetof(struct pt_regs, r17));
+	DEFINE(PT_R18, offsetof(struct pt_regs, r18));
+	DEFINE(PT_R19, offsetof(struct pt_regs, r19));
+	DEFINE(PT_R20, offsetof(struct pt_regs, r20));
+	DEFINE(PT_R21, offsetof(struct pt_regs, r21));
+	DEFINE(PT_R22, offsetof(struct pt_regs, r22));
+	DEFINE(PT_R23, offsetof(struct pt_regs, r23));
+	DEFINE(PT_R24, offsetof(struct pt_regs, r24));
+	DEFINE(PT_R25, offsetof(struct pt_regs, r25));
+	DEFINE(PT_R26, offsetof(struct pt_regs, r26));
+	DEFINE(PT_R27, offsetof(struct pt_regs, r27));
+	DEFINE(PT_R28, offsetof(struct pt_regs, r28));
+	DEFINE(PT_R29, offsetof(struct pt_regs, r29));
+	DEFINE(PT_R30, offsetof(struct pt_regs, r30));
+	DEFINE(PT_R31, offsetof(struct pt_regs, r31));
+	DEFINE(PT_MODE, offsetof(struct pt_regs, kernel_mode));
+	BLANK();
+
+	/* Magic offsets for PTRACE PEEK/POKE etc */
+	DEFINE(PT_TEXT_ADDR, sizeof(struct pt_regs) + 1);
+	DEFINE(PT_TEXT_LEN, sizeof(struct pt_regs) + 2);
+	DEFINE(PT_DATA_ADDR, sizeof(struct pt_regs) + 3);
+	BLANK();
+
+	/* struct task_struct */
+	DEFINE(TS_THREAD_INFO, offsetof(struct task_struct, stack));
+
+	/* struct thread_info */
+	DEFINE(TI_TASK, offsetof(struct thread_info, task));
+	DEFINE(TI_EXEC_DOMAIN, offsetof(struct thread_info, exec_domain));
+	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
+	DEFINE(TI_STATUS, offsetof(struct thread_info, status));
+	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
+	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
+	DEFINE(TI_ADDR_LIMIT, offsetof(struct thread_info, addr_limit));
+	DEFINE(TI_RESTART_BLOCK, offsetof(struct thread_info, restart_block));
+	DEFINE(TI_CPU_CONTEXT, offsetof(struct thread_info, cpu_context));
+	BLANK();
+
+	/* struct cpu_context */
+	DEFINE(CC_SP, offsetof(struct cpu_context, sp)); /* r1 */
+	DEFINE(CC_R2, offsetof(struct cpu_context, r2));
+	/* dedicated registers */
+	DEFINE(CC_R13, offsetof(struct cpu_context, r13));
+	DEFINE(CC_R14, offsetof(struct cpu_context, r14));
+	DEFINE(CC_R15, offsetof(struct cpu_context, r15));
+	DEFINE(CC_R16, offsetof(struct cpu_context, r16));
+	DEFINE(CC_R17, offsetof(struct cpu_context, r17));
+	DEFINE(CC_R18, offsetof(struct cpu_context, r18));
+	/* non-volatile registers */
+	DEFINE(CC_R19, offsetof(struct cpu_context, r19));
+	DEFINE(CC_R20, offsetof(struct cpu_context, r20));
+	DEFINE(CC_R21, offsetof(struct cpu_context, r21));
+	DEFINE(CC_R22, offsetof(struct cpu_context, r22));
+	DEFINE(CC_R23, offsetof(struct cpu_context, r23));
+	DEFINE(CC_R24, offsetof(struct cpu_context, r24));
+	DEFINE(CC_R25, offsetof(struct cpu_context, r25));
+	DEFINE(CC_R26, offsetof(struct cpu_context, r26));
+	DEFINE(CC_R27, offsetof(struct cpu_context, r27));
+	DEFINE(CC_R28, offsetof(struct cpu_context, r28));
+	DEFINE(CC_R29, offsetof(struct cpu_context, r29));
+	DEFINE(CC_R30, offsetof(struct cpu_context, r30));
+	/* special purpose registers */
+	DEFINE(CC_MSR, offsetof(struct cpu_context, msr));
+	DEFINE(CC_EAR, offsetof(struct cpu_context, ear));
+	DEFINE(CC_ESR, offsetof(struct cpu_context, esr));
+	DEFINE(CC_FSR, offsetof(struct cpu_context, fsr));
+	BLANK();
+
+	return 0;
+}
-- 
1.5.4.rc4.14.g6fc74

