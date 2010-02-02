Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0BBVW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:22:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab0BBVWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:22:22 -0500
Date: Tue, 2 Feb 2010 16:22:00 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Message-Id: <9c7cb53efdf9b2c553911098f3633f63e92f9b3d.1265142153.git.jbaron@redhat.com>
In-Reply-To: <cover.1265142153.git.jbaron@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com>
Subject: [PATCH 6/6] x86: convert compat syscalls to use 'DEFINE_SYSCALL()' macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert x86 compat syscalls to use SYSCALL_PREFIX_DEFINE#() macros. This allows
us to hook the compat syscalls into the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/ia32/sys_ia32.c |  106 +++++++++++++++++++++++-----------------------
 1 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 422572c..751d950 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -50,15 +50,15 @@
 #define AA(__x)		((unsigned long)(__x))
 
 
-asmlinkage long sys32_truncate64(char __user *filename,
-				 unsigned long offset_low,
-				 unsigned long offset_high)
+SYSCALL_PREFIX_DEFINE3(32_, truncate64, char __user *, filename,
+				 unsigned long, offset_low,
+				 unsigned long, offset_high)
 {
        return sys_truncate(filename, ((loff_t) offset_high << 32) | offset_low);
 }
 
-asmlinkage long sys32_ftruncate64(unsigned int fd, unsigned long offset_low,
-				  unsigned long offset_high)
+SYSCALL_PREFIX_DEFINE3(32_, ftruncate64, unsigned int, fd, unsigned long, offset_low,
+				  unsigned long, offset_high)
 {
        return sys_ftruncate(fd, ((loff_t) offset_high << 32) | offset_low);
 }
@@ -95,8 +95,8 @@ static int cp_stat64(struct stat64 __user *ubuf, struct kstat *stat)
 	return 0;
 }
 
-asmlinkage long sys32_stat64(char __user *filename,
-			     struct stat64 __user *statbuf)
+SYSCALL_PREFIX_DEFINE2(32_, stat64, char __user *, filename,
+			     struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_stat(filename, &stat);
@@ -106,8 +106,8 @@ asmlinkage long sys32_stat64(char __user *filename,
 	return ret;
 }
 
-asmlinkage long sys32_lstat64(char __user *filename,
-			      struct stat64 __user *statbuf)
+SYSCALL_PREFIX_DEFINE2(32_, lstat64, char __user *, filename,
+			      struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_lstat(filename, &stat);
@@ -116,7 +116,7 @@ asmlinkage long sys32_lstat64(char __user *filename,
 	return ret;
 }
 
-asmlinkage long sys32_fstat64(unsigned int fd, struct stat64 __user *statbuf)
+SYSCALL_PREFIX_DEFINE2(32_, fstat64, unsigned int, fd, struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_fstat(fd, &stat);
@@ -125,8 +125,8 @@ asmlinkage long sys32_fstat64(unsigned int fd, struct stat64 __user *statbuf)
 	return ret;
 }
 
-asmlinkage long sys32_fstatat(unsigned int dfd, char __user *filename,
-			      struct stat64 __user *statbuf, int flag)
+SYSCALL_PREFIX_DEFINE4(32_, fstatat, unsigned int, dfd, char __user *, filename,
+			      struct stat64 __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error;
@@ -152,7 +152,7 @@ struct mmap_arg_struct {
 	unsigned int offset;
 };
 
-asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
+SYSCALL_PREFIX_DEFINE1(32_, mmap, struct mmap_arg_struct __user *, arg)
 {
 	struct mmap_arg_struct a;
 
@@ -166,15 +166,15 @@ asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
 			       a.offset>>PAGE_SHIFT);
 }
 
-asmlinkage long sys32_mprotect(unsigned long start, size_t len,
-			       unsigned long prot)
+SYSCALL_PREFIX_DEFINE3(32_, mprotect, unsigned long, start, size_t, len,
+			       unsigned long, prot)
 {
 	return sys_mprotect(start, len, prot);
 }
 
-asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
-				   struct sigaction32 __user *oact,
-				   unsigned int sigsetsize)
+SYSCALL_PREFIX_DEFINE4(32_, rt_sigaction, int, sig, struct sigaction32 __user *, act,
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
+SYSCALL_PREFIX_DEFINE3(32_, sigaction, int, sig, struct old_sigaction32 __user *, act,
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
+SYSCALL_PREFIX_DEFINE4(32_, rt_sigprocmask, int, how, compat_sigset_t __user *, set,
+				     compat_sigset_t __user *, oset,
+				     unsigned int, sigsetsize)
 {
 	sigset_t s;
 	compat_sigset_t s32;
@@ -327,7 +327,7 @@ asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 	return 0;
 }
 
-asmlinkage long sys32_alarm(unsigned int seconds)
+SYSCALL_PREFIX_DEFINE1(32_, alarm, unsigned int, seconds)
 {
 	return alarm_setitimer(seconds);
 }
@@ -340,7 +340,7 @@ struct sel_arg_struct {
 	unsigned int tvp;
 };
 
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *arg)
+SYSCALL_PREFIX_DEFINE1(32_, old_select, struct sel_arg_struct __user *, arg)
 {
 	struct sel_arg_struct a;
 
@@ -350,21 +350,21 @@ asmlinkage long sys32_old_select(struct sel_arg_struct __user *arg)
 				 compat_ptr(a.exp), compat_ptr(a.tvp));
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
-			      int options)
+SYSCALL_PREFIX_DEFINE3(32_, waitpid, compat_pid_t, pid, unsigned int *, stat_addr,
+			      int, options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
 }
 
 /* 32-bit timeval and related flotsam.  */
 
-asmlinkage long sys32_sysfs(int option, u32 arg1, u32 arg2)
+SYSCALL_PREFIX_DEFINE3(32_, sysfs, int, option, u32, arg1, u32, arg2)
 {
 	return sys_sysfs(option, arg1, arg2);
 }
 
-asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
-				    struct compat_timespec __user *interval)
+SYSCALL_PREFIX_DEFINE2(32_, sched_rr_get_interval, compat_pid_t, pid,
+				    struct compat_timespec __user *, interval)
 {
 	struct timespec t;
 	int ret;
@@ -378,8 +378,8 @@ asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
-				    compat_size_t sigsetsize)
+SYSCALL_PREFIX_DEFINE2(32_, rt_sigpending, compat_sigset_t __user *, set,
+				    compat_size_t, sigsetsize)
 {
 	sigset_t s;
 	compat_sigset_t s32;
@@ -402,8 +402,8 @@ asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
-				      compat_siginfo_t __user *uinfo)
+SYSCALL_PREFIX_DEFINE3(32_, rt_sigqueueinfo, int, pid, int, sig,
+				      compat_siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
 	int ret;
@@ -418,22 +418,22 @@ asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
 }
 
 /* warning: next two assume little endian */
