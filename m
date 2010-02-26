Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966305Ab0BZVjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966250Ab0BZViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:38:03 -0500
Date: Fri, 26 Feb 2010 16:37:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <e951a89a6a69eb84be45efb3b876d534a11b2fe0.1267214186.git.jbaron@redhat.com>
In-Reply-To: <cover.1267214186.git.jbaron@redhat.com>
References: <cover.1267214186.git.jbaron@redhat.com>
Subject: [PATCH 07/12] x86, compat: convert ia32 layer to use ARCH_COMPAT_SYSCALL_DEFINE#N()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new ARCH_COMPAT_SYSCALL_DEFINE#N() macros to tie the compat
syscalls into the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/ia32/ia32entry.S |   50 +++++++++++-----------
 arch/x86/ia32/sys_ia32.c  |  106 ++++++++++++++++++++++----------------------
 2 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index acc6fbf..f37212d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -472,9 +472,9 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn, %rdi
 	PTREGSCALL stub32_sigreturn, sys32_sigreturn, %rdi
 	PTREGSCALL stub32_sigaltstack, sys32_sigaltstack, %rdx
-	PTREGSCALL stub32_execve, sys32_execve, %rcx
+	PTREGSCALL stub32_execve, arch_compat_sys_execve, %rcx
 	PTREGSCALL stub32_fork, sys_fork, %rdi
-	PTREGSCALL stub32_clone, sys32_clone, %rdx
+	PTREGSCALL stub32_clone, arch_compat_sys_clone, %rdx
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 
@@ -512,7 +512,7 @@ ia32_sys_call_table:
 	.quad sys_write
 	.quad compat_sys_open		/* 5 */
 	.quad sys_close
-	.quad sys32_waitpid
+	.quad arch_compat_sys_waitpid
 	.quad sys_creat
 	.quad sys_link
 	.quad sys_unlink		/* 10 */
@@ -564,7 +564,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall			/* old mpx syscall holder */
 	.quad sys_setpgid
 	.quad quiet_ni_syscall			/* old ulimit syscall holder */
-	.quad sys32_olduname
+	.quad arch_compat_sys_olduname
 	.quad sys_umask		/* 60 */
 	.quad sys_chroot
 	.quad compat_sys_ustat
@@ -572,7 +572,7 @@ ia32_sys_call_table:
 	.quad sys_getppid
 	.quad sys_getpgrp		/* 65 */
 	.quad sys_setsid
-	.quad sys32_sigaction
+	.quad arch_compat_sys_sigaction
 	.quad sys_sgetmask
 	.quad sys_ssetmask
 	.quad sys_setreuid16	/* 70 */
@@ -587,7 +587,7 @@ ia32_sys_call_table:
 	.quad compat_sys_settimeofday
 	.quad sys_getgroups16	/* 80 */
 	.quad sys_setgroups16
-	.quad sys32_old_select
+	.quad arch_compat_sys_old_select
 	.quad sys_symlink
 	.quad sys_lstat
 	.quad sys_readlink		/* 85 */
@@ -595,7 +595,7 @@ ia32_sys_call_table:
 	.quad sys_swapon
 	.quad sys_reboot
 	.quad compat_sys_old_readdir
-	.quad sys32_mmap		/* 90 */
+	.quad arch_compat_sys_mmap		/* 90 */
 	.quad sys_munmap
 	.quad sys_truncate
 	.quad sys_ftruncate
@@ -630,7 +630,7 @@ ia32_sys_call_table:
 	.quad sys_uname
 	.quad sys_modify_ldt
 	.quad compat_sys_adjtimex
-	.quad sys32_mprotect		/* 125 */
+	.quad arch_compat_sys_mprotect		/* 125 */
 	.quad compat_sys_sigprocmask
 	.quad quiet_ni_syscall		/* create_module */
 	.quad sys_init_module
@@ -666,7 +666,7 @@ ia32_sys_call_table:
 	.quad sys_sched_yield
 	.quad sys_sched_get_priority_max
 	.quad sys_sched_get_priority_min  /* 160 */
-	.quad sys32_sched_rr_get_interval
+	.quad arch_compat_sys_sched_rr_get_interval
 	.quad compat_sys_nanosleep
 	.quad sys_mremap
 	.quad sys_setresuid16
@@ -679,30 +679,30 @@ ia32_sys_call_table:
 	.quad sys_getresgid16
 	.quad sys_prctl
 	.quad stub32_rt_sigreturn
