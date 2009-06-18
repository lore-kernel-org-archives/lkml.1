Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZFRVnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZFRVnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZFRVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:34650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbZFRVnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:43:35 -0400
Date: Thu, 18 Jun 2009 21:43:16 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
Subject: [tip:x86/asm-generic] x86: convert almost generic headers to asm-generic version
Message-ID: <tip-06f5013aa8eb5895ced2c71d13f5114103605555@git.kernel.org>
Git-Commit-ID: 06f5013aa8eb5895ced2c71d13f5114103605555
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 21:43:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06f5013aa8eb5895ced2c71d13f5114103605555
Gitweb:     http://git.kernel.org/tip/06f5013aa8eb5895ced2c71d13f5114103605555
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Thu, 18 Jun 2009 21:48:18 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Jun 2009 14:39:53 -0700

x86: convert almost generic headers to asm-generic version

In x86, mman.h, module.h, scatterlist.h, types.h and ucontext.h
can use the asm-generic version by just defining the x86
specific parts locally and falling back on the generic code
for the common bits.

This patch illustrates the differences between the x86 and
asm-generic versions by changing a file that is initially
identical to the x86 version to one that is identical
to the asm-generic version.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <cover.1245354003.git.arnd@arndb.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/generic-mman.h        |    8 +--
 arch/x86/include/asm/generic-module.h      |   92 +++++----------------------
 arch/x86/include/asm/generic-scatterlist.h |   34 +++++++----
 arch/x86/include/asm/generic-types.h       |   32 +++++++---
 arch/x86/include/asm/generic-ucontext.h    |   12 +---
 arch/x86/include/asm/mman.h                |   14 +----
 arch/x86/include/asm/module.h              |   13 +----
 arch/x86/include/asm/scatterlist.h         |   27 +--------
 arch/x86/include/asm/types.h               |   12 +---
 arch/x86/include/asm/ucontext.h            |    8 +--
 10 files changed, 73 insertions(+), 179 deletions(-)

diff --git a/arch/x86/include/asm/generic-mman.h b/arch/x86/include/asm/generic-mman.h
index 751af25..7cab4de 100644
--- a/arch/x86/include/asm/generic-mman.h
+++ b/arch/x86/include/asm/generic-mman.h
@@ -1,10 +1,8 @@
-#ifndef _ASM_X86_MMAN_H
-#define _ASM_X86_MMAN_H
+#ifndef __ASM_GENERIC_MMAN_H
+#define __ASM_GENERIC_MMAN_H
 
 #include <asm-generic/mman-common.h>
 
-#define MAP_32BIT	0x40		/* only give out 32bit addresses */
-
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
@@ -17,4 +15,4 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
-#endif /* _ASM_X86_MMAN_H */
+#endif /* __ASM_GENERIC_MMAN_H */
diff --git a/arch/x86/include/asm/generic-module.h b/arch/x86/include/asm/generic-module.h
index 47d6274..ed5b44d 100644
--- a/arch/x86/include/asm/generic-module.h
+++ b/arch/x86/include/asm/generic-module.h
@@ -1,80 +1,22 @@
-#ifndef _ASM_X86_MODULE_H
-#define _ASM_X86_MODULE_H
+#ifndef __ASM_GENERIC_MODULE_H
+#define __ASM_GENERIC_MODULE_H
 
-/* x86_32/64 are simple */
-struct mod_arch_specific {};
+/*
+ * Many architectures just need a simple module
+ * loader without arch specific data.
+ */
+struct mod_arch_specific
+{
+};
 
-#ifdef CONFIG_X86_32
-# define Elf_Shdr Elf32_Shdr
-# define Elf_Sym Elf32_Sym
-# define Elf_Ehdr Elf32_Ehdr
+#ifdef CONFIG_64BIT
+#define Elf_Shdr Elf64_Shdr
+#define Elf_Sym Elf64_Sym
+#define Elf_Ehdr Elf64_Ehdr
 #else
