Return-Path: <linux-kernel-owner+w=401wt.eu-S1422634AbXCAX5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422634AbXCAX5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161314AbXCAX5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:57:10 -0500
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:47899 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161283AbXCAX4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:56:50 -0500
Message-Id: <20070301232527.362011844@goop.org>
References: <20070301232443.195603797@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Mar 2007 15:24:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-arch@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [patch 09/26] Xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME, define no-op architecture implementations
Content-Disposition: inline; filename=kill-HAVE_ARCH_MM_LIFETIME.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm:
> Can we lose __HAVE_ARCH_MM_LIFETIME?  Just define these (preferably in C,
> not in cpp) in the appropriate include/asm-foo/ files?

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: linux-arch@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>

---
 include/asm-alpha/mmu_context.h     |    1 +
 include/asm-arm/mmu_context.h       |    1 +
 include/asm-arm26/mmu_context.h     |    2 ++
 include/asm-avr32/mmu_context.h     |    1 +
 include/asm-cris/mmu_context.h      |    2 ++
 include/asm-frv/mmu_context.h       |    1 +
 include/asm-generic/mm_hooks.h      |   18 ++++++++++++++++++
 include/asm-h8300/mmu_context.h     |    1 +
 include/asm-i386/mmu_context.h      |   11 ++++++++++-
 include/asm-i386/paravirt.h         |    5 ++---
 include/asm-ia64/mmu_context.h      |    1 +
 include/asm-m32r/mmu_context.h      |    1 +
 include/asm-m68k/mmu_context.h      |    1 +
 include/asm-m68knommu/mmu_context.h |    1 +
 include/asm-mips/mmu_context.h      |    1 +
 include/asm-parisc/mmu_context.h    |    1 +
 include/asm-powerpc/mmu_context.h   |    1 +
 include/asm-ppc/mmu_context.h       |    1 +
 include/asm-s390/mmu_context.h      |    2 ++
 include/asm-sh/mmu_context.h        |    1 +
 include/asm-sh64/mmu_context.h      |    2 +-
 include/asm-sparc/mmu_context.h     |    2 ++
 include/asm-sparc64/mmu_context.h   |    1 +
 include/asm-um/mmu_context.h        |    2 ++
 include/asm-v850/mmu_context.h      |    2 ++
 include/asm-x86_64/mmu_context.h    |    1 +
 include/asm-xtensa/mmu_context.h    |    1 +
 include/linux/sched.h               |    6 ------
 mm/mmap.c                           |    1 +
 29 files changed, 61 insertions(+), 11 deletions(-)

===================================================================
--- a/include/asm-alpha/mmu_context.h
+++ b/include/asm-alpha/mmu_context.h
@@ -10,6 +10,7 @@
 #include <asm/system.h>
 #include <asm/machvec.h>
 #include <asm/compiler.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Force a context reload. This is needed when we change the page
===================================================================
--- a/include/asm-arm/mmu_context.h
+++ b/include/asm-arm/mmu_context.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <asm/cacheflush.h>
 #include <asm/proc-fns.h>
+#include <asm-generic/mm_hooks.h>
 
 void __check_kvm_seq(struct mm_struct *mm);
 
===================================================================
--- a/include/asm-arm26/mmu_context.h
+++ b/include/asm-arm26/mmu_context.h
@@ -12,6 +12,8 @@
  */
 #ifndef __ASM_ARM_MMU_CONTEXT_H
 #define __ASM_ARM_MMU_CONTEXT_H
+
+#include <asm-generic/mm_hooks.h>
 
 #define init_new_context(tsk,mm)	0
 #define destroy_context(mm)		do { } while(0)
===================================================================
--- a/include/asm-avr32/mmu_context.h
+++ b/include/asm-avr32/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/sysreg.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
===================================================================
--- a/include/asm-cris/mmu_context.h
+++ b/include/asm-cris/mmu_context.h
@@ -1,5 +1,7 @@
 #ifndef __CRIS_MMU_CONTEXT_H
 #define __CRIS_MMU_CONTEXT_H
+
+#include <asm-generic/mm_hooks.h>
 
 extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 extern void get_mmu_context(struct mm_struct *mm);
