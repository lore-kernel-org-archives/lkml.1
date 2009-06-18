Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZFRTsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZFRTsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZFRTsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:48:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZFRTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:48:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] x86: add copies of some headers to convert to asm-generic
Date: Thu, 18 Jun 2009 21:48:16 +0200
Message-Id: <24f2094ecfd0d61058ddd3783a0c8af9fd22a781.1245354003.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Kc2GmeJU4ZRGM87gtEe3mSApK0b1zOsNKtE8
 fc2ATo5QNK7EHoZdBDZyVsVvpg44hnkXHy0sHx4jq8bibWkiSh
 fTeDn8qw5a6yxzmBR9W3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just an intermediate step to make reviewing easier.
These files are identical copies of the existing headers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/include/asm/generic-mman.h        |   20 +++++++
 arch/x86/include/asm/generic-module.h      |   80 ++++++++++++++++++++++++++++
 arch/x86/include/asm/generic-scatterlist.h |   33 +++++++++++
 arch/x86/include/asm/generic-types.h       |   30 ++++++++++
 arch/x86/include/asm/generic-ucontext.h    |   18 ++++++
 5 files changed, 181 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/generic-mman.h
 create mode 100644 arch/x86/include/asm/generic-module.h
 create mode 100644 arch/x86/include/asm/generic-scatterlist.h
 create mode 100644 arch/x86/include/asm/generic-types.h
 create mode 100644 arch/x86/include/asm/generic-ucontext.h