-# define Elf_Shdr Elf64_Shdr
-# define Elf_Sym Elf64_Sym
-# define Elf_Ehdr Elf64_Ehdr
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Ehdr Elf32_Ehdr
 #endif
 
-#ifdef CONFIG_X86_64
-/* X86_64 does not define MODULE_PROC_FAMILY */
-#elif defined CONFIG_M386
-#define MODULE_PROC_FAMILY "386 "
-#elif defined CONFIG_M486
-#define MODULE_PROC_FAMILY "486 "
-#elif defined CONFIG_M586
-#define MODULE_PROC_FAMILY "586 "
-#elif defined CONFIG_M586TSC
-#define MODULE_PROC_FAMILY "586TSC "
-#elif defined CONFIG_M586MMX
-#define MODULE_PROC_FAMILY "586MMX "
-#elif defined CONFIG_MCORE2
-#define MODULE_PROC_FAMILY "CORE2 "
-#elif defined CONFIG_M686
-#define MODULE_PROC_FAMILY "686 "
-#elif defined CONFIG_MPENTIUMII
-#define MODULE_PROC_FAMILY "PENTIUMII "
-#elif defined CONFIG_MPENTIUMIII
-#define MODULE_PROC_FAMILY "PENTIUMIII "
-#elif defined CONFIG_MPENTIUMM
-#define MODULE_PROC_FAMILY "PENTIUMM "
-#elif defined CONFIG_MPENTIUM4
-#define MODULE_PROC_FAMILY "PENTIUM4 "
-#elif defined CONFIG_MK6
-#define MODULE_PROC_FAMILY "K6 "
-#elif defined CONFIG_MK7
-#define MODULE_PROC_FAMILY "K7 "
-#elif defined CONFIG_MK8
-#define MODULE_PROC_FAMILY "K8 "
-#elif defined CONFIG_X86_ELAN
-#define MODULE_PROC_FAMILY "ELAN "
-#elif defined CONFIG_MCRUSOE
-#define MODULE_PROC_FAMILY "CRUSOE "
-#elif defined CONFIG_MEFFICEON
-#define MODULE_PROC_FAMILY "EFFICEON "
-#elif defined CONFIG_MWINCHIPC6
-#define MODULE_PROC_FAMILY "WINCHIPC6 "
-#elif defined CONFIG_MWINCHIP3D
-#define MODULE_PROC_FAMILY "WINCHIP3D "
-#elif defined CONFIG_MCYRIXIII
-#define MODULE_PROC_FAMILY "CYRIXIII "
-#elif defined CONFIG_MVIAC3_2
-#define MODULE_PROC_FAMILY "VIAC3-2 "
-#elif defined CONFIG_MVIAC7
-#define MODULE_PROC_FAMILY "VIAC7 "
-#elif defined CONFIG_MGEODEGX1
-#define MODULE_PROC_FAMILY "GEODEGX1 "
-#elif defined CONFIG_MGEODE_LX
-#define MODULE_PROC_FAMILY "GEODE "
-#else
-#error unknown processor family
-#endif
-
-#ifdef CONFIG_X86_32
-# ifdef CONFIG_4KSTACKS
-#  define MODULE_STACKSIZE "4KSTACKS "
-# else
-#  define MODULE_STACKSIZE ""
-# endif
-# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
-#endif
-
-#endif /* _ASM_X86_MODULE_H */
+#endif /* __ASM_GENERIC_MODULE_H */
diff --git a/arch/x86/include/asm/generic-scatterlist.h b/arch/x86/include/asm/generic-scatterlist.h
index 263d397..8b94544 100644
--- a/arch/x86/include/asm/generic-scatterlist.h
+++ b/arch/x86/include/asm/generic-scatterlist.h
@@ -1,7 +1,7 @@
-#ifndef _ASM_X86_SCATTERLIST_H
-#define _ASM_X86_SCATTERLIST_H
+#ifndef __ASM_GENERIC_SCATTERLIST_H
+#define __ASM_GENERIC_SCATTERLIST_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 struct scatterlist {
 #ifdef CONFIG_DEBUG_SG
