Return-Path: <linux-kernel-owner+w=401wt.eu-S1763315AbXGNU5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315AbXGNU5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762873AbXGNU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:56:54 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37389 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbXGNU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:56:53 -0400
Date: Sat, 14 Jul 2007 22:57:09 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] remove PAGE_SIZE from headers_install
Message-ID: <20070714205709.GA9478@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Declare PAGE_SIZE as getpagesize() for userspace.
PAGE_SIZE is used in resource.h and shm.h

define PAGE_SIZE in asm-generic/page.h
guard get_order() with _ARCH_HAS_GET_ORDER for ia64 and xtensa
include asm-generic/page.h in asm/page.h
make asm/page.h nearly empty by moving the #ifdef guards up
remove unneeded page.h export from frv


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/asm-alpha/page.h     |    3 ++-
 include/asm-arm/page.h       |    4 ++--
 include/asm-arm26/page.h     |    2 --
 include/asm-avr32/page.h     |    2 ++
 include/asm-blackfin/page.h  |    6 +++---
 include/asm-cris/page.h      |    3 ++-
 include/asm-frv/Kbuild       |    1 -
 include/asm-frv/page.h       |    3 ++-
 include/asm-generic/Kbuild   |    1 +
 include/asm-generic/page.h   |    6 ++++++
 include/asm-h8300/page.h     |    3 ++-
 include/asm-i386/page.h      |    5 +++--
 include/asm-ia64/page.h      |    6 +++++-
 include/asm-m32r/page.h      |    6 ++++--
 include/asm-m68k/page.h      |    4 ++--
 include/asm-m68knommu/page.h |    4 ++--
 include/asm-mips/page.h      |    3 ++-
 include/asm-parisc/page.h    |    3 ++-
 include/asm-powerpc/page.h   |    4 +++-
 include/asm-ppc/page.h       |    2 +-
 include/asm-s390/page.h      |   10 +++++-----
 include/asm-sh/page.h        |    8 +++++---
 include/asm-sh64/page.h      |    7 ++++---
 include/asm-sparc/page.h     |   13 +++++++------
 include/asm-sparc64/page.h   |    3 ++-
 include/asm-v850/page.h      |   13 +++++++------
 include/asm-x86_64/page.h    |    5 +++--
 include/asm-xtensa/page.h    |   15 +++++++++------
 28 files changed, 88 insertions(+), 57 deletions(-)

--- a/include/asm-alpha/page.h
+++ b/include/asm-alpha/page.h
@@ -94,7 +94,8 @@ typedef unsigned long pgprot_t;
 					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
+#endif /* __KERNEL__ */
+
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
 #endif /* _ALPHA_PAGE_H */
--- a/include/asm-arm/page.h
+++ b/include/asm-arm/page.h
@@ -190,8 +190,8 @@ typedef unsigned long pgprot_t;
 #define ARCH_SLAB_MINALIGN 8
 #endif
 
-#include <asm-generic/page.h>
-
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif
--- a/include/asm-arm26/page.h
+++ b/include/asm-arm26/page.h
@@ -68,7 +68,6 @@ typedef unsigned long pgprot_t;
 
 #endif /* STRICT_MM_TYPECHECKS */
 #endif /* !__ASSEMBLY__ */
-#endif /* __KERNEL__ */
 
 /* PAGE_SHIFT determines the page size.  This is configurable. */
 #if defined(CONFIG_PAGESIZE_16)
@@ -85,7 +84,6 @@ typedef unsigned long pgprot_t;
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <asm/memory.h>
--- a/include/asm-avr32/page.h
+++ b/include/asm-avr32/page.h
@@ -109,4 +109,6 @@ static inline int get_order(unsigned lon
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* __ASM_AVR32_PAGE_H */
--- a/include/asm-blackfin/page.h
+++ b/include/asm-blackfin/page.h
@@ -1,5 +1,6 @@
 #ifndef _BLACKFIN_PAGE_H
 #define _BLACKFIN_PAGE_H
+#ifdef __KERNEL__
 
 /* PAGE_SHIFT determines the page size */
 
@@ -11,7 +12,6 @@
 #endif
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#ifdef __KERNEL__
 
 #include <asm/setup.h>
 
@@ -85,9 +85,9 @@ extern unsigned long memory_end;
 #define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
 				((void *)(kaddr) < (void *)memory_end))
 
