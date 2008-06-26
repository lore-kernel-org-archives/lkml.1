Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbYFZNaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbYFZNaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYFZN37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:29:59 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24137 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbYFZN36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:29:58 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 24/60] microblaze_v4: asm-offsets
Date: Thu, 26 Jun 2008 14:29:53 +0200
Message-Id: <1214483429-32360-25-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-24-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |  116 ++++++++++++++++++++++++++++++++++
 1 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/asm-offsets.c

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
new file mode 100644
index 0000000..522f8ff
--- /dev/null
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -0,0 +1,116 @@
+/*
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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
+	DEFINE(CC_SP, offsetof(struct cpu_context, r1)); /* r1 */
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
1.5.4.GIT

