Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYL0QJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYL0QJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 11:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYL0QJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 11:09:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYL0QJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 11:09:11 -0500
Subject: [PATCH] x86: introducing asm/sys_ia32.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Dec 2008 21:37:10 +0530
Message-Id: <1230394031.8231.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid 44 sparse warnings, new file asm/sys_ia32.h

Fixes following sparse warnings:
  CHECK   arch/x86/ia32/sys_ia32.c
arch/x86/ia32/sys_ia32.c:53:17: warning: symbol 'sys32_truncate64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:60:17: warning: symbol 'sys32_ftruncate64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:98:17: warning: symbol 'sys32_stat64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:109:17: warning: symbol 'sys32_lstat64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:119:17: warning: symbol 'sys32_fstat64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:128:17: warning: symbol 'sys32_fstatat' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:164:17: warning: symbol 'sys32_mmap' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:195:17: warning: symbol 'sys32_mprotect' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:201:17: warning: symbol 'sys32_pipe' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:215:17: warning: symbol 'sys32_rt_sigaction' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:291:17: warning: symbol 'sys32_sigaction' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:330:17: warning: symbol 'sys32_rt_sigprocmask' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:370:17: warning: symbol 'sys32_alarm' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:383:17: warning: symbol 'sys32_old_select' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:393:17: warning: symbol 'sys32_waitpid' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:401:17: warning: symbol 'sys32_sysfs' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:406:17: warning: symbol 'sys32_sched_rr_get_interval' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:421:17: warning: symbol 'sys32_rt_sigpending' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:445:17: warning: symbol 'sys32_rt_sigqueueinfo' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:472:17: warning: symbol 'sys32_sysctl' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:517:17: warning: symbol 'sys32_pread' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:524:17: warning: symbol 'sys32_pwrite' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:532:17: warning: symbol 'sys32_personality' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:545:17: warning: symbol 'sys32_sendfile' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:565:17: warning: symbol 'sys32_mmap2' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:589:17: warning: symbol 'sys32_olduname' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:626:6: warning: symbol 'sys32_uname' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:641:6: warning: symbol 'sys32_ustat' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:663:17: warning: symbol 'sys32_execve' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:678:17: warning: symbol 'sys32_clone' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:693:6: warning: symbol 'sys32_lseek' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:698:6: warning: symbol 'sys32_kill' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:703:6: warning: symbol 'sys32_fadvise64_64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:712:6: warning: symbol 'sys32_vm86_warning' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:726:6: warning: symbol 'sys32_lookup_dcookie' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:732:20: warning: symbol 'sys32_readahead' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:738:17: warning: symbol 'sys32_sync_file_range' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:746:17: warning: symbol 'sys32_fadvise64' was not declared. Should it be static?
arch/x86/ia32/sys_ia32.c:753:17: warning: symbol 'sys32_fallocate' was not declared. Should it be static?
  CHECK   arch/x86/ia32/ia32_signal.c
arch/x86/ia32/ia32_signal.c:126:17: warning: symbol 'sys32_sigsuspend' was not declared. Should it be static?
arch/x86/ia32/ia32_signal.c:141:17: warning: symbol 'sys32_sigaltstack' was not declared. Should it be static?
arch/x86/ia32/ia32_signal.c:249:17: warning: symbol 'sys32_sigreturn' was not declared. Should it be static?
arch/x86/ia32/ia32_signal.c:279:17: warning: symbol 'sys32_rt_sigreturn' was not declared. Should it be static?
  CHECK   arch/x86/ia32/ipc32.c
arch/x86/ia32/ipc32.c:12:17: warning: symbol 'sys32_ipc' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/ia32/ia32_signal.c     |    3 +-
 arch/x86/ia32/ipc32.c           |    1 +
 arch/x86/ia32/sys_ia32.c        |    2 +-
 arch/x86/include/asm/sys_ia32.h |  101 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/sys_ia32.h

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index b195f85..9dabd00 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -24,15 +24,14 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
-#include <asm/ia32.h>
 #include <asm/ptrace.h>
 #include <asm/ia32_unistd.h>
 #include <asm/user32.h>
 #include <asm/sigcontext32.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
-
 #include <asm/sigframe.h>
+#include <asm/sys_ia32.h>
 
 #define DEBUG_SIG 0
 
diff --git a/arch/x86/ia32/ipc32.c b/arch/x86/ia32/ipc32.c
index d21991c..29cdcd0 100644
--- a/arch/x86/ia32/ipc32.c
+++ b/arch/x86/ia32/ipc32.c
@@ -8,6 +8,7 @@
 #include <linux/shm.h>
 #include <linux/ipc.h>
 #include <linux/compat.h>
+#include <asm/sys_ia32.h>
 
 asmlinkage long sys32_ipc(u32 call, int first, int second, int third,
 			  compat_uptr_t ptr, u32 fifth)
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 2e09dcd..6c0d7f6 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -44,8 +44,8 @@
 #include <asm/types.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
