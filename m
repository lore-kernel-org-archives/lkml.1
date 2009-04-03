Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbZDCPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbZDCPFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932805AbZDCPF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:05:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:42002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbZDCPF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:05:26 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches 20090325
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238008857.2500.62.camel@ht.satnam>
References: <1238008857.2500.62.camel@ht.satnam>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 20:34:58 +0530
Message-Id: <1238771098.2489.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

I send this pull request earlier, I think earlier you was busy in merge
window.

This patch set is still valid for current -tip/master.

Can you pull from this request or should I send new pull request.

--
JSR

On Thu, 2009-03-26 at 00:50 +0530, Jaswinder Singh Rajput wrote:
> Hello Ingo,
> 
> This pull request is also applicable for -tip/x86/core:
> 
> The following changes since commit 311e638cd4f2baec681f302e4d4881fc646c5169:
>   Ingo Molnar (1):
>         Merge branch 'tracing/kmemtrace'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> 
> Jaswinder Singh Rajput (3):
>       x86: cpu_debug.c remove some not required header files
>       x86: syscalls.h cleanup
>       x86: sys_ia32.h cleanup
> 
>  arch/x86/include/asm/sys_ia32.h  |   16 +++++++------
>  arch/x86/include/asm/syscalls.h  |   45 ++++++++++++++++++++-----------------
>  arch/x86/kernel/cpu/cpu_debug.c  |    5 ----
>  3 files changed, 33 insertions(+), 33 deletions(-)
>  mode change 100755 => 100644 arch/x86/include/asm/cpu_debug.h
>  mode change 100755 => 100644 arch/x86/kernel/cpu/cpu_debug.c
> 
> Complete diff:
> diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
> old mode 100755
> new mode 100644
> diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
> index ffb08be..ad9bcc0 100644
> --- a/arch/x86/include/asm/sys_ia32.h
> +++ b/arch/x86/include/asm/sys_ia32.h
> @@ -12,11 +12,18 @@
>  
>  #include <linux/compiler.h>
>  #include <linux/linkage.h>
> -#include <linux/types.h>
>  #include <linux/signal.h>
> +#include <linux/types.h>
>  #include <asm/compat.h>
>  #include <asm/ia32.h>
>  
> +struct mmap_arg_struct;
> +struct old_sigaction32;
> +struct oldold_utsname;
> +struct sel_arg_struct;
> +struct old_utsname;
> +struct sigaction32;
> +
>  /* ia32/sys_ia32.c */
>  asmlinkage long sys32_truncate64(char __user *, unsigned long, unsigned long);
>  asmlinkage long sys32_ftruncate64(unsigned int, unsigned long, unsigned long);
> @@ -26,13 +33,10 @@ asmlinkage long sys32_lstat64(char __user *, struct stat64 __user *);
>  asmlinkage long sys32_fstat64(unsigned int, struct stat64 __user *);
>  asmlinkage long sys32_fstatat(unsigned int, char __user *,
>  			      struct stat64 __user *, int);
> -struct mmap_arg_struct;
>  asmlinkage long sys32_mmap(struct mmap_arg_struct __user *);
>  asmlinkage long sys32_mprotect(unsigned long, size_t, unsigned long);
>  
>  asmlinkage long sys32_pipe(int __user *);
> -struct sigaction32;
> -struct old_sigaction32;
>  asmlinkage long sys32_rt_sigaction(int, struct sigaction32 __user *,
>  				   struct sigaction32 __user *, unsigned int);
>  asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
> @@ -41,7 +45,6 @@ asmlinkage long sys32_rt_sigprocmask(int, compat_sigset_t __user *,
>  				     compat_sigset_t __user *, unsigned int);
>  asmlinkage long sys32_alarm(unsigned int);
>  
> -struct sel_arg_struct;
>  asmlinkage long sys32_old_select(struct sel_arg_struct __user *);
>  asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
>  asmlinkage long sys32_sysfs(int, u32, u32);
> @@ -65,8 +68,6 @@ asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
>  asmlinkage long sys32_mmap2(unsigned long, unsigned long, unsigned long,
>  			    unsigned long, unsigned long, unsigned long);
>  
> -struct oldold_utsname;
> -struct old_utsname;
>  asmlinkage long sys32_olduname(struct oldold_utsname __user *);
>  long sys32_uname(struct old_utsname __user *);
>  
> @@ -98,4 +99,5 @@ asmlinkage long sys32_rt_sigreturn(struct pt_regs *);
>  
>  /* ia32/ipc32.c */
>  asmlinkage long sys32_ipc(u32, int, int, int, compat_uptr_t, u32);
> +
>  #endif /* _ASM_X86_SYS_IA32_H */
> diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
> index 7043408..372b76e 100644
> --- a/arch/x86/include/asm/syscalls.h
> +++ b/arch/x86/include/asm/syscalls.h
> @@ -1,7 +1,7 @@
>  /*
>   * syscalls.h - Linux syscall interfaces (arch-specific)
>   *
> - * Copyright (c) 2008 Jaswinder Singh
> + * Copyright (c) 2008 Jaswinder Singh Rajput
>   *
>   * This file is released under the GPLv2.
>   * See the file COPYING for more details.
> @@ -12,50 +12,55 @@
>  
>  #include <linux/compiler.h>
>  #include <linux/linkage.h>
> -#include <linux/types.h>
>  #include <linux/signal.h>
> +#include <linux/types.h>
>  
>  /* Common in X86_32 and X86_64 */
>  /* kernel/ioport.c */
>  asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
>  
> +/* kernel/process.c */
> +int sys_fork(struct pt_regs *);
> +int sys_vfork(struct pt_regs *);
> +
>  /* kernel/ldt.c */
>  asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
>  
> +/* kernel/signal.c */
> +long sys_rt_sigreturn(struct pt_regs *);
> +
>  /* kernel/tls.c */
>  asmlinkage int sys_set_thread_area(struct user_desc __user *);
>  asmlinkage int sys_get_thread_area(struct user_desc __user *);
>  
>  /* X86_32 only */
>  #ifdef CONFIG_X86_32
> +/* kernel/ioport.c */
> +long sys_iopl(struct pt_regs *);
> +
>  /* kernel/process_32.c */
> -int sys_fork(struct pt_regs *);
>  int sys_clone(struct pt_regs *);
> -int sys_vfork(struct pt_regs *);
>  int sys_execve(struct pt_regs *);
>  
> -/* kernel/signal_32.c */
> +/* kernel/signal.c */
>  asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
>  asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
>  			     struct old_sigaction __user *);
>  int sys_sigaltstack(struct pt_regs *);
>  unsigned long sys_sigreturn(struct pt_regs *);
> -long sys_rt_sigreturn(struct pt_regs *);
> -
> -/* kernel/ioport.c */
> -long sys_iopl(struct pt_regs *);
>  
>  /* kernel/sys_i386_32.c */
> +struct mmap_arg_struct;
> +struct sel_arg_struct;
> +struct oldold_utsname;
> +struct old_utsname;
> +
>  asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
>  			  unsigned long, unsigned long, unsigned long);
> -struct mmap_arg_struct;
>  asmlinkage int old_mmap(struct mmap_arg_struct __user *);
> -struct sel_arg_struct;
>  asmlinkage int old_select(struct sel_arg_struct __user *);
>  asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
> -struct old_utsname;
>  asmlinkage int sys_uname(struct old_utsname __user *);
> -struct oldold_utsname;
>  asmlinkage int sys_olduname(struct oldold_utsname __user *);
>  
>  /* kernel/vm86_32.c */
> @@ -65,29 +70,27 @@ int sys_vm86(struct pt_regs *);
>  #else /* CONFIG_X86_32 */
>  
>  /* X86_64 only */
> +/* kernel/ioport.c */
> +asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
> +
>  /* kernel/process_64.c */
> -asmlinkage long sys_fork(struct pt_regs *);
>  asmlinkage long sys_clone(unsigned long, unsigned long,
>  			  void __user *, void __user *,
>  			  struct pt_regs *);
> -asmlinkage long sys_vfork(struct pt_regs *);
>  asmlinkage long sys_execve(char __user *, char __user * __user *,
>  			   char __user * __user *,
>  			   struct pt_regs *);
>  long sys_arch_prctl(int, unsigned long);
>  
> -/* kernel/ioport.c */
> -asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
> -
> -/* kernel/signal_64.c */
> +/* kernel/signal.c */
>  asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
>  				struct pt_regs *);
> -long sys_rt_sigreturn(struct pt_regs *);
>  
>  /* kernel/sys_x86_64.c */
> +struct new_utsname;
> +
>  asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
>  			 unsigned long, unsigned long, unsigned long);
> -struct new_utsname;
>  asmlinkage long sys_uname(struct new_utsname __user *);
>  
>  #endif /* CONFIG_X86_32 */
> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> old mode 100755
> new mode 100644
> index 46e29ab..871a4dc
> --- a/arch/x86/kernel/cpu/cpu_debug.c
> +++ b/arch/x86/kernel/cpu/cpu_debug.c
> @@ -6,16 +6,12 @@
>   * For licencing details see kernel-base/COPYING
>   */
>  
> -#include <linux/interrupt.h>
> -#include <linux/compiler.h>
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
> -#include <linux/kprobes.h>
>  #include <linux/uaccess.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/percpu.h>
> -#include <linux/signal.h>
>  #include <linux/errno.h>
>  #include <linux/sched.h>
>  #include <linux/types.h>
> @@ -26,7 +22,6 @@
>  #include <asm/cpu_debug.h>
>  #include <asm/paravirt.h>
>  #include <asm/system.h>
> -#include <asm/traps.h>
>  #include <asm/apic.h>
>  #include <asm/desc.h>
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

