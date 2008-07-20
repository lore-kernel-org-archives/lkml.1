Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYGUAJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYGUAJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbYGUAE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:04:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:37674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbYGUAE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:04:57 -0400
Subject: [PATCH 21/22] x86: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, hpa@zytor.com
In-Reply-To: <1216598151.3679.148.camel@jaswinder.satnam>
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
	 <1216597923.3679.141.camel@jaswinder.satnam>
	 <1216597993.3679.144.camel@jaswinder.satnam>
	 <1216598067.3679.146.camel@jaswinder.satnam>
	 <1216598151.3679.148.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:28:37 +0530
Message-Id: <1216598318.3679.151.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for x86 architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/ldt.c        |    1 +
 arch/x86/kernel/process_32.c |    1 +
 arch/x86/kernel/process_64.c |    1 +
 arch/x86/kernel/signal_32.c  |    1 +
 arch/x86/kernel/signal_64.c  |    1 +
 arch/x86/kernel/tls.c        |    1 +
 arch/x86/kernel/vm86_32.c    |    1 +
 include/asm-x86/syscalls.h   |   83 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index a844957..047a021 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0c3927a..8e46d82 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index a8e5362..f99381b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/kdebug.h>
 #include <linux/tick.h>
 #include <linux/prctl.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..954a3b8 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -20,6 +20,7 @@
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/syscalls.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index e53b267..12c0ab5 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <linux/syscalls.h>
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index ab6bf37..90bc24c 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -3,6 +3,7 @@
 #include <linux/sched.h>
 #include <linux/user.h>
 #include <linux/regset.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 38f566f..d77e312 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/audit.h>
 #include <linux/stddef.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff --git a/include/asm-x86/syscalls.h b/include/asm-x86/syscalls.h
index e69de29..a93e6db 100644
--- a/include/asm-x86/syscalls.h
+++ b/include/asm-x86/syscalls.h
@@ -0,0 +1,83 @@
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
+#ifndef _ASM_X86_SYSCALLS_H
+#define _ASM_X86_SYSCALLS_H
+
+/* Common in X86_32 and X86_64 */
+/* kernel/ioport.c */
+asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+
+/* X86_32 only */
+#ifdef CONFIG_X86_32
+/* kernel/process_32.c */
+asmlinkage int sys_fork(struct pt_regs);
+asmlinkage int sys_clone(struct pt_regs);
+asmlinkage int sys_vfork(struct pt_regs);
+asmlinkage int sys_execve(struct pt_regs);
+
+/* kernel/signal_32.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(unsigned long);
+asmlinkage unsigned long sys_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(unsigned long);
+
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned long);
+
+/* kernel/ldt.c */
+asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
+
+/* kernel/sys_i386_32.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage int sys_uname(struct old_utsname __user *);
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+
+/* kernel/tls.c */
+asmlinkage int sys_set_thread_area(struct user_desc __user *);
+asmlinkage int sys_get_thread_area(struct user_desc __user *);
+
+#else /* CONFIG_X86_32 */
+
+/* X86_64 only */
+/* kernel/process_64.c */
+asmlinkage long sys_fork(struct pt_regs *);
+asmlinkage long sys_clone(unsigned long, unsigned long,
+			  void __user *, void __user *,
+			  struct pt_regs *);
+asmlinkage long sys_vfork(struct pt_regs *);
+asmlinkage long sys_execve(char __user *, char __user * __user *,
+			   char __user * __user *,
+			   struct pt_regs *);
+
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
+/* kernel/signal_64.c */
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+				struct pt_regs *);
+asmlinkage long sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_x86_64.c */
+asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_uname(struct new_utsname __user *);
+
+#endif /* CONFIG_X86_32 */
+#endif /* _ASM_X86_SYSCALLS_H */
-- 
1.5.5.1