diff --git a/arch/x86/include/asm/generic-mman.h b/arch/x86/include/asm/generic-mman.h
new file mode 100644
index 0000000..751af25
--- /dev/null
+++ b/arch/x86/include/asm/generic-mman.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_X86_MMAN_H
+#define _ASM_X86_MMAN_H
+
+#include <asm-generic/mman-common.h>
+
+#define MAP_32BIT	0x40		/* only give out 32bit addresses */
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+#define MAP_LOCKED	0x2000		/* pages are locked */
+#define MAP_NORESERVE	0x4000		/* don't check for reservations */
+#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+
+#define MCL_CURRENT	1		/* lock all current mappings */
+#define MCL_FUTURE	2		/* lock all future mappings */
+
+#endif /* _ASM_X86_MMAN_H */
diff --git a/arch/x86/include/asm/generic-module.h b/arch/x86/include/asm/generic-module.h
new file mode 100644
index 0000000..47d6274
--- /dev/null
+++ b/arch/x86/include/asm/generic-module.h
@@ -0,0 +1,80 @@
+#ifndef _ASM_X86_MODULE_H
+#define _ASM_X86_MODULE_H
+
+/* x86_32/64 are simple */
+struct mod_arch_specific {};
+
+#ifdef CONFIG_X86_32
+# define Elf_Shdr Elf32_Shdr
+# define Elf_Sym Elf32_Sym
+# define Elf_Ehdr Elf32_Ehdr
+#else
+# define Elf_Shdr Elf64_Shdr
+# define Elf_Sym Elf64_Sym
+# define Elf_Ehdr Elf64_Ehdr
+#endif
+
+#ifdef CONFIG_X86_64
+/* X86_64 does not define MODULE_PROC_FAMILY */
+#elif defined CONFIG_M386
+#define MODULE_PROC_FAMILY "386 "
+#elif defined CONFIG_M486
+#define MODULE_PROC_FAMILY "486 "
+#elif defined CONFIG_M586
+#define MODULE_PROC_FAMILY "586 "
+#elif defined CONFIG_M586TSC
+#define MODULE_PROC_FAMILY "586TSC "
+#elif defined CONFIG_M586MMX
+#define MODULE_PROC_FAMILY "586MMX "
+#elif defined CONFIG_MCORE2
+#define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_M686
+#define MODULE_PROC_FAMILY "686 "
+#elif defined CONFIG_MPENTIUMII
+#define MODULE_PROC_FAMILY "PENTIUMII "
+#elif defined CONFIG_MPENTIUMIII
+#define MODULE_PROC_FAMILY "PENTIUMIII "
+#elif defined CONFIG_MPENTIUMM
+#define MODULE_PROC_FAMILY "PENTIUMM "
+#elif defined CONFIG_MPENTIUM4
+#define MODULE_PROC_FAMILY "PENTIUM4 "
+#elif defined CONFIG_MK6
+#define MODULE_PROC_FAMILY "K6 "
+#elif defined CONFIG_MK7
+#define MODULE_PROC_FAMILY "K7 "
+#elif defined CONFIG_MK8
+#define MODULE_PROC_FAMILY "K8 "
+#elif defined CONFIG_X86_ELAN
+#define MODULE_PROC_FAMILY "ELAN "
+#elif defined CONFIG_MCRUSOE
+#define MODULE_PROC_FAMILY "CRUSOE "
+#elif defined CONFIG_MEFFICEON
+#define MODULE_PROC_FAMILY "EFFICEON "
+#elif defined CONFIG_MWINCHIPC6
+#define MODULE_PROC_FAMILY "WINCHIPC6 "
+#elif defined CONFIG_MWINCHIP3D
+#define MODULE_PROC_FAMILY "WINCHIP3D "
+#elif defined CONFIG_MCYRIXIII
+#define MODULE_PROC_FAMILY "CYRIXIII "
+#elif defined CONFIG_MVIAC3_2
+#define MODULE_PROC_FAMILY "VIAC3-2 "
+#elif defined CONFIG_MVIAC7
+#define MODULE_PROC_FAMILY "VIAC7 "
+#elif defined CONFIG_MGEODEGX1
+#define MODULE_PROC_FAMILY "GEODEGX1 "
+#elif defined CONFIG_MGEODE_LX
+#define MODULE_PROC_FAMILY "GEODE "
+#else
+#error unknown processor family
+#endif
+
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_4KSTACKS
+#  define MODULE_STACKSIZE "4KSTACKS "
+# else
+#  define MODULE_STACKSIZE ""
+# endif
+# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
+#endif
+
+#endif /* _ASM_X86_MODULE_H */
diff --git a/arch/x86/include/asm/generic-scatterlist.h b/arch/x86/include/asm/generic-scatterlist.h
new file mode 100644
index 0000000..263d397
--- /dev/null
+++ b/arch/x86/include/asm/generic-scatterlist.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_X86_SCATTERLIST_H
+#define _ASM_X86_SCATTERLIST_H
+
+#include <asm/types.h>
+
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
+	unsigned int	offset;
+	unsigned int	length;
+	dma_addr_t	dma_address;
+	unsigned int	dma_length;
+};
+
+#define ARCH_HAS_SG_CHAIN
+#define ISA_DMA_THRESHOLD (0x00ffffff)
+
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#ifdef CONFIG_X86_32
+# define sg_dma_len(sg)		((sg)->length)
+#else
+# define sg_dma_len(sg)		((sg)->dma_length)
+#endif
+
+#endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/arch/x86/include/asm/generic-types.h b/arch/x86/include/asm/generic-types.h
new file mode 100644
index 0000000..09b9774
--- /dev/null
+++ b/arch/x86/include/asm/generic-types.h
@@ -0,0 +1,30 @@
+#ifndef _ASM_X86_TYPES_H
+#define _ASM_X86_TYPES_H
+
+#include <asm-generic/int-ll64.h>
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+typedef u64 dma64_addr_t;
+#if defined(CONFIG_X86_64) || defined(CONFIG_HIGHMEM64G)
+/* DMA addresses come in 32-bit and 64-bit flavours. */
+typedef u64 dma_addr_t;
+#else
+typedef u32 dma_addr_t;
+#endif
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_TYPES_H */
diff --git a/arch/x86/include/asm/generic-ucontext.h b/arch/x86/include/asm/generic-ucontext.h
new file mode 100644
index 0000000..87324cf
--- /dev/null
+++ b/arch/x86/include/asm/generic-ucontext.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_UCONTEXT_H
+#define _ASM_X86_UCONTEXT_H
+
+#define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
+				 * information in the memory layout pointed
+				 * by the fpstate pointer in the ucontext's
+				 * sigcontext struct (uc_mcontext).
+				 */
+
+struct ucontext {
+	unsigned long	  uc_flags;
+	struct ucontext  *uc_link;
+	stack_t		  uc_stack;
+	struct sigcontext uc_mcontext;
+	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
+#endif /* _ASM_X86_UCONTEXT_H */
-- 
1.6.3.1

