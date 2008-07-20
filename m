Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYGUAIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYGUAIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbYGUAEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:04:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:37662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbYGUAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:04:31 -0400
Subject: [PATCH 17/22] sh: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org
In-Reply-To: <1216597856.3679.139.camel@jaswinder.satnam>
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
	 <1216596932.3679.120.camel@jaswinder.satnam>
	 <1216597066.3679.123.camel@jaswinder.satnam>
	 <1216597151.3679.125.camel@jaswinder.satnam>
	 <1216597237.3679.128.camel@jaswinder.satnam>
	 <1216597352.3679.131.camel@jaswinder.satnam>
	 <1216597566.3679.135.camel@jaswinder.satnam>
	 <1216597856.3679.139.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:22:03 +0530
Message-Id: <1216597923.3679.141.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for sh architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/sh/kernel/process_32.c |    1 +
 arch/sh/kernel/process_64.c |    1 +
 arch/sh/kernel/signal_32.c  |    1 +
 arch/sh/kernel/signal_64.c  |    1 +
 include/asm-sh/syscalls.h   |   88 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index b98e37a..b6fb73e 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -20,6 +20,7 @@
 #include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/preempt.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index 0283d81..f0b249f 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/io.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index f311551..852c81b 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -24,6 +24,7 @@
 #include <linux/binfmts.h>
 #include <linux/freezer.h>
 #include <linux/io.h>
+#include <linux/syscalls.h>
 #include <asm/system.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 552eb81..b2be648 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/include/asm-sh/syscalls.h b/include/asm-sh/syscalls.h
index e69de29..8966e00 100644
--- a/include/asm-sh/syscalls.h
+++ b/include/asm-sh/syscalls.h
@@ -0,0 +1,88 @@
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
+#ifndef _ASM_SH_SYSCALLS_H
+#define _ASM_SH_SYSCALLS_H
+
+#ifdef CONFIG_SUPERH32
+/* kernel/process_32.c */
+asmlinkage int sys_fork(unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage int sys_sigaction(int,
+			     const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_clone(unsigned long, unsigned long, unsigned long,
+			 unsigned long, struct pt_regs);
+asmlinkage int sys_vfork(unsigned long, unsigned long, unsigned long,
+			 unsigned long, struct pt_regs);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *, unsigned long,
+			  struct pt_regs);
+
+/* kernel/signal_32.c */
+asmlinkage int sys_sigsuspend(old_sigset_t, unsigned long,
+			      unsigned long, unsigned long,
+			      struct pt_regs);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long,
+			       struct pt_regs);
+asmlinkage int sys_sigreturn(unsigned long, unsigned long, unsigned long,
+			     unsigned long, struct pt_regs);
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long,
+				unsigned long, unsigned long,
+				struct pt_regs);
+
+/* kernel/sys_sh32.c */
+asmlinkage int sys_pipe(unsigned long, unsigned long, unsigned long,
+			unsigned long, struct pt_regs);
+asmlinkage ssize_t sys_pread_wrapper(unsigned int, char *, size_t,
+				     long, loff_t);
+asmlinkage ssize_t sys_pwrite_wrapper(unsigned int, const char *,
+				      size_t, long, loff_t);
+asmlinkage int sys_fadvise64_64_wrapper(int, u32, u32, u32, u32, int);
+
+#else /* CONFIG_SUPERH32 */
+
+/* kernel/process_64.c */
+asmlinkage int sys_fork(unsigned long, unsigned long, unsigned long,
+			unsigned long, unsigned long, unsigned long,
+			struct pt_regs *);
+asmlinkage int sys_clone(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_vfork(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_execve(char *, char **, char **, unsigned long,
+			  unsigned long, unsigned long, struct pt_regs *);
+
+/* kernel/signal_64.c */
+asmlinkage int sys_sigsuspend(old_sigset_t, unsigned long, unsigned long,
+			      unsigned long, unsigned long, unsigned long,
+			      struct pt_regs *);
+asmlinkage int sys_rt_sigsuspend(sigset_t *, size_t, unsigned long,
+				 unsigned long, unsigned long, unsigned long,
+				 struct pt_regs *);
+asmlinkage int sys_sigaction(int,
+			     const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       unsigned long, unsigned long, unsigned long,
+			       unsigned long, struct pt_regs *);
+asmlinkage int sys_sigreturn(unsigned long, unsigned long, unsigned long,
+			     unsigned long, unsigned long, unsigned long,
+			     struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(unsigned long, unsigned long, unsigned long,
+				unsigned long, unsigned long, unsigned long,
+				struct pt_regs *);
+
+#endif /* CONFIG_SUPERH32 */
+#endif /* _ASM_SH_SYSCALLS_H */
-- 
1.5.5.1



