Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYKYHK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYKYHK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYKYHKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:10:30 -0500
Received: from verein.lst.de ([213.95.11.210]:41610 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbYKYHK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:10:27 -0500
Date: Tue, 25 Nov 2008 08:10:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: torvalds@osdl.org
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] remove __ARCH_WANT_COMPAT_SYS_PTRACE
Message-ID: <20081125071003.GA592@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures now use the generic compat_sys_ptrace, as should every
new architecture that needs 32bit compat (if we'll ever get another).

Remove the now superflous __ARCH_WANT_COMPAT_SYS_PTRACE define, and also
kill a comment about __ARCH_SYS_PTRACE that was added after
__ARCH_SYS_PTRACE was already gone.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig	2008-11-25 01:12:30.000000000 +0530
+++ linux-2.6/arch/Kconfig	2008-11-25 01:12:57.000000000 +0530
@@ -79,8 +79,6 @@ config HAVE_KRETPROBES
 #	task_pt_regs()		in asm/processor.h or asm/ptrace.h
 #	arch_has_single_step()	if there is hardware single-step support
 #	arch_has_block_step()	if there is hardware block-step support
-#	arch_ptrace()		and not #define __ARCH_SYS_PTRACE
-#	compat_arch_ptrace()	and #define __ARCH_WANT_COMPAT_SYS_PTRACE
 #	asm/syscall.h		supplying asm-generic/syscall.h interface
 #	linux/regset.h		user_regset interfaces
 #	CORE_DUMP_USE_REGSET	#define'd in linux/elf.h
Index: linux-2.6/arch/ia64/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/ptrace.h	2008-11-25 01:13:10.000000000 +0530
+++ linux-2.6/arch/ia64/include/asm/ptrace.h	2008-11-25 01:13:13.000000000 +0530
@@ -325,8 +325,6 @@ static inline unsigned long user_stack_p
   #define arch_has_block_step()   (1)
   extern void user_enable_block_step(struct task_struct *);
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #endif /* !__KERNEL__ */
 
 /* pt_all_user_regs is used for PTRACE_GETREGS PTRACE_SETREGS */
Index: linux-2.6/arch/mips/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/ptrace.h	2008-11-25 01:13:18.000000000 +0530
+++ linux-2.6/arch/mips/include/asm/ptrace.h	2008-11-25 01:13:22.000000000 +0530
@@ -9,10 +9,6 @@
 #ifndef _ASM_PTRACE_H
 #define _ASM_PTRACE_H
 
-#ifdef CONFIG_64BIT
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-#endif
-
 /* 0 - 31 are integer registers, 32 - 63 are fp registers.  */
 #define FPR_BASE	32
 #define PC		64
Index: linux-2.6/arch/parisc/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/ptrace.h	2008-11-25 01:13:28.000000000 +0530
+++ linux-2.6/arch/parisc/include/asm/ptrace.h	2008-11-25 01:13:31.000000000 +0530
@@ -47,8 +47,6 @@ struct pt_regs {
 
 #define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 struct task_struct;
 #define arch_has_single_step()	1
 void user_disable_single_step(struct task_struct *task);
Index: linux-2.6/arch/powerpc/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/ptrace.h	2008-11-25 01:13:36.000000000 +0530
+++ linux-2.6/arch/powerpc/include/asm/ptrace.h	2008-11-25 01:13:38.000000000 +0530
@@ -55,8 +55,6 @@ struct pt_regs {
 
 #ifdef __powerpc64__
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #define STACK_FRAME_OVERHEAD	112	/* size of minimum stack frame */
 #define STACK_FRAME_LR_SAVE	2	/* Location of LR in stack frame */
 #define STACK_FRAME_REGS_MARKER	ASM_CONST(0x7265677368657265)
Index: linux-2.6/arch/s390/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/ptrace.h	2008-11-25 01:13:45.000000000 +0530
+++ linux-2.6/arch/s390/include/asm/ptrace.h	2008-11-25 01:13:47.000000000 +0530
@@ -486,8 +486,6 @@ struct task_struct;
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define user_stack_pointer(regs)((regs)->gprs[15])
Index: linux-2.6/arch/sparc/include/asm/ptrace_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/ptrace_64.h	2008-11-25 01:14:03.000000000 +0530
+++ linux-2.6/arch/sparc/include/asm/ptrace_64.h	2008-11-25 01:14:06.000000000 +0530
@@ -142,8 +142,6 @@ struct global_reg_snapshot {
 };
 extern struct global_reg_snapshot global_reg_snapshot[NR_CPUS];
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #define force_successful_syscall_return()	    \
 do {	current_thread_info()->syscall_noerror = 1; \
 } while (0)
Index: linux-2.6/arch/x86/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ptrace.h	2008-11-25 01:14:13.000000000 +0530
+++ linux-2.6/arch/x86/include/asm/ptrace.h	2008-11-25 01:14:16.000000000 +0530
@@ -271,8 +271,6 @@ extern int do_get_thread_area(struct tas
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
Index: linux-2.6/include/linux/compat.h
===================================================================
--- linux-2.6.orig/include/linux/compat.h	2008-11-25 01:14:24.000000000 +0530
+++ linux-2.6/include/linux/compat.h	2008-11-25 01:14:29.000000000 +0530
@@ -252,12 +252,10 @@ extern int compat_ptrace_request(struct 
 				 compat_long_t request,
 				 compat_ulong_t addr, compat_ulong_t data);
 
-#ifdef __ARCH_WANT_COMPAT_SYS_PTRACE
 extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			       compat_ulong_t addr, compat_ulong_t data);
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
-#endif	/* __ARCH_WANT_COMPAT_SYS_PTRACE */
 
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
Index: linux-2.6/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/kernel/ptrace.c	2008-11-25 01:14:34.000000000 +0530
+++ linux-2.6/kernel/ptrace.c	2008-11-25 01:14:45.000000000 +0530
@@ -612,7 +612,7 @@ int generic_ptrace_pokedata(struct task_
 	return (copied == sizeof(data)) ? 0 : -EIO;
 }
 
-#if defined CONFIG_COMPAT && defined __ARCH_WANT_COMPAT_SYS_PTRACE
+#if defined CONFIG_COMPAT
 #include <linux/compat.h>
 
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
@@ -709,4 +709,4 @@ asmlinkage long compat_sys_ptrace(compat
 	unlock_kernel();
 	return ret;
 }
-#endif	/* CONFIG_COMPAT && __ARCH_WANT_COMPAT_SYS_PTRACE */
+#endif	/* CONFIG_COMPAT */
