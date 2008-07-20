Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYGUAGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYGUAGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYGUADo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:37638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbYGUADm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:42 -0400
Subject: [PATCH 10/22] m32r: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org
In-Reply-To: <1216596835.3679.117.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
	 <1216596325.3679.104.camel@jaswinder.satnam>
	 <1216596669.3679.112.camel@jaswinder.satnam>
	 <1216596749.3679.115.camel@jaswinder.satnam>
	 <1216596835.3679.117.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:05:32 +0530
Message-Id: <1216596932.3679.120.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for m32r architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/m32r/kernel/process.c  |    1 +
 arch/m32r/kernel/signal.c   |    1 +
 include/asm-m32r/syscalls.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index a689e29..9f5335c 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/hardirq.h>
+#include <linux/syscalls.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 1812454..4478893 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/include/asm-m32r/syscalls.h b/include/asm-m32r/syscalls.h
index e69de29..78ccedb 100644
--- a/include/asm-m32r/syscalls.h
+++ b/include/asm-m32r/syscalls.h
@@ -0,0 +1,49 @@
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
+#ifndef _ASM_M32R_SYSCALLS_H
+#define _ASM_M32R_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_fork(unsigned long, unsigned long, unsigned long,
+			unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage int sys_clone(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long,
+			 unsigned long, struct pt_regs);
+asmlinkage int sys_vfork(unsigned long, unsigned long, unsigned long,
+			unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *, unsigned long,
+			  unsigned long, unsigned long, unsigned long,
+			  struct pt_regs);
+
+/* kernel/signal.c */
+asmlinkage int sys_rt_sigsuspend(sigset_t __user *, size_t, unsigned long,
+				 unsigned long, unsigned long, unsigned long,
+				 unsigned long, struct pt_regs *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long, unsigned long,
+			       unsigned long, unsigned long, struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long, unsigned long,
+				unsigned long, unsigned long, unsigned long,
+				unsigned long, struct pt_regs *);
+
+/* kernel/sys_m32r.c */
+asmlinkage int sys_tas(int __user *);
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage int sys_uname(struct old_utsname __user *);
+asmlinkage int sys_cachectl(char *, int, int);
+
+#endif /* _ASM_M32R_SYSCALLS_H */
-- 
1.5.5.1