-#include <asm-generic/page.h>
-
 #endif				/* __ASSEMBLY__ */
 #endif				/* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif				/* _BLACKFIN_PAGE_H */
--- a/include/asm-cris/page.h
+++ b/include/asm-cris/page.h
@@ -74,9 +74,10 @@ typedef struct { unsigned long pgprot; }
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _CRIS_PAGE_H */
 
--- a/include/asm-frv/Kbuild
+++ b/include/asm-frv/Kbuild
@@ -4,4 +4,3 @@ header-y += registers.h
 
 unifdef-y += termios.h
 unifdef-y += ptrace.h
-unifdef-y += page.h
--- a/include/asm-frv/page.h
+++ b/include/asm-frv/page.h
@@ -81,8 +81,9 @@ extern unsigned long max_pfn;
 #endif
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _ASM_PAGE_H */
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -8,5 +8,6 @@ header-y += poll.h
 header-y += signal.h
 header-y += statfs.h
 
+unifdef-y += page.h
 unifdef-y += resource.h
 unifdef-y += siginfo.h
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#ifndef _ARCH_HAS_GET_ORDER
 /* Pure 2^n version of get_order */
 static __inline__ __attribute_const__ int get_order(unsigned long size)
 {
@@ -19,8 +20,13 @@ static __inline__ __attribute_const__ in
 	} while (size);
 	return order;
 }
+#endif
 
 #endif	/* __ASSEMBLY__ */
+#else
+
+#define PAGE_SIZE (getpagesize())
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _ASM_GENERIC_PAGE_H */
--- a/include/asm-h8300/page.h
+++ b/include/asm-h8300/page.h
@@ -76,8 +76,9 @@ extern unsigned long memory_end;
 #endif /* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _H8300_PAGE_H */
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -1,6 +1,7 @@
 #ifndef _I386_PAGE_H
 #define _I386_PAGE_H
 
+#ifdef __KERNEL__
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
@@ -9,7 +10,6 @@
 #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
 #define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_X86_USE_3DNOW
