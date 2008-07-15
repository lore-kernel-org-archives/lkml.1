Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYGOJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYGOJ2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 05:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYGOJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 05:28:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:53530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYGOJ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 05:28:41 -0400
Subject: [PATCH] x86: Introducing asm-x86/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:57:52 +0530
Message-Id: <1216114072.21749.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


declaring arch-dependent syscalls for x86 under one hood

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/ldt.c        |    1 +
 arch/x86/kernel/process_32.c |    1 +
 arch/x86/kernel/signal_32.c  |    1 +
 arch/x86/kernel/tls.c        |    1 +
 arch/x86/kernel/vm86_32.c    |    1 +
 include/asm-x86/syscalls.h   |   84 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h     |    4 ++
 7 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-x86/syscalls.h

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 21f2bae..a278afc 100644
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
new file mode 100644
index 0000000..0960d97
--- /dev/null
+++ b/include/asm-x86/syscalls.h
@@ -0,0 +1,84 @@
+#ifndef _ASM_X86_SYSCALLS_H
+#define _ASM_X86_SYSCALLS_H
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+#include <linux/utsname.h>
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
+/* kernel/vm86_32.c */
+asmlinkage int sys_vm86old(struct pt_regs);
+asmlinkage int sys_vm86(struct pt_regs);
+
+#else /* CONFIF_X86_32 */
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
+#endif /* CONFIF_X86_32 */
+#endif /* __KERNEL__ */
+#endif /* _ASM_X86_SYSCALLS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..dfd6744 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,10 @@ struct getcpu_cache;
 #include <linux/quota.h>
 #include <linux/key.h>
 
+#ifdef CONFIG_X86
+#include <asm/syscalls.h>
+#endif
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
-- 
1.5.5.1



