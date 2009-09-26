Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZIZTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZIZTuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZIZTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:50:17 -0400
Received: from verein.lst.de ([213.95.11.210]:46123 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZIZTuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:50:15 -0400
Date: Sat, 26 Sep 2009 21:50:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michal Simek <michal.simek@petalogix.com>
Cc: linux-arch@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kill USE_ELF_CORE_DUMP
Message-ID: <20090926195010.GA24592@lst.de>
References: <20090423183331.GA19899@lst.de> <49F16786.7010401@petalogix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F16786.7010401@petalogix.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all architectures but microblaze unconditionally define
USE_ELF_CORE_DUMP.  The microblaze ommision seems like an error to
me, so let's  kill this ifdef and make sure we are the same everywhere.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/alpha/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/elf.h	2009-05-14 13:52:06.869783812 -0300
+++ linux-2.6/arch/alpha/include/asm/elf.h	2009-09-26 13:55:25.485254128 -0300
@@ -81,7 +81,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_ALPHA
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	8192
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/arm/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/elf.h	2009-09-14 23:18:15.473004176 -0300
+++ linux-2.6/arch/arm/include/asm/elf.h	2009-09-26 13:55:25.485254128 -0300
@@ -98,7 +98,6 @@ extern int elf_check_arch(const struct e
 extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define elf_read_implies_exec(ex,stk) arm_elf_read_implies_exec(&(ex), stk)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/avr32/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/elf.h	2009-05-14 13:52:07.559784706 -0300
+++ linux-2.6/arch/avr32/include/asm/elf.h	2009-09-26 13:55:25.486254465 -0300
@@ -77,7 +77,6 @@ typedef struct user_fpu_struct elf_fpreg
 #endif
 #define ELF_ARCH	EM_AVR32
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/blackfin/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/elf.h	2009-09-22 08:44:53.613003791 -0300
+++ linux-2.6/arch/blackfin/include/asm/elf.h	2009-09-26 13:55:25.489299895 -0300
@@ -51,7 +51,6 @@ do {											\
 	_regs->p2	= _dynamic_addr;				\
 } while(0)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_FDPIC_CORE_EFLAGS	EF_BFIN_FDPIC
 #define ELF_EXEC_PAGESIZE	4096
 
Index: linux-2.6/arch/cris/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/elf.h	2009-05-14 13:52:07.734784323 -0300
+++ linux-2.6/arch/cris/include/asm/elf.h	2009-09-26 13:55:25.502254688 -0300
@@ -64,8 +64,6 @@ typedef unsigned long elf_fpregset_t;
 #define EF_CRIS_VARIANT_COMMON_V10_V32	0x00000004
 /* End of excerpt from {binutils}/include/elf/cris.h.  */
 
-#define USE_ELF_CORE_DUMP
-
 #define ELF_EXEC_PAGESIZE	8192
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/frv/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/elf.h	2009-09-02 08:37:28.440714023 -0300
+++ linux-2.6/arch/frv/include/asm/elf.h	2009-09-26 13:55:49.291006245 -0300
@@ -115,7 +115,6 @@ do {											\
 	__kernel_frame0_ptr->gr29	= 0;						\
 } while(0)
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_FDPIC_CORE_EFLAGS	EF_FRV_FDPIC
 #define ELF_EXEC_PAGESIZE	16384
Index: linux-2.6/arch/h8300/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/elf.h	2009-05-14 13:52:07.792784432 -0300
+++ linux-2.6/arch/h8300/include/asm/elf.h	2009-09-26 13:55:25.511254437 -0300
@@ -34,7 +34,6 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLAT_INIT(_r)	_r->er1 = 0
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/ia64/ia32/elfcore32.h
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/elfcore32.h	2009-05-14 13:52:07.815784073 -0300
+++ linux-2.6/arch/ia64/ia32/elfcore32.h	2009-09-26 13:55:25.513299251 -0300
@@ -11,8 +11,6 @@
 #include <asm/intrinsics.h>
 #include <asm/uaccess.h>
 
-#define USE_ELF_CORE_DUMP 1
-
 /* Override elfcore.h */
 #define _LINUX_ELFCORE_H 1
 typedef unsigned int elf_greg_t;
Index: linux-2.6/arch/ia64/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/elf.h	2009-05-14 13:52:07.820784918 -0300
+++ linux-2.6/arch/ia64/include/asm/elf.h	2009-09-26 13:55:25.516299773 -0300
@@ -25,7 +25,6 @@
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_IA_64
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 
 /* Least-significant four bits of ELF header's e_flags are OS-specific.  The bits are
Index: linux-2.6/arch/m32r/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/elf.h	2009-08-16 16:43:58.456455519 -0300
+++ linux-2.6/arch/m32r/include/asm/elf.h	2009-09-26 13:55:25.517254224 -0300
@@ -102,7 +102,6 @@ typedef elf_fpreg_t elf_fpregset_t;
  */
 #define ELF_PLAT_INIT(_r, load_addr)	(_r)->r0 = 0
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
Index: linux-2.6/arch/m68k/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/elf.h	2009-08-16 16:43:58.500457548 -0300
+++ linux-2.6/arch/m68k/include/asm/elf.h	2009-09-26 13:55:25.532254040 -0300
@@ -59,7 +59,6 @@ typedef struct user_m68kfp_struct elf_fp
    is actually used on ASV.  */
 #define ELF_PLAT_INIT(_r, load_addr)	_r->a1 = 0
 
-#define USE_ELF_CORE_DUMP
 #ifndef CONFIG_SUN3
 #define ELF_EXEC_PAGESIZE	4096
 #else
Index: linux-2.6/arch/mips/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/elf.h	2009-09-02 08:37:28.524713385 -0300
+++ linux-2.6/arch/mips/include/asm/elf.h	2009-09-26 13:55:25.533254097 -0300
@@ -326,7 +326,6 @@ extern int dump_task_fpu(struct task_str
 #define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs)			\
 	dump_task_fpu(tsk, elf_fpregs)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /* This yields a mask that user programs can use to figure out what
Index: linux-2.6/arch/mn10300/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/elf.h	2009-09-02 08:37:28.585214085 -0300
+++ linux-2.6/arch/mn10300/include/asm/elf.h	2009-09-26 13:55:33.635270334 -0300
@@ -77,7 +77,6 @@ do {									\
 	_ur->a1   = 0;	_ur->a0   = 0;	_ur->d1   = 0;	_ur->d0   = 0;	\
 } while (0)
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
Index: linux-2.6/arch/parisc/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/elf.h	2009-08-16 16:43:58.756431694 -0300
+++ linux-2.6/arch/parisc/include/asm/elf.h	2009-09-26 13:55:25.538254943 -0300
@@ -328,7 +328,6 @@ struct pt_regs;	/* forward declaration..
    such function.  */
 #define ELF_PLAT_INIT(_r, load_addr)       _r->gr[23] = 0
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/powerpc/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/elf.h	2009-09-02 08:37:28.652714349 -0300
+++ linux-2.6/arch/powerpc/include/asm/elf.h	2009-09-26 13:55:25.542254265 -0300
@@ -170,7 +170,6 @@ typedef elf_fpreg_t elf_vsrreghalf_t32[E
 #define elf_check_arch(x) ((x)->e_machine == ELF_ARCH)
 #define compat_elf_check_arch(x)	((x)->e_machine == EM_PPC)
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
Index: linux-2.6/arch/s390/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/elf.h	2009-05-14 13:52:09.959784152 -0300
+++ linux-2.6/arch/s390/include/asm/elf.h	2009-09-26 13:55:25.544299497 -0300
@@ -143,7 +143,6 @@ extern unsigned int vdso_enabled;
 	} while (0)
 
 #define CORE_DUMP_USE_REGSET
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/sh/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/elf.h	2009-05-14 13:52:10.267785588 -0300
+++ linux-2.6/arch/sh/include/asm/elf.h	2009-09-26 13:55:25.545254228 -0300
@@ -114,7 +114,6 @@ typedef struct user_fpu_struct elf_fpreg
  */
 #define CORE_DUMP_USE_REGSET
 
-#define USE_ELF_CORE_DUMP
 #define ELF_FDPIC_CORE_EFLAGS	EF_SH_FDPIC
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
Index: linux-2.6/arch/sparc/include/asm/elf_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/elf_32.h	2009-05-14 13:52:10.867783983 -0300
+++ linux-2.6/arch/sparc/include/asm/elf_32.h	2009-09-26 13:55:25.548298959 -0300
@@ -104,8 +104,6 @@ typedef struct {
 #define ELF_CLASS	ELFCLASS32
 #define ELF_DATA	ELFDATA2MSB
 
-#define USE_ELF_CORE_DUMP
-
 #define ELF_EXEC_PAGESIZE	4096
 
 
Index: linux-2.6/arch/sparc/include/asm/elf_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/elf_64.h	2009-09-02 08:37:28.824714634 -0300
+++ linux-2.6/arch/sparc/include/asm/elf_64.h	2009-09-26 13:55:25.566256275 -0300
@@ -152,7 +152,6 @@ typedef struct {
 					 (x)->e_machine == EM_SPARC32PLUS)
 #define compat_start_thread		start_thread32
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/um/sys-i386/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/asm/elf.h	2009-05-14 13:52:11.829784951 -0300
+++ linux-2.6/arch/um/sys-i386/asm/elf.h	2009-09-26 13:55:25.570258251 -0300
@@ -48,7 +48,6 @@ typedef struct user_i387_struct elf_fpre
 	PT_REGS_EAX(regs) = 0; \
 } while (0)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE 4096
 
 #define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
Index: linux-2.6/arch/um/sys-ppc/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/um/sys-ppc/asm/elf.h	2009-05-14 13:52:12.158661386 -0300
+++ linux-2.6/arch/um/sys-ppc/asm/elf.h	2009-09-26 13:55:25.572256410 -0300
@@ -17,8 +17,6 @@ extern long elf_aux_hwcap;
 #define ELF_CLASS ELFCLASS32
 #endif
 
-#define USE_ELF_CORE_DUMP
-
 #define R_386_NONE	0
 #define R_386_32	1
 #define R_386_PC32	2
Index: linux-2.6/arch/um/sys-x86_64/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/um/sys-x86_64/asm/elf.h	2009-09-02 08:37:28.852714285 -0300
+++ linux-2.6/arch/um/sys-x86_64/asm/elf.h	2009-09-26 13:55:25.577256489 -0300
@@ -104,7 +104,6 @@ extern int elf_core_copy_fpregs(struct t
         clear_thread_flag(TIF_IA32);
 #endif
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE 4096
 
 #define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
Index: linux-2.6/arch/x86/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/elf.h	2009-09-22 08:44:53.800003672 -0300
+++ linux-2.6/arch/x86/include/asm/elf.h	2009-09-26 13:55:25.582254053 -0300
@@ -255,7 +255,6 @@ extern int force_personality32;
 #endif /* !CONFIG_X86_32 */
 
 #define CORE_DUMP_USE_REGSET
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
Index: linux-2.6/arch/xtensa/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/elf.h	2009-05-14 13:52:12.740784743 -0300
+++ linux-2.6/arch/xtensa/include/asm/elf.h	2009-09-26 13:55:25.584254028 -0300
@@ -123,7 +123,6 @@ extern void xtensa_elf_core_copy_regs (x
 #define ELF_CLASS	ELFCLASS32
 #define ELF_ARCH	EM_XTENSA
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
Index: linux-2.6/fs/binfmt_elf.c
===================================================================
--- linux-2.6.orig/fs/binfmt_elf.c	2009-09-25 16:57:55.995004030 -0300
+++ linux-2.6/fs/binfmt_elf.c	2009-09-26 13:55:25.588253770 -0300
@@ -44,7 +44,7 @@ static unsigned long elf_map(struct file
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
  */
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 #else
 #define elf_core_dump	NULL
@@ -1101,12 +1101,7 @@ out:
 	return error;
 }
 
-/*
- * Note that some platforms still use traditional core dumps and not
- * the ELF core dump.  Each platform can select it as appropriate.
- */
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-
+#ifdef CONFIG_ELF_CORE
 /*
  * ELF core dumper
  *
@@ -2063,7 +2058,7 @@ out:
 	return has_dumped;
 }
 
-#endif		/* USE_ELF_CORE_DUMP */
+#endif		/* CONFIG_ELF_CORE */
 
 static int __init init_elf_binfmt(void)
 {
Index: linux-2.6/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.orig/fs/binfmt_elf_fdpic.c	2009-09-25 16:57:55.995004030 -0300
+++ linux-2.6/fs/binfmt_elf_fdpic.c	2009-09-26 13:55:25.589282322 -0300
@@ -75,14 +75,14 @@ static int elf_fdpic_map_file_constdisp_
 static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *,
 					     struct file *, struct mm_struct *);
 
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_fdpic_binary,
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 	.core_dump	= elf_fdpic_core_dump,
 #endif
 	.min_coredump	= ELF_EXEC_PAGESIZE,
@@ -1200,7 +1200,7 @@ static int elf_fdpic_map_file_by_direct_
  *
  * Modelled on fs/binfmt_elf.c core dumper
  */
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 
 /*
  * These are the only things you should do on a core-file: use only these
@@ -1825,4 +1825,4 @@ cleanup:
 #undef NUM_NOTES
 }
 
-#endif		/* USE_ELF_CORE_DUMP */
+#endif		/* CONFIG_ELF_CORE */
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2009-09-23 21:32:23.665003521 -0300
+++ linux-2.6/fs/proc/base.c	2009-09-26 13:55:25.593019251 -0300
@@ -2200,7 +2200,7 @@ static const struct inode_operations pro
 
 #endif
 
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
 					 size_t count, loff_t *ppos)
 {
@@ -2556,7 +2556,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
Index: linux-2.6/arch/microblaze/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/elf.h	2009-09-26 13:56:14.625022364 -0300
+++ linux-2.6/arch/microblaze/include/asm/elf.h	2009-09-26 13:56:17.173006395 -0300
@@ -77,7 +77,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 #define ELF_DATA	ELFDATA2MSB
 #endif
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 
Index: linux-2.6/arch/score/include/asm/elf.h
===================================================================
--- linux-2.6.orig/arch/score/include/asm/elf.h	2009-09-26 13:56:05.827275754 -0300
+++ linux-2.6/arch/score/include/asm/elf.h	2009-09-26 13:56:09.451015201 -0300
@@ -61,7 +61,6 @@ struct task_struct;
 struct pt_regs;
 
 #define CORE_DUMP_USE_REGSET
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /* This yields a mask that user programs can use to figure out what
