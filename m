Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbYCWIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbYCWIzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbYCWILs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:48 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2343 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759133AbYCWILm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:42 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 033/148] include/asm-x86/elf.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:08 -0700
Message-Id: <1206259443-13210-34-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/elf.h |  102 +++++++++++++++++++++++++++----------------------
 1 files changed, 56 insertions(+), 46 deletions(-)

diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index 7732564..37b1492 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -11,7 +11,7 @@
 
 typedef unsigned long elf_greg_t;
 
-#define ELF_NGREG (sizeof (struct user_regs_struct) / sizeof(elf_greg_t))
+#define ELF_NGREG (sizeof(struct user_regs_struct) / sizeof(elf_greg_t))
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
 typedef struct user_i387_struct elf_fpregset_t;
@@ -100,10 +100,11 @@ extern unsigned int vdso_enabled;
    We might as well make sure everything else is cleared too (except for %esp),
    just to make things more deterministic.
  */
-#define ELF_PLAT_INIT(_r, load_addr)	do { \
-	_r->bx = 0; _r->cx = 0; _r->dx = 0; \
-	_r->si = 0; _r->di = 0; _r->bp = 0; \
-	_r->ax = 0; \
+#define ELF_PLAT_INIT(_r, load_addr)		\
+	do {					\
+	_r->bx = 0; _r->cx = 0; _r->dx = 0;	\
+	_r->si = 0; _r->di = 0; _r->bp = 0;	\
+	_r->ax = 0;				\
 } while (0)
 
 /*
@@ -111,24 +112,25 @@ extern unsigned int vdso_enabled;
  * now struct_user_regs, they are different)
  */
 
-#define ELF_CORE_COPY_REGS(pr_reg, regs) do {		\
-	pr_reg[0] = regs->bx;				\
-	pr_reg[1] = regs->cx;				\
-	pr_reg[2] = regs->dx;				\
-	pr_reg[3] = regs->si;				\
-	pr_reg[4] = regs->di;				\
-	pr_reg[5] = regs->bp;				\
-	pr_reg[6] = regs->ax;				\
-	pr_reg[7] = regs->ds & 0xffff;			\
-	pr_reg[8] = regs->es & 0xffff;			\
-	pr_reg[9] = regs->fs & 0xffff;			\
-	savesegment(gs, pr_reg[10]);			\
-	pr_reg[11] = regs->orig_ax;			\
-	pr_reg[12] = regs->ip;				\
-	pr_reg[13] = regs->cs & 0xffff;			\
-	pr_reg[14] = regs->flags;			\
-	pr_reg[15] = regs->sp;				\
-	pr_reg[16] = regs->ss & 0xffff;			\
+#define ELF_CORE_COPY_REGS(pr_reg, regs)	\
+do {						\
+	pr_reg[0] = regs->bx;			\
+	pr_reg[1] = regs->cx;			\
+	pr_reg[2] = regs->dx;			\
+	pr_reg[3] = regs->si;			\
+	pr_reg[4] = regs->di;			\
+	pr_reg[5] = regs->bp;			\
+	pr_reg[6] = regs->ax;			\
+	pr_reg[7] = regs->ds & 0xffff;		\
+	pr_reg[8] = regs->es & 0xffff;		\
+	pr_reg[9] = regs->fs & 0xffff;		\
+	savesegment(gs, pr_reg[10]);		\
+	pr_reg[11] = regs->orig_ax;		\
+	pr_reg[12] = regs->ip;			\
+	pr_reg[13] = regs->cs & 0xffff;		\
+	pr_reg[14] = regs->flags;		\
+	pr_reg[15] = regs->sp;			\
+	pr_reg[16] = regs->ss & 0xffff;		\
 } while (0);
 
 #define ELF_PLATFORM	(utsname()->machine)
@@ -139,7 +141,7 @@ extern unsigned int vdso_enabled;
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
-#define elf_check_arch(x) \
+#define elf_check_arch(x)			\
 	((x)->e_machine == EM_X86_64)
 
 #define compat_elf_check_arch(x)	elf_check_arch_ia32(x)
@@ -168,24 +170,27 @@ static inline void elf_common_init(struct thread_struct *t,
 	t->ds = t->es = ds;
 }
 
-#define ELF_PLAT_INIT(_r, load_addr)	do {		  \
-	elf_common_init(&current->thread, _r, 0);	  \
-	clear_thread_flag(TIF_IA32);			  \
+#define ELF_PLAT_INIT(_r, load_addr)			\
+do {							\
+	elf_common_init(&current->thread, _r, 0);	\
+	clear_thread_flag(TIF_IA32);			\
 } while (0)
 
 #define	COMPAT_ELF_PLAT_INIT(regs, load_addr)	\
 	elf_common_init(&current->thread, regs, __USER_DS)
-#define	compat_start_thread(regs, ip, sp)	do {		\
-		start_ia32_thread(regs, ip, sp);		\
-		set_fs(USER_DS);				\
-	} while (0)
-#define COMPAT_SET_PERSONALITY(ex, ibcs2)	do {		\
-		if (test_thread_flag(TIF_IA32))			\
-			clear_thread_flag(TIF_ABI_PENDING);	\
-		else						\
-			set_thread_flag(TIF_ABI_PENDING);	\
-		current->personality |= force_personality32;	\
-	} while (0)
+#define	compat_start_thread(regs, ip, sp)
+do {							\
+	start_ia32_thread(regs, ip, sp);		\
+	set_fs(USER_DS);				\
+} while (0)
+#define COMPAT_SET_PERSONALITY(ex, ibcs2)		\
+do {							\
+	if (test_thread_flag(TIF_IA32))			\
+		clear_thread_flag(TIF_ABI_PENDING);	\
+	else						\
+		set_thread_flag(TIF_ABI_PENDING);	\
+	current->personality |= force_personality32;	\
+} while (0)
 #define COMPAT_ELF_PLATFORM			("i686")
 
 /*
@@ -194,7 +199,8 @@ static inline void elf_common_init(struct thread_struct *t,
  * getting dumped.
  */
 
-#define ELF_CORE_COPY_REGS(pr_reg, regs)  do {			\
+#define ELF_CORE_COPY_REGS(pr_reg, regs)			\
+do {								\
 	unsigned v;						\
 	(pr_reg)[0] = (regs)->r15;				\
 	(pr_reg)[1] = (regs)->r14;				\
@@ -268,10 +274,12 @@ extern int force_personality32;
 
 struct task_struct;
 
-#define	ARCH_DLINFO_IA32(vdso_enabled) \
-do if (vdso_enabled) {							\
+#define	ARCH_DLINFO_IA32(vdso_enabled)					\
+do {									\
+	if (vdso_enabled) {						\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
+	}								\
 } while (0)
 
 #ifdef CONFIG_X86_32
@@ -289,9 +297,11 @@ do if (vdso_enabled) {							\
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
 
-#define ARCH_DLINFO						\
-do if (vdso_enabled) {						\
-	NEW_AUX_ENT(AT_SYSINFO_EHDR,(unsigned long)current->mm->context.vdso);\
+#define ARCH_DLINFO							\
+do {									\
+	if (vdso_enabled)						\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
+			    (unsigned long)current->mm->context.vdso);	\
 } while (0)
 
 #define AT_SYSINFO		32
@@ -304,8 +314,8 @@ do if (vdso_enabled) {						\
 
 #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
 
-#define VDSO_ENTRY \
-	((unsigned long) VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
+#define VDSO_ENTRY							\
+	((unsigned long)VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
 
 struct linux_binprm;
 
-- 
1.5.4.rc2

