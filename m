Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZHZGbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZHZGbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZHZGbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:31:04 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:52829
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbZHZGbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:31:03 -0400
Subject: Subject: [PATCH 14/33] score: create head files syscalls.h
	uaccess.h ucontext.h unistd.h user.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:20:40 +0800
Message-Id: <1251267640.3073.20.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From da0c2143d701caf1baf23c8619c78a51ee901b13 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:03 +0800
Subject: [PATCH 14/33] score: create head files syscalls.h uaccess.h ucontext.h unistd.h user.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/syscalls.h |   11 +++++++++++
 arch/score/include/asm/uaccess.h  |   27 +++++++++++++++++++++++++++
 arch/score/include/asm/ucontext.h |    1 +
 arch/score/include/asm/unistd.h   |    8 ++++++++
 arch/score/include/asm/user.h     |   21 +++++++++++++++++++++
 5 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/syscalls.h
 create mode 100644 arch/score/include/asm/uaccess.h
 create mode 100644 arch/score/include/asm/ucontext.h
 create mode 100644 arch/score/include/asm/unistd.h
 create mode 100644 arch/score/include/asm/user.h

diff --git a/arch/score/include/asm/syscalls.h b/arch/score/include/asm/syscalls.h
new file mode 100644
index 0000000..1dd5e0d
--- /dev/null
+++ b/arch/score/include/asm/syscalls.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_SCORE_SYSCALLS_H
+#define _ASM_SCORE_SYSCALLS_H
+
+asmlinkage long score_clone(struct pt_regs *regs);
+asmlinkage long score_execve(struct pt_regs *regs);
+asmlinkage long score_sigaltstack(struct pt_regs *regs);
+asmlinkage long score_rt_sigreturn(struct pt_regs *regs);
+
+#include <asm-generic/syscalls.h>
+
+#endif /* _ASM_SCORE_SYSCALLS_H */
diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
new file mode 100644
index 0000000..6f09e2b
--- /dev/null
+++ b/arch/score/include/asm/uaccess.h
@@ -0,0 +1,27 @@
+#ifndef _ASM_SCORE_UACCESS_H
+#define _ASM_SCORE_UACCESS_H
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+struct pt_regs;
+extern int fixup_exception(struct pt_regs *regs);
+
+#ifndef __ASSEMBLY__
+
+#define __range_ok(addr, size)					\
+	((((unsigned long __force)(addr) >= 0x80000000)			\
+	|| ((unsigned long)(size) > 0x80000000)			\
+	|| (((unsigned long __force)(addr) + (unsigned long)(size)) > 0x80000000)))
+
+#define __access_ok(addr, size) \
+	(__range_ok((addr), (size)) == 0)
+
+#include <asm-generic/uaccess.h>
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_SCORE_UACCESS_H */
diff --git a/arch/score/include/asm/ucontext.h b/arch/score/include/asm/ucontext.h
new file mode 100644
index 0000000..9bc07b9
--- /dev/null
+++ b/arch/score/include/asm/ucontext.h
@@ -0,0 +1 @@
+#include <asm-generic/ucontext.h>
diff --git a/arch/score/include/asm/unistd.h b/arch/score/include/asm/unistd.h
new file mode 100644
index 0000000..0d98b72
--- /dev/null
+++ b/arch/score/include/asm/unistd.h
@@ -0,0 +1,8 @@
+#if !defined(_ASM_SCORE_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_SCORE_UNISTD_H
+
+#define __ARCH_HAVE_MMU
+
+#include <asm-generic/unistd.h>
+
+#endif /* _ASM_SCORE_UNISTD_H */
diff --git a/arch/score/include/asm/user.h b/arch/score/include/asm/user.h
new file mode 100644
index 0000000..7bfb8e2
--- /dev/null
+++ b/arch/score/include/asm/user.h
@@ -0,0 +1,21 @@
+#ifndef _ASM_SCORE_USER_H
+#define _ASM_SCORE_USER_H
+
+struct user_regs_struct {
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
+#endif /* _ASM_SCORE_USER_H */
-- 
1.6.2