-#include <asm/ia32.h>
 #include <asm/vgtod.h>
+#include <asm/sys_ia32.h>
 
 #define AA(__x)		((unsigned long)(__x))
 
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
new file mode 100644
index 0000000..ffb08be
--- /dev/null
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -0,0 +1,101 @@
+/*
+ * sys_ia32.h - Linux ia32 syscall interfaces
+ *
+ * Copyright (c) 2008 Jaswinder Singh Rajput
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef _ASM_X86_SYS_IA32_H
+#define _ASM_X86_SYS_IA32_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+#include <asm/compat.h>
+#include <asm/ia32.h>
+
+/* ia32/sys_ia32.c */
+asmlinkage long sys32_truncate64(char __user *, unsigned long, unsigned long);
+asmlinkage long sys32_ftruncate64(unsigned int, unsigned long, unsigned long);
+
+asmlinkage long sys32_stat64(char __user *, struct stat64 __user *);
+asmlinkage long sys32_lstat64(char __user *, struct stat64 __user *);
+asmlinkage long sys32_fstat64(unsigned int, struct stat64 __user *);
+asmlinkage long sys32_fstatat(unsigned int, char __user *,
+			      struct stat64 __user *, int);
+struct mmap_arg_struct;
+asmlinkage long sys32_mmap(struct mmap_arg_struct __user *);
+asmlinkage long sys32_mprotect(unsigned long, size_t, unsigned long);
+
+asmlinkage long sys32_pipe(int __user *);
+struct sigaction32;
+struct old_sigaction32;
+asmlinkage long sys32_rt_sigaction(int, struct sigaction32 __user *,
+				   struct sigaction32 __user *, unsigned int);
+asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
+				struct old_sigaction32 __user *);
+asmlinkage long sys32_rt_sigprocmask(int, compat_sigset_t __user *,
+				     compat_sigset_t __user *, unsigned int);
+asmlinkage long sys32_alarm(unsigned int);
+
+struct sel_arg_struct;
+asmlinkage long sys32_old_select(struct sel_arg_struct __user *);
+asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
+asmlinkage long sys32_sysfs(int, u32, u32);
+
+asmlinkage long sys32_sched_rr_get_interval(compat_pid_t,
+					    struct compat_timespec __user *);
+asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *, compat_size_t);
+asmlinkage long sys32_rt_sigqueueinfo(int, int, compat_siginfo_t __user *);
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+struct sysctl_ia32;
+asmlinkage long sys32_sysctl(struct sysctl_ia32 __user *);
+#endif
+
+asmlinkage long sys32_pread(unsigned int, char __user *, u32, u32, u32);
+asmlinkage long sys32_pwrite(unsigned int, char __user *, u32, u32, u32);
+
+asmlinkage long sys32_personality(unsigned long);
+asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
+
+asmlinkage long sys32_mmap2(unsigned long, unsigned long, unsigned long,
+			    unsigned long, unsigned long, unsigned long);
+
+struct oldold_utsname;
+struct old_utsname;
+asmlinkage long sys32_olduname(struct oldold_utsname __user *);
+long sys32_uname(struct old_utsname __user *);
+
+long sys32_ustat(unsigned, struct ustat32 __user *);
+
+asmlinkage long sys32_execve(char __user *, compat_uptr_t __user *,
+			     compat_uptr_t __user *, struct pt_regs *);
+asmlinkage long sys32_clone(unsigned int, unsigned int, struct pt_regs *);
+
+long sys32_lseek(unsigned int, int, unsigned int);
+long sys32_kill(int, int);
+long sys32_fadvise64_64(int, __u32, __u32, __u32, __u32, int);
+long sys32_vm86_warning(void);
+long sys32_lookup_dcookie(u32, u32, char __user *, size_t);
+
+asmlinkage ssize_t sys32_readahead(int, unsigned, unsigned, size_t);
+asmlinkage long sys32_sync_file_range(int, unsigned, unsigned,
+				      unsigned, unsigned, int);
+asmlinkage long sys32_fadvise64(int, unsigned, unsigned, size_t, int);
+asmlinkage long sys32_fallocate(int, int, unsigned,
+				unsigned, unsigned, unsigned);
+
+/* ia32/ia32_signal.c */
+asmlinkage long sys32_sigsuspend(int, int, old_sigset_t);
+asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *,
+				  stack_ia32_t __user *, struct pt_regs *);
+asmlinkage long sys32_sigreturn(struct pt_regs *);
+asmlinkage long sys32_rt_sigreturn(struct pt_regs *);
+
+/* ia32/ipc32.c */
+asmlinkage long sys32_ipc(u32, int, int, int, compat_uptr_t, u32);
+#endif /* _ASM_X86_SYS_IA32_H */
-- 
1.5.5.1