@@ -198,9 +198,10 @@ extern int page_is_ram(unsigned long pag
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _I386_PAGE_H */
--- a/include/asm-ia64/page.h
+++ b/include/asm-ia64/page.h
@@ -1,5 +1,6 @@
 #ifndef _ASM_IA64_PAGE_H
 #define _ASM_IA64_PAGE_H
+# ifdef __KERNEL__
 /*
  * Pagetable related stuff.
  *
@@ -7,7 +8,6 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-# ifdef __KERNEL__
 
 #include <asm/intrinsics.h>
 #include <asm/types.h>
@@ -160,6 +160,7 @@ typedef union ia64_va {
 extern unsigned int hpage_shift;
 #endif
 
+#define _ARCH_HAS_GET_ORDER 1
 static __inline__ int
 get_order (unsigned long size)
 {
@@ -227,4 +228,7 @@ get_order (unsigned long size)
 					  ? VM_EXEC : 0))
 
 # endif /* __KERNEL__ */
+
+#include <asm-generic/page.h>
+
 #endif /* _ASM_IA64_PAGE_H */
--- a/include/asm-m32r/page.h
+++ b/include/asm-m32r/page.h
@@ -1,12 +1,12 @@
 #ifndef _ASM_M32R_PAGE_H
 #define _ASM_M32R_PAGE_H
+#ifdef __KERNEL__
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 extern void clear_page(void *to);
@@ -84,7 +84,9 @@ typedef struct { unsigned long pgprot; }
 #define devmem_is_allowed(x) 1
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
+
+#include <asm-generic/page.h>
+
 #endif /* _ASM_M32R_PAGE_H */
--- a/include/asm-m68k/page.h
+++ b/include/asm-m68k/page.h
@@ -228,8 +228,8 @@ static inline __attribute_const__ int __
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
-#include <asm-generic/page.h>
-
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _M68K_PAGE_H */
--- a/include/asm-m68knommu/page.h
+++ b/include/asm-m68knommu/page.h
@@ -75,8 +75,8 @@ extern unsigned long memory_end;
 
 #endif /* __ASSEMBLY__ */
 
-#include <asm-generic/page.h>
-
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _M68KNOMMU_PAGE_H */
--- a/include/asm-mips/page.h
+++ b/include/asm-mips/page.h
@@ -188,8 +188,9 @@ typedef struct { unsigned long pgprot; }
 #define CAC_ADDR(addr)		((addr) - UNCAC_BASE + PAGE_OFFSET)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* defined (__KERNEL__) */
 
+#include <asm-generic/page.h>
+
 #endif /* _ASM_PAGE_H */
--- a/include/asm-parisc/page.h
+++ b/include/asm-parisc/page.h
@@ -171,8 +171,9 @@ extern int npmem_ranges;
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _PARISC_PAGE_H */
--- a/include/asm-powerpc/page.h
+++ b/include/asm-powerpc/page.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_POWERPC_PAGE_H
 #define _ASM_POWERPC_PAGE_H
 
+#ifdef __KERNEL__
 /*
  * Copyright (C) 2001,2005 IBM Corporation.
  *
@@ -10,7 +11,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifdef __KERNEL__
 #include <asm/asm-compat.h>
 #include <asm/kdump.h>
 
@@ -197,4 +197,6 @@ extern const char *arch_vma_name(struct 
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _ASM_POWERPC_PAGE_H */
--- a/include/asm-ppc/page.h
+++ b/include/asm-ppc/page.h
@@ -1,5 +1,6 @@
 #ifndef _PPC_PAGE_H
 #define _PPC_PAGE_H
+#ifdef __KERNEL__
 
 #include <asm/asm-compat.h>
 
@@ -13,7 +14,6 @@
  */
 #define PAGE_MASK	(~((1 << PAGE_SHIFT) - 1))
 
-#ifdef __KERNEL__
 
 /* This must match what is in arch/ppc/Makefile */
 #define PAGE_OFFSET	CONFIG_KERNEL_START
--- a/include/asm-s390/page.h
+++ b/include/asm-s390/page.h
@@ -1,3 +1,6 @@
+#ifndef _S390_PAGE_H
+#define _S390_PAGE_H
+#ifdef __KERNEL__
 /*
  *  include/asm-s390/page.h
  *
@@ -6,9 +9,6 @@
  *    Author(s): Hartmut Penner (hp@de.ibm.com)
  */
 
-#ifndef _S390_PAGE_H
-#define _S390_PAGE_H
-
 #include <asm/types.h>
 
 /* PAGE_SHIFT determines the page size */
@@ -18,7 +18,6 @@
 #define PAGE_DEFAULT_ACC	0
 #define PAGE_DEFAULT_KEY	(PAGE_DEFAULT_ACC << 4)
 
-#ifdef __KERNEL__
 #include <asm/setup.h>
 #ifndef __ASSEMBLY__
 
@@ -164,8 +163,9 @@ static inline int pfn_valid(unsigned lon
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _S390_PAGE_H */
--- a/include/asm-sh/page.h
+++ b/include/asm-sh/page.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_PAGE_H
 #define __ASM_SH_PAGE_H
 
+#ifdef __KERNEL__
+
 /*
  * Copyright (C) 1999  Niibe Yutaka
  */
@@ -13,8 +15,6 @@
    [ P4 control   ]		0xE0000000
  */
 
-#ifdef __KERNEL__
-
 /* PAGE_SHIFT determines the page size */
 #if defined(CONFIG_PAGE_SIZE_4KB)
 # define PAGE_SHIFT	12
@@ -141,7 +141,6 @@ typedef struct { unsigned long pgd; } pg
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 /* vDSO support */
 #ifdef CONFIG_VSYSCALL
@@ -149,4 +148,7 @@ typedef struct { unsigned long pgd; } pg
 #endif
 
 #endif /* __KERNEL__ */
+
+#include <asm-generic/page.h>
+
 #endif /* __ASM_SH_PAGE_H */
--- a/include/asm-sh64/page.h
+++ b/include/asm-sh64/page.h
@@ -1,6 +1,6 @@
 #ifndef __ASM_SH64_PAGE_H
 #define __ASM_SH64_PAGE_H
-
+#ifdef __KERNEL__
 /*
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -43,7 +43,6 @@
 #define ARCH_HAS_SETCLEAR_HUGE_PTE
 #endif
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 extern struct page *mem_map;
@@ -113,7 +112,9 @@ typedef struct { unsigned long pgprot; }
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
+
+#include <asm-generic/page.h>
+
 #endif /* __ASM_SH64_PAGE_H */
--- a/include/asm-sparc/page.h
+++ b/include/asm-sparc/page.h
@@ -1,3 +1,8 @@
+#ifndef _SPARC_PAGE_H
+#define _SPARC_PAGE_H
+
+#ifdef __KERNEL__
+
 /* $Id: page.h,v 1.55 2000/10/30 21:01:41 davem Exp $
  * page.h:  Various defines and such for MMU operations on the Sparc for
  *          the Linux kernel.
@@ -5,11 +10,6 @@
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
  */
 
-#ifndef _SPARC_PAGE_H
-#define _SPARC_PAGE_H
-
-#ifdef __KERNEL__
-
 #ifdef CONFIG_SUN4
 #define PAGE_SHIFT   13
 #else
@@ -161,8 +161,9 @@ extern unsigned long pfn_base;
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _SPARC_PAGE_H */
--- a/include/asm-sparc64/page.h
+++ b/include/asm-sparc64/page.h
@@ -141,7 +141,8 @@ typedef unsigned long pgprot_t;
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+#endif /* __KERNEL__ */
+
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
 #endif /* _SPARC64_PAGE_H */
--- a/include/asm-v850/page.h
+++ b/include/asm-v850/page.h
@@ -1,3 +1,8 @@
+#ifndef __V850_PAGE_H__
+#define __V850_PAGE_H__
+
+#ifdef __KERNEL__
+
 /*
  * include/asm-v850/page.h -- VM ops
  *
@@ -11,11 +16,6 @@
  * Written by Miles Bader <miles@gnu.org>
  */
 
-#ifndef __V850_PAGE_H__
-#define __V850_PAGE_H__
-
-#ifdef __KERNEL__
-
 #include <asm/machdep.h>
 
 
@@ -124,8 +124,9 @@ typedef unsigned long pgprot_t;
 
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* KERNEL */
 
+#include <asm-generic/page.h>
+
 #endif /* __V850_PAGE_H__ */
--- a/include/asm-x86_64/page.h
+++ b/include/asm-x86_64/page.h
@@ -1,5 +1,6 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
+#ifdef __KERNEL__
 
 #include <linux/const.h>
 
@@ -37,7 +38,6 @@
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 extern unsigned long end_pfn;
@@ -135,8 +135,9 @@ extern unsigned long __phys_addr(unsigne
 #define __HAVE_ARCH_GATE_AREA 1	
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 
+#include <asm-generic/page.h>
+
 #endif /* _X86_64_PAGE_H */
--- a/include/asm-xtensa/page.h
+++ b/include/asm-xtensa/page.h
@@ -1,3 +1,8 @@
+#ifndef _XTENSA_PAGE_H
+#define _XTENSA_PAGE_H
+
+#ifdef __KERNEL__
+
 /*
  * linux/include/asm-xtensa/page.h
  *
@@ -8,11 +13,6 @@
  * Copyright (C) 2001 - 2005 Tensilica Inc.
  */
 
-#ifndef _XTENSA_PAGE_H
-#define _XTENSA_PAGE_H
-
-#ifdef __KERNEL__
-
 #include <asm/processor.h>
 
 #define XCHAL_KSEG_CACHED_VADDR 0xd0000000
@@ -59,7 +59,7 @@ typedef struct { unsigned long pgprot; }
 /*
  * Pure 2^n version of get_order
  */
-
+#define _ARCH_HAS_GET_ORDER 1
 static inline int get_order(unsigned long size)
 {
 	int order;
@@ -133,4 +133,7 @@ void copy_user_page(void *to,void* from,
 
 #include <asm-generic/memory_model.h>
 #endif /* __KERNEL__ */
+
+#include <asm-generic/page.h>
+
 #endif /* _XTENSA_PAGE_H */