-	.quad sys32_rt_sigaction
-	.quad sys32_rt_sigprocmask	/* 175 */
-	.quad sys32_rt_sigpending
+	.quad arch_compat_sys_rt_sigaction
+	.quad arch_compat_sys_rt_sigprocmask	/* 175 */
+	.quad arch_compat_sys_rt_sigpending
 	.quad compat_sys_rt_sigtimedwait
-	.quad sys32_rt_sigqueueinfo
+	.quad arch_compat_sys_rt_sigqueueinfo
 	.quad sys_rt_sigsuspend
-	.quad sys32_pread		/* 180 */
-	.quad sys32_pwrite
+	.quad arch_compat_sys_pread		/* 180 */
+	.quad arch_compat_sys_pwrite
 	.quad sys_chown16
 	.quad sys_getcwd
 	.quad sys_capget
 	.quad sys_capset
 	.quad stub32_sigaltstack
-	.quad sys32_sendfile
+	.quad arch_compat_sys_sendfile
 	.quad quiet_ni_syscall		/* streams1 */
 	.quad quiet_ni_syscall		/* streams2 */
 	.quad stub32_vfork            /* 190 */
 	.quad compat_sys_getrlimit
 	.quad sys_mmap_pgoff
-	.quad sys32_truncate64
-	.quad sys32_ftruncate64
-	.quad sys32_stat64		/* 195 */
-	.quad sys32_lstat64
-	.quad sys32_fstat64
+	.quad arch_compat_sys_truncate64
+	.quad arch_compat_sys_ftruncate64
+	.quad arch_compat_sys_stat64		/* 195 */
+	.quad arch_compat_sys_lstat64
+	.quad arch_compat_sys_fstat64
 	.quad sys_lchown
 	.quad sys_getuid
 	.quad sys_getgid		/* 200 */
@@ -755,7 +755,7 @@ ia32_sys_call_table:
 	.quad compat_sys_io_getevents
 	.quad compat_sys_io_submit
 	.quad sys_io_cancel
-	.quad sys32_fadvise64		/* 250 */
+	.quad arch_compat_sys_fadvise64		/* 250 */
 	.quad quiet_ni_syscall 	/* free_huge_pages */
 	.quad sys_exit_group
 	.quad sys32_lookup_dcookie
@@ -805,7 +805,7 @@ ia32_sys_call_table:
 	.quad sys_mknodat
 	.quad sys_fchownat
 	.quad compat_sys_futimesat
-	.quad sys32_fstatat		/* 300 */
+	.quad arch_compat_sys_fstatat		/* 300 */
 	.quad sys_unlinkat
 	.quad sys_renameat
 	.quad sys_linkat
@@ -819,7 +819,7 @@ ia32_sys_call_table:
 	.quad compat_sys_set_robust_list
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
-	.quad sys32_sync_file_range
+	.quad arch_compat_sys_sync_file_range
 	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
@@ -829,7 +829,7 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd
 	.quad sys_timerfd_create
 	.quad sys_eventfd
-	.quad sys32_fallocate
+	.quad arch_compat_sys_fallocate
 	.quad compat_sys_timerfd_settime	/* 325 */
 	.quad compat_sys_timerfd_gettime
 	.quad compat_sys_signalfd4
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 422572c..70b9ee1 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -50,15 +50,15 @@
 #define AA(__x)		((unsigned long)(__x))
 
 
-asmlinkage long sys32_truncate64(char __user *filename,
-				 unsigned long offset_low,
-				 unsigned long offset_high)
+ARCH_COMPAT_SYSCALL_DEFINE3(truncate64, char __user *, filename,
+				 unsigned long, offset_low,
+				 unsigned long, offset_high)
 {
        return sys_truncate(filename, ((loff_t) offset_high << 32) | offset_low);
 }
 
-asmlinkage long sys32_ftruncate64(unsigned int fd, unsigned long offset_low,
-				  unsigned long offset_high)
+ARCH_COMPAT_SYSCALL_DEFINE3(ftruncate64, unsigned int, fd, unsigned long, offset_low,
+				  unsigned long, offset_high)
 {
        return sys_ftruncate(fd, ((loff_t) offset_high << 32) | offset_low);
 }
@@ -95,8 +95,8 @@ static int cp_stat64(struct stat64 __user *ubuf, struct kstat *stat)
 	return 0;
 }
 