-asmlinkage long sys32_pread(unsigned int fd, char __user *ubuf, u32 count,
-			    u32 poslo, u32 poshi)
+SYSCALL_PREFIX_DEFINE5(32_, pread, unsigned int, fd, char __user *, ubuf, u32, count,
+			    u32, poslo, u32, poshi)
 {
 	return sys_pread64(fd, ubuf, count,
 			 ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
-asmlinkage long sys32_pwrite(unsigned int fd, char __user *ubuf, u32 count,
-			     u32 poslo, u32 poshi)
+SYSCALL_PREFIX_DEFINE5(32_, pwrite, unsigned int, fd, char __user *, ubuf, u32, count,
+			     u32, poslo, u32, poshi)
 {
 	return sys_pwrite64(fd, ubuf, count,
 			  ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
 
-asmlinkage long sys32_personality(unsigned long personality)
+SYSCALL_PREFIX_DEFINE1(32_, personality, unsigned long, personality)
 {
 	int ret;
 
@@ -446,8 +446,8 @@ asmlinkage long sys32_personality(unsigned long personality)
 	return ret;
 }
 
-asmlinkage long sys32_sendfile(int out_fd, int in_fd,
-			       compat_off_t __user *offset, s32 count)
+SYSCALL_PREFIX_DEFINE4(32_, sendfile, int, out_fd, int, in_fd,
+			       compat_off_t __user *, offset, s32, count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
@@ -466,7 +466,7 @@ asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 	return ret;
 }
 
-asmlinkage long sys32_olduname(struct oldold_utsname __user *name)
+SYSCALL_PREFIX_DEFINE1(32_, olduname, struct oldold_utsname __user *, name)
 {
 	char *arch = "x86_64";
 	int err;
@@ -518,8 +518,8 @@ long sys32_uname(struct old_utsname __user *name)
 	return err ? -EFAULT : 0;
 }
 
-asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
-			     compat_uptr_t __user *envp, struct pt_regs *regs)
+SYSCALL_PREFIX_DEFINE4(32_, execve, char __user *, name, compat_uptr_t __user *, argv,
+			compat_uptr_t __user *, envp, struct pt_regs *, regs)
 {
 	long error;
 	char *filename;
@@ -533,8 +533,8 @@ asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 	return error;
 }
 
-asmlinkage long sys32_clone(unsigned int clone_flags, unsigned int newsp,
-			    struct pt_regs *regs)
+SYSCALL_PREFIX_DEFINE3(32_, clone, unsigned int, clone_flags, unsigned int, newsp,
+			    struct pt_regs *, regs)
 {
 	void __user *parent_tid = (void __user *)regs->dx;
 	void __user *child_tid = (void __user *)regs->di;
@@ -593,24 +593,24 @@ asmlinkage ssize_t sys32_readahead(int fd, unsigned off_lo, unsigned off_hi,
 	return sys_readahead(fd, ((u64)off_hi << 32) | off_lo, count);
 }
 
-asmlinkage long sys32_sync_file_range(int fd, unsigned off_low, unsigned off_hi,
-				      unsigned n_low, unsigned n_hi,  int flags)
+SYSCALL_PREFIX_DEFINE6(32_, sync_file_range, int, fd, unsigned, off_low, unsigned, off_hi,
+			unsigned, n_low, unsigned, n_hi,  int, flags)
 {
 	return sys_sync_file_range(fd,
 				   ((u64)off_hi << 32) | off_low,
 				   ((u64)n_hi << 32) | n_low, flags);
 }
 
-asmlinkage long sys32_fadvise64(int fd, unsigned offset_lo, unsigned offset_hi,
-				size_t len, int advice)
+SYSCALL_PREFIX_DEFINE5(32_, fadvise64, int, fd, unsigned, offset_lo, unsigned, offset_hi,
+				size_t, len, int, advice)
 {
 	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
 				len, advice);
 }
 
-asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
-				unsigned offset_hi, unsigned len_lo,
-				unsigned len_hi)
+SYSCALL_PREFIX_DEFINE6(32_, fallocate, int, fd, int, mode, unsigned, offset_lo,
+				unsigned, offset_hi, unsigned, len_lo,
+				unsigned, len_hi)
 {
 	return sys_fallocate(fd, mode, ((u64)offset_hi << 32) | offset_lo,
 			     ((u64)len_hi << 32) | len_lo);
-- 
1.6.5.1

