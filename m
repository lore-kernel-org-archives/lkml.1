Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYGUAFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYGUAFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbYGUADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbYGUADg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:36 -0400
Subject: [PATCH 9/22] ia64: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
In-Reply-To: <1216596749.3679.115.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
	 <1216596325.3679.104.camel@jaswinder.satnam>
	 <1216596669.3679.112.camel@jaswinder.satnam>
	 <1216596749.3679.115.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:03:55 +0530
Message-Id: <1216596835.3679.117.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for ia64 architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/ia64/kernel/process.c  |    1 +
 arch/ia64/kernel/signal.c   |    1 +
 include/asm-ia64/syscalls.h |   38 ++++++++++++++++++++++++++++++++++++++
 include/asm-ia64/unistd.h   |   14 +-------------
 4 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 3ab8373..3b668a9 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/kdebug.h>
 #include <linux/utsname.h>
+#include <linux/syscalls.h>
 
 #include <asm/cpu.h>
 #include <asm/delay.h>
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 19c5a78..7b249da 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/binfmts.h>
 #include <linux/unistd.h>
 #include <linux/wait.h>
+#include <linux/syscalls.h>
 
 #include <asm/ia32.h>
 #include <asm/intrinsics.h>
diff --git a/include/asm-ia64/syscalls.h b/include/asm-ia64/syscalls.h
index e69de29..71af530 100644
--- a/include/asm-ia64/syscalls.h
+++ b/include/asm-ia64/syscalls.h
@@ -0,0 +1,38 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_IA64_SYSCALLS_H
+#define _ASM_IA64_SYSCALLS_H
+
+/* kernel/process.c */
+long sys_execve(char __user *, char __user * __user *,
+		 char __user * __user *, struct pt_regs *);
+
+/* kernel/signal.c */
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+				long, long, long, long, long, long,
+				struct pt_regs);
+
+/* kernel/sys_ia64.c */
+asmlinkage unsigned long sys_getpagesize(void);
+asmlinkage long sys_pipe(void);
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   int, int, int, long);
+asmlinkage unsigned long sys_mmap(unsigned long, unsigned long,
+				  int, int, int, long);
+#ifndef CONFIG_PCI
+asmlinkage long sys_pciconfig_read(unsigned long, unsigned long,
+				   unsigned long, unsigned long, void *);
+asmlinkage long sys_pciconfig_write(unsigned long, unsigned long,
+				    unsigned long, unsigned long, void *);
+#endif /* CONFIG_PCI */
+
+#endif /* _ASM_IA64_SYSCALLS_H */
diff --git a/include/asm-ia64/unistd.h b/include/asm-ia64/unistd.h
index e603147..6b0e8c6 100644
--- a/include/asm-ia64/unistd.h
+++ b/include/asm-ia64/unistd.h
@@ -342,22 +342,10 @@
 #include <linux/types.h>
 #include <linux/linkage.h>
 #include <linux/compiler.h>
+#include <linux/syscalls.h>
 
 extern long __ia64_syscall (long a0, long a1, long a2, long a3, long a4, long nr);
 
-asmlinkage unsigned long sys_mmap(
-				unsigned long addr, unsigned long len,
-				int prot, int flags,
-				int fd, long off);
-asmlinkage unsigned long sys_mmap2(
-				unsigned long addr, unsigned long len,
-				int prot, int flags,
-				int fd, long pgoff);
-struct pt_regs;
-struct sigaction;
-long sys_execve(char __user *filename, char __user * __user *argv,
-			   char __user * __user *envp, struct pt_regs *regs);
-asmlinkage long sys_pipe(void);
 asmlinkage long sys_rt_sigaction(int sig,
 				 const struct sigaction __user *act,
 				 struct sigaction __user *oact,
-- 
1.5.5.1