-asmlinkage long sys32_stat64(char __user *filename,
-			     struct stat64 __user *statbuf)
+ARCH_COMPAT_SYSCALL_DEFINE2(stat64, char __user *, filename,
+			     struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_stat(filename, &stat);
@@ -106,8 +106,8 @@ asmlinkage long sys32_stat64(char __user *filename,
 	return ret;
 }
 
-asmlinkage long sys32_lstat64(char __user *filename,
-			      struct stat64 __user *statbuf)
+ARCH_COMPAT_SYSCALL_DEFINE2(lstat64, char __user *, filename,
+			      struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_lstat(filename, &stat);
@@ -116,7 +116,7 @@ asmlinkage long sys32_lstat64(char __user *filename,
 	return ret;
 }
 
-asmlinkage long sys32_fstat64(unsigned int fd, struct stat64 __user *statbuf)
+ARCH_COMPAT_SYSCALL_DEFINE2(fstat64, unsigned int, fd, struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_fstat(fd, &stat);
@@ -125,8 +125,8 @@ asmlinkage long sys32_fstat64(unsigned int fd, struct stat64 __user *statbuf)
 	return ret;
 }
 
-asmlinkage long sys32_fstatat(unsigned int dfd, char __user *filename,
-			      struct stat64 __user *statbuf, int flag)
+ARCH_COMPAT_SYSCALL_DEFINE4(fstatat, unsigned int, dfd, char __user *, filename,
+			      struct stat64 __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error;
@@ -152,7 +152,7 @@ struct mmap_arg_struct {
 	unsigned int offset;
 };
 
-asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
+ARCH_COMPAT_SYSCALL_DEFINE1(mmap, struct mmap_arg_struct __user *, arg)
 {
 	struct mmap_arg_struct a;
 
@@ -166,15 +166,15 @@ asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
 			       a.offset>>PAGE_SHIFT);
 }
 
-asmlinkage long sys32_mprotect(unsigned long start, size_t len,
-			       unsigned long prot)
+ARCH_COMPAT_SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
+			       unsigned long, prot)
 {
 	return sys_mprotect(start, len, prot);
 }
 
-asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
-				   struct sigaction32 __user *oact,
-				   unsigned int sigsetsize)
+ARCH_COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig, struct sigaction32 __user *, act,
+				   struct sigaction32 __user *, oact,
+				   unsigned int, sigsetsize)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -248,8 +248,8 @@ asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
-				struct old_sigaction32 __user *oact)
+ARCH_COMPAT_SYSCALL_DEFINE3(sigaction, int, sig, struct old_sigaction32 __user *, act,
+				struct old_sigaction32 __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -287,9 +287,9 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
-				     compat_sigset_t __user *oset,
-				     unsigned int sigsetsize)
+ARCH_COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, set,
+				     compat_sigset_t __user *, oset,
+				     unsigned int, sigsetsize)
 {
 	sigset_t s;
 	compat_sigset_t s32;
@@ -327,7 +327,7 @@ asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 	return 0;
 }
 
-asmlinkage long sys32_alarm(unsigned int seconds)
+ARCH_COMPAT_SYSCALL_DEFINE1(alarm, unsigned int, seconds)
 {
 	return alarm_setitimer(seconds);
 }
@@ -340,7 +340,7 @@ struct sel_arg_struct {
 	unsigned int tvp;
 };
 
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *arg)
+ARCH_COMPAT_SYSCALL_DEFINE1(old_select, struct sel_arg_struct __user *, arg)
 {
 	struct sel_arg_struct a;
 
@@ -350,21 +350,21 @@ asmlinkage long sys32_old_select(struct sel_arg_struct __user *arg)
 				 compat_ptr(a.exp), compat_ptr(a.tvp));
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
-			      int options)
+ARCH_COMPAT_SYSCALL_DEFINE3(waitpid, compat_pid_t, pid, unsigned int *, stat_addr,
+			      int, options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
 }
 
 /* 32-bit timeval and related flotsam.  */
 
-asmlinkage long sys32_sysfs(int option, u32 arg1, u32 arg2)
+ARCH_COMPAT_SYSCALL_DEFINE3(sysfs, int, option, u32, arg1, u32, arg2)
 {
 	return sys_sysfs(option, arg1, arg2);
 }
 
-asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
-				    struct compat_timespec __user *interval)
+ARCH_COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval, compat_pid_t, pid,
+				    struct compat_timespec __user *, interval)
 {
 	struct timespec t;
 	int ret;
@@ -378,8 +378,8 @@ asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
-				    compat_size_t sigsetsize)
+ARCH_COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, set,
+				    compat_size_t, sigsetsize)
 {
 	sigset_t s;
 	compat_sigset_t s32;
@@ -402,8 +402,8 @@ asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
-				      compat_siginfo_t __user *uinfo)
+ARCH_COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo, int, pid, int, sig,
+				      compat_siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
 	int ret;
