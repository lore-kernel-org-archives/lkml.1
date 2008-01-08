Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYAHTc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYAHTc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYAHTcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:32:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:40488 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbYAHTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=IHOghiUsOz107kD+4aiU1sGrdMRmGTiKYsS2HLrWUT5Mts1kHAIapawR1PgzBqs0cEAViGcV9WfhfHMqKIVG+a3apiyvlELFxWwWtIMMPlXclbLSfuFnqcLQWQfOAyBoJY8+tePdSy3TxOT9ACiKrp3lGajOj1zA/jzrM5rWwZ0=
Date: Tue, 8 Jan 2008 20:32:42 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH 4/5] x86: coding style fixes in arch/x86/ia32/ia32_binfmt.c
Message-ID: <20080108203242.5e033d97@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 39 Codying Style errors reported by checkpatch

It now reports:
total: 2 errors, 5 warnings, 285 lines checked

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/ia32_binfmt.c |   70 +++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/x86/ia32/ia32_binfmt.c b/arch/x86/ia32/ia32_binfmt.c
index 55822d2..137d14e 100644
--- a/arch/x86/ia32/ia32_binfmt.c
+++ b/arch/x86/ia32/ia32_binfmt.c
@@ -1,10 +1,10 @@
-/* 
- * Written 2000,2002 by Andi Kleen. 
- * 
+/*
+ * Written 2000,2002 by Andi Kleen.
+ *
  * Loosely based on the sparc64 and IA64 32bit emulation loaders.
- * This tricks binfmt_elf.c into loading 32bit binaries using lots 
+ * This tricks binfmt_elf.c into loading 32bit binaries using lots
  * of ugly preprocessor tricks. Talk about very very poor man's inheritance.
- */ 
+ */
 
 #include <linux/types.h>
 #include <linux/stddef.h>
@@ -17,7 +17,7 @@
 #include <linux/security.h>
 #include <linux/elfcore-compat.h>
 
-#include <asm/segment.h> 
+#include <asm/segment.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/user32.h>
@@ -56,7 +56,7 @@ int sysctl_vsyscall32 = 1;
 		NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VSYSCALL32_BASE);    \
 	}	\
-} while(0)
+} while (0)
 
 struct file;
 
@@ -66,7 +66,7 @@ struct file;
 
 #define ELF_ET_DYN_BASE		(TASK_UNMAPPED_BASE + 0x1000000)
 
-#define jiffies_to_timeval(a,b) do { (b)->tv_usec = 0; (b)->tv_sec = (a)/HZ; }while(0)
+#define jiffies_to_timeval(a, b) do { (b)->tv_usec = 0; (b)->tv_sec = (a)/HZ; } while (0)
 
 #define _GET_SEG(x) \
 	({ __u32 seg; asm("movl %%" __stringify(x) ",%0" : "=r"(seg)); seg; })