===================================================================
--- a/include/asm-frv/mmu_context.h
+++ b/include/asm-frv/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- /dev/null
+++ b/include/asm-generic/mm_hooks.h
@@ -0,0 +1,18 @@
+/*
+ * Define generic no-op hooks for arch_dup_mmap and arch_exit_mmap, to
+ * be included in asm-FOO/mmu_context.h for any arch FOO which doesn't
+ * need to hook these.
+ */
+#ifndef _ASM_GENERIC_MM_HOOKS_H
+#define _ASM_GENERIC_MM_HOOKS_H
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
+#endif	/* _ASM_GENERIC_MM_HOOKS_H */
===================================================================
--- a/include/asm-h8300/mmu_context.h
+++ b/include/asm-h8300/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- a/include/asm-i386/mmu_context.h
+++ b/include/asm-i386/mmu_context.h
@@ -6,6 +6,15 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
+#ifndef CONFIG_PARAVIRT
+#include <asm-generic/mm_hooks.h>
+
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif	/* !CONFIG_PARAVIRT */
+
 
 /*
  * Used for LDT copy/destruction.
@@ -68,7 +77,7 @@ static inline void switch_mm(struct mm_s
 
 #define activate_mm(prev, next)				\
 	do {						\
-		arch_activate_mm(prev, next);		\
+		paravirt_activate_mm(prev, next);	\
 		switch_mm((prev),(next),NULL);		\
 	} while(0);
 
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -403,9 +403,8 @@ static inline void startup_ipi_hook(int 
 }
 #endif
 
-#define __HAVE_ARCH_MM_LIFETIME
-static inline void arch_activate_mm(struct mm_struct *prev,
-				    struct mm_struct *next)
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
 {
 	paravirt_ops.activate_mm(prev, next);
 }
===================================================================
--- a/include/asm-ia64/mmu_context.h
+++ b/include/asm-ia64/mmu_context.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/processor.h>
+#include <asm-generic/mm_hooks.h>
 
 struct ia64_ctx {
 	spinlock_t lock;
===================================================================
--- a/include/asm-m32r/mmu_context.h
+++ b/include/asm-m32r/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Cache of MMU context last used.
===================================================================
--- a/include/asm-m68k/mmu_context.h
+++ b/include/asm-m68k/mmu_context.h
@@ -1,6 +1,7 @@
 #ifndef __M68K_MMU_CONTEXT_H
 #define __M68K_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- a/include/asm-m68knommu/mmu_context.h
+++ b/include/asm-m68knommu/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- a/include/asm-mips/mmu_context.h
+++ b/include/asm-mips/mmu_context.h
@@ -20,6 +20,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/smtc.h>
 #endif /* SMTC */
+#include <asm-generic/mm_hooks.h>
 
 /*
  * For the fast tlb miss handlers, we keep a per cpu array of pointers
===================================================================
--- a/include/asm-parisc/mmu_context.h
+++ b/include/asm-parisc/mmu_context.h
@@ -5,6 +5,7 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- a/include/asm-powerpc/mmu_context.h
+++ b/include/asm-powerpc/mmu_context.h
@@ -10,6 +10,7 @@
 #include <linux/mm.h>	
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Copyright (C) 2001 PPC 64 Team, IBM Corp
===================================================================
--- a/include/asm-ppc/mmu_context.h
+++ b/include/asm-ppc/mmu_context.h
@@ -6,6 +6,7 @@
 #include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * On 32-bit PowerPC 6xx/7xx/7xxx CPUs, we use a set of 16 VSIDs
===================================================================
--- a/include/asm-s390/mmu_context.h
+++ b/include/asm-s390/mmu_context.h
@@ -10,6 +10,8 @@
 #define __S390_MMU_CONTEXT_H
 
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
+
 /*
  * get a new mmu context.. S390 don't know about contexts.
  */
===================================================================
--- a/include/asm-sh/mmu_context.h
+++ b/include/asm-sh/mmu_context.h
@@ -12,6 +12,7 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
===================================================================
--- a/include/asm-sh64/mmu_context.h
+++ b/include/asm-sh64/mmu_context.h
@@ -27,7 +27,7 @@ extern unsigned long mmu_context_cache;
 extern unsigned long mmu_context_cache;
 
 #include <asm/page.h>
-
+#include <asm-generic/mm_hooks.h>
 
 /* Current mm's pgd */
 extern pgd_t *mmu_pdtp_cache;
===================================================================
--- a/include/asm-sparc/mmu_context.h
+++ b/include/asm-sparc/mmu_context.h
@@ -4,6 +4,8 @@
 #include <asm/btfixup.h>
 
 #ifndef __ASSEMBLY__
+
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- a/include/asm-sparc64/mmu_context.h
+++ b/include/asm-sparc64/mmu_context.h
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
===================================================================
--- a/include/asm-um/mmu_context.h
+++ b/include/asm-um/mmu_context.h
@@ -5,6 +5,8 @@
 
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
+
+#include <asm-generic/mm_hooks.h>
 
 #include "linux/sched.h"
 #include "choose-mode.h"
===================================================================
--- a/include/asm-v850/mmu_context.h
+++ b/include/asm-v850/mmu_context.h
@@ -1,5 +1,7 @@
 #ifndef __V850_MMU_CONTEXT_H__
 #define __V850_MMU_CONTEXT_H__
+
+#include <asm-generic/mm_hooks.h>
 
 #define destroy_context(mm)		((void)0)
 #define init_new_context(tsk,mm)	0
===================================================================
--- a/include/asm-x86_64/mmu_context.h
+++ b/include/asm-x86_64/mmu_context.h
@@ -7,6 +7,7 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * possibly do the LDT unload here?
===================================================================
--- a/include/asm-xtensa/mmu_context.h
+++ b/include/asm-xtensa/mmu_context.h
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 #define XCHAL_MMU_ASID_BITS	8
 
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -374,12 +374,6 @@ struct mm_struct {
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
 };
-
-#ifndef __HAVE_ARCH_MM_LIFETIME
-#define arch_activate_mm(prev, next)	do {} while(0)
-#define arch_dup_mmap(oldmm, mm)	do {} while(0)
-#define arch_exit_mmap(mm)		do {} while(0)
-#endif
 
 struct sighand_struct {
 	atomic_t		count;
===================================================================
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
+#include <asm/mmu_context.h>
 
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)

-- 

