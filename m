Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbZCYSR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbZCYSR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZCYSRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:17:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:51500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbZCYSRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:17:08 -0400
Subject: [PATCH -tip] x86: syscalls.h cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 23:46:43 +0530
Message-Id: <1238005003.2500.55.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Wed, 25 Mar 2009 23:43:08 +0530
Subject: [PATCH] x86: syscalls.h cleanup

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/syscalls.h |   45 ++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 7043408..372b76e 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -1,7 +1,7 @@
 /*
  * syscalls.h - Linux syscall interfaces (arch-specific)
  *
- * Copyright (c) 2008 Jaswinder Singh
+ * Copyright (c) 2008 Jaswinder Singh Rajput
  *
  * This file is released under the GPLv2.
  * See the file COPYING for more details.
@@ -12,50 +12,55 @@
 
 #include <linux/compiler.h>
 #include <linux/linkage.h>
-#include <linux/types.h>
 #include <linux/signal.h>
+#include <linux/types.h>
 
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
 
+/* kernel/process.c */
+int sys_fork(struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
+/* kernel/signal.c */
+long sys_rt_sigreturn(struct pt_regs *);
+
 /* kernel/tls.c */
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
 asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
 /* X86_32 only */
 #ifdef CONFIG_X86_32
+/* kernel/ioport.c */
+long sys_iopl(struct pt_regs *);
+
 /* kernel/process_32.c */
-int sys_fork(struct pt_regs *);
 int sys_clone(struct pt_regs *);
-int sys_vfork(struct pt_regs *);
 int sys_execve(struct pt_regs *);
 
-/* kernel/signal_32.c */
+/* kernel/signal.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 int sys_sigaltstack(struct pt_regs *);
 unsigned long sys_sigreturn(struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
-
-/* kernel/ioport.c */
-long sys_iopl(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
+struct mmap_arg_struct;
+struct sel_arg_struct;
+struct oldold_utsname;
+struct old_utsname;
+
 asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
 			  unsigned long, unsigned long, unsigned long);
-struct mmap_arg_struct;
 asmlinkage int old_mmap(struct mmap_arg_struct __user *);
-struct sel_arg_struct;
 asmlinkage int old_select(struct sel_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
-struct old_utsname;
 asmlinkage int sys_uname(struct old_utsname __user *);
-struct oldold_utsname;
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
@@ -65,29 +70,27 @@ int sys_vm86(struct pt_regs *);
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
 /* kernel/process_64.c */
-asmlinkage long sys_fork(struct pt_regs *);
 asmlinkage long sys_clone(unsigned long, unsigned long,
 			  void __user *, void __user *,
 			  struct pt_regs *);
-asmlinkage long sys_vfork(struct pt_regs *);
 asmlinkage long sys_execve(char __user *, char __user * __user *,
 			   char __user * __user *,
 			   struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
-
-/* kernel/signal_64.c */
+/* kernel/signal.c */
 asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 				struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/sys_x86_64.c */
+struct new_utsname;
+
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
 			 unsigned long, unsigned long, unsigned long);
-struct new_utsname;
 asmlinkage long sys_uname(struct new_utsname __user *);
 
 #endif /* CONFIG_X86_32 */
-- 
1.6.0.6



