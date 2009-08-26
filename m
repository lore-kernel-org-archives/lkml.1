Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZHZGgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZHZGgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZHZGgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:36:22 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43187
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbZHZGgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:36:21 -0400
Subject: Subject: [PATCH 18/33] score: create head files futex.h ftrace.h
	mutex.h ptarce.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:25:05 +0800
Message-Id: <1251267905.3153.3.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 17cd7f3cb8e56b2343df326897a7a9c70c5dd1a8 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:05 +0800
Subject: [PATCH 18/33] score: create head files futex.h ftrace.h mutex.h ptarce.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/ftrace.h |    4 ++
 arch/score/include/asm/futex.h  |    6 ++
 arch/score/include/asm/mutex.h  |    6 ++
 arch/score/include/asm/ptrace.h |   97 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/ftrace.h
 create mode 100644 arch/score/include/asm/futex.h
 create mode 100644 arch/score/include/asm/mutex.h
 create mode 100644 arch/score/include/asm/ptrace.h

diff --git a/arch/score/include/asm/ftrace.h b/arch/score/include/asm/ftrace.h
new file mode 100644
index 0000000..79d6f10
--- /dev/null
+++ b/arch/score/include/asm/ftrace.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_FTRACE_H
+#define _ASM_SCORE_FTRACE_H
+
+#endif /* _ASM_SCORE_FTRACE_H */
diff --git a/arch/score/include/asm/futex.h b/arch/score/include/asm/futex.h
new file mode 100644
index 0000000..1dca242
--- /dev/null
+++ b/arch/score/include/asm/futex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_FUTEX_H
+#define _ASM_SCORE_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* _ASM_SCORE_FUTEX_H */
diff --git a/arch/score/include/asm/mutex.h b/arch/score/include/asm/mutex.h
new file mode 100644
index 0000000..10d48fe
--- /dev/null
+++ b/arch/score/include/asm/mutex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_MUTEX_H
+#define _ASM_SCORE_MUTEX_H
+
+#include <asm-generic/mutex-dec.h>
+
+#endif /* _ASM_SCORE_MUTEX_H */
diff --git a/arch/score/include/asm/ptrace.h b/arch/score/include/asm/ptrace.h
new file mode 100644
index 0000000..d40e691
--- /dev/null
+++ b/arch/score/include/asm/ptrace.h
@@ -0,0 +1,97 @@
+#ifndef _ASM_SCORE_PTRACE_H
+#define _ASM_SCORE_PTRACE_H
+
+#define PTRACE_GETREGS		12
+#define PTRACE_SETREGS		13
+
+#define PC		32
+#define CONDITION	33
+#define ECR		34
+#define EMA		35
+#define CEH		36
+#define CEL		37
+#define COUNTER		38
+#define LDCR		39
+#define STCR		40
+#define PSR		41
+
+#define SINGLESTEP16_INSN	0x7006
+#define SINGLESTEP32_INSN	0x840C8000
+#define BREAKPOINT16_INSN	0x7002		/* work on SPG300 */
+#define BREAKPOINT32_INSN	0x84048000	/* work on SPG300 */
+
+/* Define instruction mask */
+#define INSN32_MASK	0x80008000
+
+#define J32	0x88008000	/* 1_00010_0000000000_1_000000000000000 */
+#define J32M	0xFC008000	/* 1_11111_0000000000_1_000000000000000 */
+
+#define B32	0x90008000	/* 1_00100_0000000000_1_000000000000000 */
+#define B32M	0xFC008000
+#define BL32	0x90008001	/* 1_00100_0000000000_1_000000000000001 */
+#define BL32M	B32
+#define BR32	0x80008008	/* 1_00000_0000000000_1_00000000_000100_0 */
+#define BR32M	0xFFE0807E
+#define BRL32	0x80008009	/* 1_00000_0000000000_1_00000000_000100_1 */
+#define BRL32M	BR32M
+
+#define B32_SET	(J32 | B32 | BL32 | BR32 | BRL32)
+
+#define J16	0x3000		/* 0_011_....... */
+#define J16M	0xF000
+#define B16	0x4000		/* 0_100_....... */
+#define B16M	0xF000
+#define BR16	0x0004		/* 0_000.......0100 */
+#define BR16M	0xF00F
+#define B16_SET (J16 | B16 | BR16)
+
+
+/*
+ * This struct defines the way the registers are stored on the stack during a
+ * system call/exception. As usual the registers k0/k1 aren't being saved.
+ */
+struct pt_regs {
+	unsigned long pad0[6];	/* stack arguments */
+	unsigned long orig_r4;
+	unsigned long orig_r7;
+	long is_syscall;
+
+	unsigned long regs[32];
+
+	unsigned long cel;
+	unsigned long ceh;
+
+	unsigned long sr0;	/* cnt */
+	unsigned long sr1;	/* lcr */
+	unsigned long sr2;	/* scr */
+
+	unsigned long cp0_epc;
+	unsigned long cp0_ema;
+	unsigned long cp0_psr;
+	unsigned long cp0_ecr;
+	unsigned long cp0_condition;
+};
+
+#ifdef __KERNEL__
+
+struct task_struct;
+
+/*
+ * Does the process account for user or for system time?
+ */
+#define user_mode(regs) 	((regs->cp0_psr & 8) == 8)
+
+#define instruction_pointer(regs)	((unsigned long)(regs)->cp0_epc)
+#define profile_pc(regs)		instruction_pointer(regs)
+
+extern void do_syscall_trace(struct pt_regs *regs, int entryexit);
+extern int read_tsk_long(struct task_struct *, unsigned long, unsigned long *);
+extern int read_tsk_short(struct task_struct *, unsigned long,
+			 unsigned short *);
+
+#define arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SCORE_PTRACE_H */
-- 
1.6.2