@@ -418,22 +418,22 @@ asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
 }
 
 /* warning: next two assume little endian */
-asmlinkage long sys32_pread(unsigned int fd, char __user *ubuf, u32 count,
-			    u32 poslo, u32 poshi)
+ARCH_COMPAT_SYSCALL_DEFINE5(pread, unsigned int, fd, char __user *, ubuf, u32, count,
+			    u32, poslo, u32, poshi)
 {
 	return sys_pread64(fd, ubuf, count,
 			 ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
-asmlinkage long sys32_pwrite(unsigned int fd, char __user *ubuf, u32 count,
-			     u32 poslo, u32 poshi)
+ARCH_COMPAT_SYSCALL_DEFINE5(pwrite, unsigned int, fd, char __user *, ubuf, u32, count,
+			     u32, poslo, u32, poshi)
 {
 	return sys_pwrite64(fd, ubuf, count,
 			  ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
 
-asmlinkage long sys32_personality(unsigned long personality)
+ARCH_COMPAT_SYSCALL_DEFINE1(personality, unsigned long, personality)
 {
 	int ret;
 
@@ -446,8 +446,8 @@ asmlinkage long sys32_personality(unsigned long personality)
 	return ret;
 }
 
-asmlinkage long sys32_sendfile(int out_fd, int in_fd,
-			       compat_off_t __user *offset, s32 count)
+ARCH_COMPAT_SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd,
+			       compat_off_t __user *, offset, s32, count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
@@ -466,7 +466,7 @@ asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 	return ret;
 }
 
-asmlinkage long sys32_olduname(struct oldold_utsname __user *name)
+ARCH_COMPAT_SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
 {
 	char *arch = "x86_64";
 	int err;
@@ -518,8 +518,8 @@ long sys32_uname(struct old_utsname __user *name)
 	return err ? -EFAULT : 0;
 }
 
-asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
-			     compat_uptr_t __user *envp, struct pt_regs *regs)
+ARCH_COMPAT_SYSCALL_DEFINE4(execve, char __user *, name, compat_uptr_t __user *, argv,
+			compat_uptr_t __user *, envp, struct pt_regs *, regs)
 {
 	long error;
 	char *filename;
@@ -533,8 +533,8 @@ asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 	return error;
 }
 
-asmlinkage long sys32_clone(unsigned int clone_flags, unsigned int newsp,
-			    struct pt_regs *regs)
+ARCH_COMPAT_SYSCALL_DEFINE3(clone, unsigned int, clone_flags, unsigned int, newsp,
+			    struct pt_regs *, regs)
 {
 	void __user *parent_tid = (void __user *)regs->dx;
 	void __user *child_tid = (void __user *)regs->di;
@@ -593,24 +593,24 @@ asmlinkage ssize_t sys32_readahead(int fd, unsigned off_lo, unsigned off_hi,
 	return sys_readahead(fd, ((u64)off_hi << 32) | off_lo, count);
 }
 
-asmlinkage long sys32_sync_file_range(int fd, unsigned off_low, unsigned off_hi,
-				      unsigned n_low, unsigned n_hi,  int flags)
+ARCH_COMPAT_SYSCALL_DEFINE6(sync_file_range, int, fd, unsigned, off_low, unsigned, off_hi,
+			unsigned, n_low, unsigned, n_hi,  int, flags)
 {
 	return sys_sync_file_range(fd,
 				   ((u64)off_hi << 32) | off_low,
 				   ((u64)n_hi << 32) | n_low, flags);
 }
 
-asmlinkage long sys32_fadvise64(int fd, unsigned offset_lo, unsigned offset_hi,
-				size_t len, int advice)
+ARCH_COMPAT_SYSCALL_DEFINE5(fadvise64, int, fd, unsigned, offset_lo, unsigned, offset_hi,
+				size_t, len, int, advice)
 {
 	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
 				len, advice);
 }
 
-asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
-				unsigned offset_hi, unsigned len_lo,
-				unsigned len_hi)
+ARCH_COMPAT_SYSCALL_DEFINE6(fallocate, int, fd, int, mode, unsigned, offset_lo,
+				unsigned, offset_hi, unsigned, len_lo,
+				unsigned, len_hi)
 {
 	return sys_fallocate(fd, mode, ((u64)offset_hi << 32) | offset_lo,
 			     ((u64)len_hi << 32) | len_lo);
-- 
1.6.5.1