@@ -112,23 +112,23 @@ static inline void elf32_core_copy_regs(compat_elf_gregset_t *elfregs,
 #define elf_core_copy_task_regs		elf32_core_copy_task_regs
 static inline int elf32_core_copy_task_regs(struct task_struct *t,
 					    compat_elf_gregset_t* elfregs)
-{	
+{
 	struct pt_regs *pp = task_pt_regs(t);
 	ELF_CORE_COPY_REGS((&elfregs->ebx), pp);
-	/* fix wrong segments */ 
+	/* fix wrong segments */
 	elfregs->ds = t->thread.ds;
 	elfregs->fs = t->thread.fsindex;
 	elfregs->gs = t->thread.gsindex;
 	elfregs->es = t->thread.es;
-	return 1; 
+	return 1;
 }
 
 #define elf_core_copy_task_fpregs	elf32_core_copy_task_fpregs
-static inline int 
+static inline int
 elf32_core_copy_task_fpregs(struct task_struct *tsk, struct pt_regs *regs,
 			    elf_fpregset_t *fpu)
 {
-	struct _fpstate_ia32 *fpstate = (void*)fpu; 
+	struct _fpstate_ia32 *fpstate = (void *)fpu;
 	mm_segment_t oldfs = get_fs();
 
 	if (!tsk_used_math(tsk))
@@ -137,29 +137,29 @@ elf32_core_copy_task_fpregs(struct task_struct *tsk, struct pt_regs *regs,
 		regs = task_pt_regs(tsk);
 	if (tsk == current)
 		unlazy_fpu(tsk);
-	set_fs(KERNEL_DS); 
+	set_fs(KERNEL_DS);
 	save_i387_ia32(tsk, fpstate, regs, 1);
-	/* Correct for i386 bug. It puts the fop into the upper 16bits of 
-	   the tag word (like FXSAVE), not into the fcs*/ 
-	fpstate->cssel |= fpstate->tag & 0xffff0000; 
-	set_fs(oldfs); 
-	return 1; 
+	/* Correct for i386 bug. It puts the fop into the upper 16bits of
+	   the tag word (like FXSAVE), not into the fcs*/
+	fpstate->cssel |= fpstate->tag & 0xffff0000;
+	set_fs(oldfs);
+	return 1;
 }
 
 #define ELF_CORE_COPY_XFPREGS 1
 #define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
 #define elf_core_copy_task_xfpregs	elf32_core_copy_task_xfpregs
-static inline int 
+static inline int
 elf32_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregset_t *xfpu)
 {
 	struct pt_regs *regs = task_pt_regs(t);
 	if (!tsk_used_math(t))
 		return 0;
 	if (t == current)
-		unlazy_fpu(t); 
+		unlazy_fpu(t);
 	memcpy(xfpu, &t->thread.i387.fxsave, sizeof(elf_fpxregset_t));
-	xfpu->fcs = regs->cs; 
-	xfpu->fos = t->thread.ds; /* right? */ 
+	xfpu->fcs = regs->cs;
+	xfpu->fos = t->thread.ds; /* right? */
 	return 1;
 }
 
@@ -202,7 +202,7 @@ do {							\
 #define ELF_PLAT_INIT(r, load_addr)	elf32_init(r)
 
 #undef start_thread
-#define start_thread(regs,new_rip,new_rsp) do { \
+#define start_thread(regs, new_rip,new_rsp) do { \
 	asm volatile("movl %0,%%fs" :: "r" (0)); \
 	asm volatile("movl %0,%%es; movl %0,%%ds": :"r" (__USER32_DS)); \
 	load_gs_index(0); \
@@ -212,12 +212,12 @@ do {							\
 	(regs)->cs = __USER32_CS; \
 	(regs)->ss = __USER32_DS; \
 	set_fs(USER_DS); \
-} while(0) 
+} while (0)
 
 
 #include <linux/module.h>
 
-MODULE_DESCRIPTION("Binary format loader for compatibility with IA32 ELF binaries."); 
+MODULE_DESCRIPTION("Binary format loader for compatibility with IA32 ELF binaries.");
 MODULE_AUTHOR("Eric Youngdale, Andi Kleen");
 
 #undef MODULE_DESCRIPTION
@@ -229,25 +229,25 @@ static void elf32_init(struct pt_regs *);
 #define arch_setup_additional_pages syscall32_setup_pages
 extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
 
-#include "../../../fs/binfmt_elf.c" 
+#include "../../../fs/binfmt_elf.c"
 
 static void elf32_init(struct pt_regs *regs)
 {
-	struct task_struct *me = current; 
+	struct task_struct *me = current;
 	regs->rdi = 0;
 	regs->rsi = 0;
 	regs->rdx = 0;
 	regs->rcx = 0;
 	regs->rax = 0;
-	regs->rbx = 0; 
-	regs->rbp = 0; 
+	regs->rbx = 0;
+	regs->rbp = 0;
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
-		regs->r13 = regs->r14 = regs->r15 = 0; 
-    me->thread.fs = 0; 
+		regs->r13 = regs->r14 = regs->r15 = 0;
+    me->thread.fs = 0;
 	me->thread.gs = 0;
-	me->thread.fsindex = 0; 
+	me->thread.fsindex = 0;
 	me->thread.gsindex = 0;
-    me->thread.ds = __USER_DS; 
+    me->thread.ds = __USER_DS;
 	me->thread.es = __USER_DS;
 }
 
@@ -277,7 +277,7 @@ static ctl_table abi_root_table2[] = {
 };
 
 static __init int ia32_binfmt_init(void)
-{ 
+{
 	register_sysctl_table(abi_root_table2);
 	return 0;
 }
-- 
1.5.4.rc2.17.g257f

