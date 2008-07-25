Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYGYIxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYGYIxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYGYIxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:53:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYGYIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:53:38 -0400
Subject: [PATCH] mips: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips <linux-mips@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 14:22:28 +0530
Message-Id: <1216975948.26114.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for mips architecture
This patch only depends on mips.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/mips/kernel/signal.c   |    2 +-
 arch/mips/kernel/syscall.c  |    2 +-
 include/asm-mips/syscalls.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)
 create mode 100644 include/asm-mips/syscalls.h

diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index a4e106c..98f9c20 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -26,7 +26,7 @@
 #include <linux/bitops.h>
 #include <asm/cacheflush.h>
 #include <asm/fpu.h>
-#include <asm/sim.h>
+#include <asm/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index 343015a..81c44a1 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -35,7 +35,7 @@
 #include <asm/cacheflush.h>
 #include <asm/asm-offsets.h>
 #include <asm/signal.h>
-#include <asm/sim.h>
+#include <asm/syscalls.h>
 #include <asm/shmparam.h>
 #include <asm/sysmips.h>
 #include <asm/uaccess.h>
diff --git a/include/asm-mips/syscalls.h b/include/asm-mips/syscalls.h
new file mode 100644
index 0000000..415a69b
--- /dev/null
+++ b/include/asm-mips/syscalls.h
@@ -0,0 +1,49 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef _ASM_MIPS_SYSCALLS_H
+#define _ASM_MIPS_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+#include <linux/ptrace.h>
+#include <asm/sim.h>
+
+/* kernel/signal.c */
+#ifdef CONFIG_TRAD_SIGNALS
+asmlinkage int sys_sigsuspend(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_sigaction(int, const struct sigaction __user *,
+			     struct sigaction __user *);
+asmlinkage void sys_sigreturn(nabi_no_regargs struct pt_regs);
+#endif
+
+asmlinkage int sys_rt_sigsuspend(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_sigaltstack(nabi_no_regargs struct pt_regs);
+asmlinkage void sys_rt_sigreturn(nabi_no_regargs struct pt_regs);
+
+/* kernel/syscalls.c */
+asmlinkage unsigned long old_mmap(unsigned long, unsigned long,
+				  int, int, int, off_t);
+
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   unsigned long, unsigned long,
+				   unsigned long, unsigned long);
+asmlinkage int sys_execve(nabi_no_regargs struct pt_regs);
+struct old_utsname;
+asmlinkage int sys_uname(struct old_utsname __user *);
+struct oldold_utsname;
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+asmlinkage int sys_set_thread_area(unsigned long);
+asmlinkage int sys_ipc(unsigned int, int, int,
+		       unsigned long, void __user *, long);
+asmlinkage int sys_cachectl(char *, int, int);
+
+#endif /* _ASM_MIPS_SYSCALLS_H */
-- 
1.5.5.1