@@ -14,20 +14,30 @@ struct scatterlist {
 	unsigned int	dma_length;
 };
 
-#define ARCH_HAS_SG_CHAIN
-#define ISA_DMA_THRESHOLD (0x00ffffff)
-
 /*
- * These macros should be used after a pci_map_sg call has been done
+ * These macros should be used after a dma_map_sg call has been done
  * to get bus addresses of each of the SG entries and their lengths.
  * You should only work with the number of sg entries pci_map_sg
- * returns.
+ * returns, or alternatively stop on the first sg_dma_len(sg) which
+ * is 0.
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
-#ifdef CONFIG_X86_32
-# define sg_dma_len(sg)		((sg)->length)
+#ifndef sg_dma_len
+/*
+ * Normally, you have an iommu on 64 bit machines, but not on 32 bit
+ * machines. Architectures that are differnt should override this.
+ */
+#if __BITS_PER_LONG == 64
+#define sg_dma_len(sg)		((sg)->dma_length)
 #else
-# define sg_dma_len(sg)		((sg)->dma_length)
+#define sg_dma_len(sg)		((sg)->length)
+#endif /* 64 bit */
+#endif /* sg_dma_len */
+
+#ifndef ISA_DMA_THRESHOLD
+#define ISA_DMA_THRESHOLD	(~0UL)
 #endif
 
-#endif /* _ASM_X86_SCATTERLIST_H */
+#define ARCH_HAS_SG_CHAIN
+
+#endif /* __ASM_GENERIC_SCATTERLIST_H */
diff --git a/arch/x86/include/asm/generic-types.h b/arch/x86/include/asm/generic-types.h
index 09b9774..fba7d33 100644
--- a/arch/x86/include/asm/generic-types.h
+++ b/arch/x86/include/asm/generic-types.h
@@ -1,6 +1,9 @@
-#ifndef _ASM_X86_TYPES_H
-#define _ASM_X86_TYPES_H
-
+#ifndef _ASM_GENERIC_TYPES_H
+#define _ASM_GENERIC_TYPES_H
+/*
+ * int-ll64 is used practically everywhere now,
+ * so use it as a reasonable default.
+ */
 #include <asm-generic/int-ll64.h>
 
 #ifndef __ASSEMBLY__
@@ -13,18 +16,27 @@ typedef unsigned short umode_t;
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
 #ifndef __ASSEMBLY__
-
-typedef u64 dma64_addr_t;
-#if defined(CONFIG_X86_64) || defined(CONFIG_HIGHMEM64G)
-/* DMA addresses come in 32-bit and 64-bit flavours. */
+/*
+ * DMA addresses may be very different from physical addresses
+ * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
+ * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
+ * physical addresses.
+ * This default defines dma_addr_t to have the same size as
+ * phys_addr_t, which is the most common way.
+ * Do not define the dma64_addr_t type, which never really
+ * worked.
+ */
+#ifndef dma_addr_t
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 dma_addr_t;
 #else
 typedef u32 dma_addr_t;
-#endif
+#endif /* CONFIG_PHYS_ADDR_T_64BIT */
+#endif /* dma_addr_t */
 
 #endif /* __ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 
