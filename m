Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0BBTBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:01:39 -0500
Received: from verein.lst.de ([213.95.11.210]:38043 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0BBTA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:26 -0500
Date: Tue, 2 Feb 2010 19:57:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       mattst88@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net,
       linux@arm.linux.org.uk, hskinnemoen@atmel.com, vapier@gentoo.org,
       starvik@axis.com, jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, gerg@uclinux.org, monstr@monstr.eu,
       ralf@linux-mips.org, jdike@addtoit.com, chris@zankel.net
Subject: [PATCH 1/14] move user_enable_single_step & co prototypes to linux/ptrace.h
Message-ID: <20100202185755.GA3630@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While in theory user_enable_single_step/user_disable_single_step/
user_enable_blockstep could also be provided as an inline or macro there's no
good reason to do so, and having the prototype in one places keeps code size
and confusion down.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/frv/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/ptrace.h	2010-02-02 10:16:57.091253546 +0100
+++ linux-2.6/arch/frv/include/asm/ptrace.h	2010-02-02 10:17:30.928005548 +0100
@@ -84,8 +84,6 @@ extern void show_regs(struct pt_regs *);
 #define task_pt_regs(task) ((task)->thread.frame0)
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
Index: linux-2.6/arch/ia64/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/ptrace.h	2010-02-02 10:16:57.123254478 +0100
+++ linux-2.6/arch/ia64/include/asm/ptrace.h	2010-02-02 10:20:34.530006509 +0100
@@ -319,11 +319,7 @@ static inline unsigned long user_stack_p
 	ptrace_attach_sync_user_rbs(child)
 
   #define arch_has_single_step()  (1)
-  extern void user_enable_single_step(struct task_struct *);
-  extern void user_disable_single_step(struct task_struct *);
-
   #define arch_has_block_step()   (1)
-  extern void user_enable_block_step(struct task_struct *);
 
 #endif /* !__KERNEL__ */
 
Index: linux-2.6/arch/m68k/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/ptrace.h	2010-02-02 10:16:57.149003358 +0100
+++ linux-2.6/arch/m68k/include/asm/ptrace.h	2010-02-02 10:20:48.940276470 +0100
@@ -85,18 +85,10 @@ struct switch_stack {
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
-/*
- * These are defined as per linux/ptrace.h.
- */
-struct task_struct;
-
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #ifdef CONFIG_MMU
 #define arch_has_block_step()	(1)
-extern void user_enable_block_step(struct task_struct *);
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6/arch/mn10300/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/ptrace.h	2010-02-02 10:16:57.189253666 +0100
+++ linux-2.6/arch/mn10300/include/asm/ptrace.h	2010-02-02 10:18:18.940285108 +0100
@@ -99,8 +99,6 @@ struct task_struct;
 extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #endif  /*  !__ASSEMBLY  */
 
Index: linux-2.6/arch/parisc/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/ptrace.h	2010-02-02 10:16:57.203254052 +0100
+++ linux-2.6/arch/parisc/include/asm/ptrace.h	2010-02-02 10:20:58.226288061 +0100
@@ -47,13 +47,8 @@ struct pt_regs {
 
 #define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
 
-struct task_struct;
 #define arch_has_single_step()	1
-void user_disable_single_step(struct task_struct *task);
-void user_enable_single_step(struct task_struct *task);
-
 #define arch_has_block_step()	1
-void user_enable_block_step(struct task_struct *task);
 
 /* XXX should we use iaoq[1] or iaoq[0] ? */
 #define user_mode(regs)			(((regs)->iaoq[0] & 3) ? 1 : 0)
Index: linux-2.6/arch/powerpc/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/ptrace.h	2010-02-02 10:16:57.215254253 +0100
+++ linux-2.6/arch/powerpc/include/asm/ptrace.h	2010-02-02 10:21:09.750035376 +0100
@@ -131,15 +131,8 @@ do {									      \
 } while (0)
 #endif /* __powerpc64__ */
 
-/*
- * These are defined as per linux/ptrace.h, which see.
- */
 #define arch_has_single_step()	(1)
 #define arch_has_block_step()	(!cpu_has_feature(CPU_FTR_601))
-extern void user_enable_single_step(struct task_struct *);
-extern void user_enable_block_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
-
 #define ARCH_HAS_USER_SINGLE_STEP_INFO
 
 #endif /* __ASSEMBLY__ */
Index: linux-2.6/arch/s390/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/ptrace.h	2010-02-02 10:16:57.228253185 +0100
+++ linux-2.6/arch/s390/include/asm/ptrace.h	2010-02-02 10:18:36.397283176 +0100
@@ -489,10 +489,6 @@ struct user_regs_struct
  * These are defined as per linux/ptrace.h, which see.
  */
 #define arch_has_single_step()	(1)
-struct task_struct;
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
-
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define user_stack_pointer(regs)((regs)->gprs[15])
Index: linux-2.6/arch/score/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/score/include/asm/ptrace.h	2010-02-02 10:16:57.242254270 +0100
+++ linux-2.6/arch/score/include/asm/ptrace.h	2010-02-02 10:18:48.080256587 +0100
@@ -90,8 +90,7 @@ extern int read_tsk_short(struct task_st
 			 unsigned short *);
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_SCORE_PTRACE_H */
Index: linux-2.6/arch/sh/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/ptrace.h	2010-02-02 10:16:57.255253691 +0100
+++ linux-2.6/arch/sh/include/asm/ptrace.h	2010-02-02 10:18:50.879041468 +0100
@@ -121,8 +121,6 @@ extern void show_regs(struct pt_regs *);
 struct task_struct;
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #define task_pt_regs(task) \
 	((struct pt_regs *) (task_stack_page(task) + THREAD_SIZE) - 1)
Index: linux-2.6/arch/x86/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ptrace.h	2010-02-02 10:16:57.309003832 +0100
+++ linux-2.6/arch/x86/include/asm/ptrace.h	2010-02-02 10:21:19.621005835 +0100
@@ -278,14 +278,7 @@ static inline unsigned long regs_get_ker
 extern unsigned long regs_get_argument_nth(struct pt_regs *regs,
 					   unsigned int n);
 
-/*
- * These are defined as per linux/ptrace.h, which see.
- */
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
-
-extern void user_enable_block_step(struct task_struct *);
 #ifdef CONFIG_X86_DEBUGCTLMSR
 #define arch_has_block_step()	(1)
 #else
Index: linux-2.6/include/linux/ptrace.h
===================================================================
--- linux-2.6.orig/include/linux/ptrace.h	2010-02-02 10:16:57.003003620 +0100
+++ linux-2.6/include/linux/ptrace.h	2010-02-02 10:21:46.925266509 +0100
@@ -238,6 +238,9 @@ static inline void user_enable_single_st
 static inline void user_disable_single_step(struct task_struct *task)
 {
 }
+#else
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
 #endif	/* arch_has_single_step */
 
 #ifndef arch_has_block_step
@@ -265,6 +268,8 @@ static inline void user_enable_block_ste
 {
 	BUG();			/* This can never be called.  */
 }
+#else
+extern void user_enable_block_step(struct task_struct *);
 #endif	/* arch_has_block_step */
 
 #ifdef ARCH_HAS_USER_SINGLE_STEP_INFO