-#endif /* _ASM_X86_TYPES_H */
+#endif /* _ASM_GENERIC_TYPES_H */
diff --git a/arch/x86/include/asm/generic-ucontext.h b/arch/x86/include/asm/generic-ucontext.h
index 87324cf..ad77343 100644
--- a/arch/x86/include/asm/generic-ucontext.h
+++ b/arch/x86/include/asm/generic-ucontext.h
@@ -1,11 +1,5 @@
-#ifndef _ASM_X86_UCONTEXT_H
-#define _ASM_X86_UCONTEXT_H
-
-#define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
-				 * information in the memory layout pointed
-				 * by the fpstate pointer in the ucontext's
-				 * sigcontext struct (uc_mcontext).
-				 */
+#ifndef __ASM_GENERIC_UCONTEXT_H
+#define __ASM_GENERIC_UCONTEXT_H
 
 struct ucontext {
 	unsigned long	  uc_flags;
@@ -15,4 +9,4 @@ struct ucontext {
 	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
-#endif /* _ASM_X86_UCONTEXT_H */
+#endif /* __ASM_GENERIC_UCONTEXT_H */
diff --git a/arch/x86/include/asm/mman.h b/arch/x86/include/asm/mman.h
index 751af25..063d8c9 100644
--- a/arch/x86/include/asm/mman.h
+++ b/arch/x86/include/asm/mman.h
@@ -1,20 +1,8 @@
 #ifndef _ASM_X86_MMAN_H
 #define _ASM_X86_MMAN_H
 
-#include <asm-generic/mman-common.h>
-
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
-#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
-#define MAP_LOCKED	0x2000		/* pages are locked */
-#define MAP_NORESERVE	0x4000		/* don't check for reservations */
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
-
-#define MCL_CURRENT	1		/* lock all current mappings */
-#define MCL_FUTURE	2		/* lock all future mappings */
+#include <asm/generic-mman.h>
 
 #endif /* _ASM_X86_MMAN_H */
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 47d6274..4a7a192 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -1,18 +1,7 @@
 #ifndef _ASM_X86_MODULE_H
 #define _ASM_X86_MODULE_H
 
-/* x86_32/64 are simple */
-struct mod_arch_specific {};
-
-#ifdef CONFIG_X86_32
-# define Elf_Shdr Elf32_Shdr
-# define Elf_Sym Elf32_Sym
-# define Elf_Ehdr Elf32_Ehdr
-#else
-# define Elf_Shdr Elf64_Shdr
-# define Elf_Sym Elf64_Sym
-# define Elf_Ehdr Elf64_Ehdr
-#endif
+#include <asm/generic-module.h>
 
 #ifdef CONFIG_X86_64
 /* X86_64 does not define MODULE_PROC_FAMILY */
diff --git a/arch/x86/include/asm/scatterlist.h b/arch/x86/include/asm/scatterlist.h
index 263d397..2097d68 100644
--- a/arch/x86/include/asm/scatterlist.h
+++ b/arch/x86/include/asm/scatterlist.h
@@ -1,33 +1,8 @@
 #ifndef _ASM_X86_SCATTERLIST_H
 #define _ASM_X86_SCATTERLIST_H
 
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;
-	unsigned int	length;
-	dma_addr_t	dma_address;
-	unsigned int	dma_length;
-};
-
-#define ARCH_HAS_SG_CHAIN
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#ifdef CONFIG_X86_32
-# define sg_dma_len(sg)		((sg)->length)
-#else
-# define sg_dma_len(sg)		((sg)->dma_length)
-#endif
+#include <asm/generic-scatterlist.h>
 
 #endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index 09b9774..f2fe528 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -1,19 +1,11 @@
 #ifndef _ASM_X86_TYPES_H
 #define _ASM_X86_TYPES_H
 
-#include <asm-generic/int-ll64.h>
+#define dma_addr_t	dma_addr_t
 
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
+#include <asm/generic-types.h>
 
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
 #ifdef __KERNEL__
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
diff --git a/arch/x86/include/asm/ucontext.h b/arch/x86/include/asm/ucontext.h
index 87324cf..7cfc436 100644
--- a/arch/x86/include/asm/ucontext.h
+++ b/arch/x86/include/asm/ucontext.h
@@ -7,12 +7,6 @@
 				 * sigcontext struct (uc_mcontext).
 				 */
 
-struct ucontext {
-	unsigned long	  uc_flags;
-	struct ucontext  *uc_link;
-	stack_t		  uc_stack;
-	struct sigcontext uc_mcontext;
-	sigset_t	  uc_sigmask;	/* mask last for extensibility */
-};
+#include <asm/generic-ucontext.h>
 
 #endif /* _ASM_X86_UCONTEXT_H */
