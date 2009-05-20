Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZETS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZETS3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZETSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52674 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbZETSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:20 -0400
Subject: [RFC v2][PATCH 22/35] include linux/ptemap.h at all use sites
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:20 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182520.1E935464@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This ensures that the users of the pte mapping functions
are no longer depending on mm.h or any of the arch-specific
header files.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/arm/kernel/traps.c        |    1 +
 linux-2.6.git-dave/arch/arm/mm/fault-armv.c       |    1 +
 linux-2.6.git-dave/arch/arm/mm/fault.c            |    1 +
 linux-2.6.git-dave/arch/arm/mm/pgd.c              |    1 +
 linux-2.6.git-dave/arch/ia64/mm/hugetlbpage.c     |    1 +
 linux-2.6.git-dave/arch/m68k/mm/kmap.c            |    1 +
 linux-2.6.git-dave/arch/mips/mm/tlb-r4k.c         |    1 +
 linux-2.6.git-dave/arch/mips/mm/tlb-r8k.c         |    1 +
 linux-2.6.git-dave/arch/mn10300/mm/cache.c        |    1 +
 linux-2.6.git-dave/arch/parisc/kernel/cache.c     |    1 +
 linux-2.6.git-dave/arch/parisc/kernel/pci-dma.c   |    2 ++
 linux-2.6.git-dave/arch/powerpc/mm/pgtable_32.c   |    1 +
 linux-2.6.git-dave/arch/powerpc/mm/pgtable_64.c   |    1 +
 linux-2.6.git-dave/arch/powerpc/mm/subpage-prot.c |    1 +
 linux-2.6.git-dave/arch/s390/lib/uaccess_pt.c     |    1 +
 linux-2.6.git-dave/arch/sh/mm/cache-sh5.c         |    1 +
 linux-2.6.git-dave/arch/sh/mm/hugetlbpage.c       |    1 +
 linux-2.6.git-dave/arch/sparc/kernel/signal32.c   |    1 +
 linux-2.6.git-dave/arch/sparc/mm/fault_64.c       |    1 +
 linux-2.6.git-dave/arch/sparc/mm/generic_64.c     |    1 +
 linux-2.6.git-dave/arch/sparc/mm/hugetlbpage.c    |    1 +
 linux-2.6.git-dave/arch/sparc/mm/io-unit.c        |    1 +
 linux-2.6.git-dave/arch/sparc/mm/iommu.c          |    1 +
 linux-2.6.git-dave/arch/um/kernel/tlb.c           |    1 +
 linux-2.6.git-dave/arch/x86/kernel/vm86_32.c      |    1 +
 linux-2.6.git-dave/arch/x86/mm/gup.c              |    1 +
 linux-2.6.git-dave/fs/proc/task_mmu.c             |    1 +
 linux-2.6.git-dave/lib/ioremap.c                  |    1 +
 linux-2.6.git-dave/mm/fremap.c                    |    1 +
 linux-2.6.git-dave/mm/memory.c                    |    1 +
 linux-2.6.git-dave/mm/mempolicy.c                 |    1 +
 linux-2.6.git-dave/mm/migrate.c                   |    1 +
 linux-2.6.git-dave/mm/mincore.c                   |    1 +
 linux-2.6.git-dave/mm/mprotect.c                  |    1 +
 linux-2.6.git-dave/mm/mremap.c                    |    1 +
 linux-2.6.git-dave/mm/pagewalk.c                  |    1 +
 linux-2.6.git-dave/mm/rmap.c                      |    1 +
 linux-2.6.git-dave/mm/swapfile.c                  |    1 +
 linux-2.6.git-dave/mm/vmalloc.c                   |    1 +
 39 files changed, 40 insertions(+)

diff -puN arch/arm/kernel/traps.c~include-linux-ptemaph-at-all-call-sites arch/arm/kernel/traps.c
--- linux-2.6.git/arch/arm/kernel/traps.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/kernel/traps.c	2009-05-01 11:31:53.000000000 -0700
@@ -21,6 +21,7 @@
 #include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/ptemap.h>
 
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
diff -puN arch/arm/mm/fault-armv.c~include-linux-ptemaph-at-all-call-sites arch/arm/mm/fault-armv.c
--- linux-2.6.git/arch/arm/mm/fault-armv.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/mm/fault-armv.c	2009-05-01 11:31:53.000000000 -0700
@@ -16,6 +16,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/ptemap.h>
 
 #include <asm/bugs.h>
 #include <asm/cacheflush.h>
diff -puN arch/arm/mm/fault.c~include-linux-ptemaph-at-all-call-sites arch/arm/mm/fault.c
--- linux-2.6.git/arch/arm/mm/fault.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/mm/fault.c	2009-05-01 11:31:53.000000000 -0700
@@ -16,6 +16,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/page-flags.h>
+#include <linux/ptemap.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN arch/arm/mm/pgd.c~include-linux-ptemaph-at-all-call-sites arch/arm/mm/pgd.c
--- linux-2.6.git/arch/arm/mm/pgd.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/mm/pgd.c	2009-05-01 11:31:53.000000000 -0700
@@ -9,6 +9,7 @@
  */
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
diff -puN arch/ia64/mm/hugetlbpage.c~include-linux-ptemaph-at-all-call-sites arch/ia64/mm/hugetlbpage.c
--- linux-2.6.git/arch/ia64/mm/hugetlbpage.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/ia64/mm/hugetlbpage.c	2009-05-01 11:31:53.000000000 -0700
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/log2.h>
+#include <linux/ptemap.h>
 #include <asm/mman.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
diff -puN arch/m68k/mm/kmap.c~include-linux-ptemaph-at-all-call-sites arch/m68k/mm/kmap.c
--- linux-2.6.git/arch/m68k/mm/kmap.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/mm/kmap.c	2009-05-01 11:31:53.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/ptemap.h>
 
 #include <asm/setup.h>
 #include <asm/segment.h>
diff -puN arch/mips/mm/tlb-r4k.c~include-linux-ptemaph-at-all-call-sites arch/mips/mm/tlb-r4k.c
--- linux-2.6.git/arch/mips/mm/tlb-r4k.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/mm/tlb-r4k.c	2009-05-01 11:31:53.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/ptemap.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff -puN arch/mips/mm/tlb-r8k.c~include-linux-ptemaph-at-all-call-sites arch/mips/mm/tlb-r8k.c
--- linux-2.6.git/arch/mips/mm/tlb-r8k.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/mm/tlb-r8k.c	2009-05-01 11:31:53.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/ptemap.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff -puN arch/mn10300/mm/cache.c~include-linux-ptemaph-at-all-call-sites arch/mn10300/mm/cache.c
--- linux-2.6.git/arch/mn10300/mm/cache.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/mn10300/mm/cache.c	2009-05-01 11:31:53.000000000 -0700
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/threads.h>
+#include <linux/ptemap.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
diff -puN arch/parisc/kernel/cache.c~include-linux-ptemaph-at-all-call-sites arch/parisc/kernel/cache.c
--- linux-2.6.git/arch/parisc/kernel/cache.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/parisc/kernel/cache.c	2009-05-01 11:31:53.000000000 -0700
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/pagemap.h>
 #include <linux/sched.h>
+#include <linux/ptemap.h>
 #include <asm/pdc.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
diff -puN arch/parisc/kernel/pci-dma.c~include-linux-ptemaph-at-all-call-sites arch/parisc/kernel/pci-dma.c
--- linux-2.6.git/arch/parisc/kernel/pci-dma.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/parisc/kernel/pci-dma.c	2009-05-01 11:31:53.000000000 -0700
@@ -21,11 +21,13 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
+#include <linux/ptemap.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/ptemap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/dma.h>    /* for DMA_CHUNK_SIZE */
diff -puN arch/powerpc/mm/pgtable_32.c~include-linux-ptemaph-at-all-call-sites arch/powerpc/mm/pgtable_32.c
--- linux-2.6.git/arch/powerpc/mm/pgtable_32.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/mm/pgtable_32.c	2009-05-01 11:31:53.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff -puN arch/powerpc/mm/pgtable_64.c~include-linux-ptemaph-at-all-call-sites arch/powerpc/mm/pgtable_64.c
--- linux-2.6.git/arch/powerpc/mm/pgtable_64.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/mm/pgtable_64.c	2009-05-01 11:31:53.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/stddef.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
diff -puN arch/powerpc/mm/subpage-prot.c~include-linux-ptemaph-at-all-call-sites arch/powerpc/mm/subpage-prot.c
--- linux-2.6.git/arch/powerpc/mm/subpage-prot.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/mm/subpage-prot.c	2009-05-01 11:31:53.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
diff -puN arch/s390/lib/uaccess_pt.c~include-linux-ptemaph-at-all-call-sites arch/s390/lib/uaccess_pt.c
--- linux-2.6.git/arch/s390/lib/uaccess_pt.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/s390/lib/uaccess_pt.c	2009-05-01 11:31:53.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/mm.h>
+#include <linux/ptemap.h>
 #include <asm/uaccess.h>
 #include <asm/futex.h>
 #include "uaccess.h"
diff -puN arch/sh/mm/cache-sh5.c~include-linux-ptemaph-at-all-call-sites arch/sh/mm/cache-sh5.c
--- linux-2.6.git/arch/sh/mm/cache-sh5.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/mm/cache-sh5.c	2009-05-01 11:31:53.000000000 -0700
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
+#include <linux/ptemap.h>
 #include <asm/tlb.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
diff -puN arch/sh/mm/hugetlbpage.c~include-linux-ptemaph-at-all-call-sites arch/sh/mm/hugetlbpage.c
--- linux-2.6.git/arch/sh/mm/hugetlbpage.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/mm/hugetlbpage.c	2009-05-01 11:31:53.000000000 -0700
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/ptemap.h>
 
 #include <asm/mman.h>
 #include <asm/pgalloc.h>
diff -puN arch/sparc/kernel/signal32.c~include-linux-ptemaph-at-all-call-sites arch/sparc/kernel/signal32.c
--- linux-2.6.git/arch/sparc/kernel/signal32.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/kernel/signal32.c	2009-05-01 11:31:53.000000000 -0700
@@ -20,6 +20,7 @@
 #include <linux/compat.h>
 #include <linux/bitops.h>
 #include <linux/tracehook.h>
+#include <linux/ptemap.h>
 
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
diff -puN arch/sparc/mm/fault_64.c~include-linux-ptemaph-at-all-call-sites arch/sparc/mm/fault_64.c
--- linux-2.6.git/arch/sparc/mm/fault_64.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/mm/fault_64.c	2009-05-01 11:31:53.000000000 -0700
@@ -20,6 +20,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/percpu.h>
+#include <linux/ptemap.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff -puN arch/sparc/mm/generic_64.c~include-linux-ptemaph-at-all-call-sites arch/sparc/mm/generic_64.c
--- linux-2.6.git/arch/sparc/mm/generic_64.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/mm/generic_64.c	2009-05-01 11:31:53.000000000 -0700
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/pagemap.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff -puN arch/sparc/mm/hugetlbpage.c~include-linux-ptemaph-at-all-call-sites arch/sparc/mm/hugetlbpage.c
--- linux-2.6.git/arch/sparc/mm/hugetlbpage.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/mm/hugetlbpage.c	2009-05-01 11:31:53.000000000 -0700
@@ -12,6 +12,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/ptemap.h>
 
 #include <asm/mman.h>
 #include <asm/pgalloc.h>
diff -puN arch/sparc/mm/iommu.c~include-linux-ptemaph-at-all-call-sites arch/sparc/mm/iommu.c
--- linux-2.6.git/arch/sparc/mm/iommu.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/mm/iommu.c	2009-05-01 11:31:53.000000000 -0700
@@ -15,6 +15,7 @@
 #include <linux/scatterlist.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff -puN arch/sparc/mm/io-unit.c~include-linux-ptemaph-at-all-call-sites arch/sparc/mm/io-unit.c
--- linux-2.6.git/arch/sparc/mm/io-unit.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/mm/io-unit.c	2009-05-01 11:31:53.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/scatterlist.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff -puN arch/um/kernel/tlb.c~include-linux-ptemaph-at-all-call-sites arch/um/kernel/tlb.c
--- linux-2.6.git/arch/um/kernel/tlb.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/um/kernel/tlb.c	2009-05-01 11:31:53.000000000 -0700
@@ -5,6 +5,7 @@
 
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/ptemap.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include "as-layout.h"
diff -puN arch/x86/kernel/vm86_32.c~include-linux-ptemaph-at-all-call-sites arch/x86/kernel/vm86_32.c
--- linux-2.6.git/arch/x86/kernel/vm86_32.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kernel/vm86_32.c	2009-05-01 11:31:53.000000000 -0700
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/audit.h>
 #include <linux/stddef.h>
+#include <linux/ptemap.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff -puN arch/x86/mm/gup.c~include-linux-ptemaph-at-all-call-sites arch/x86/mm/gup.c
--- linux-2.6.git/arch/x86/mm/gup.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/mm/gup.c	2009-05-01 11:31:53.000000000 -0700
@@ -10,6 +10,7 @@
 #include <linux/highmem.h>
 
 #include <asm/pgtable.h>
+#include <asm/ptemap.h>
 
 static inline pte_t gup_get_pte(pte_t *ptep)
 {
diff -puN fs/proc/task_mmu.c~include-linux-ptemaph-at-all-call-sites fs/proc/task_mmu.c
--- linux-2.6.git/fs/proc/task_mmu.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/fs/proc/task_mmu.c	2009-05-01 11:31:53.000000000 -0700
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/ptemap.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
diff -puN lib/ioremap.c~include-linux-ptemaph-at-all-call-sites lib/ioremap.c
--- linux-2.6.git/lib/ioremap.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/lib/ioremap.c	2009-05-01 11:31:53.000000000 -0700
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/io.h>
+#include <linux/ptemap.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
diff -puN mm/fremap.c~include-linux-ptemaph-at-all-call-sites mm/fremap.c
--- linux-2.6.git/mm/fremap.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/fremap.c	2009-05-01 11:31:53.000000000 -0700
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
+#include <linux/ptemap.h>
 
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
diff -puN mm/memory.c~include-linux-ptemaph-at-all-call-sites mm/memory.c
--- linux-2.6.git/mm/memory.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/memory.c	2009-05-01 11:31:53.000000000 -0700
@@ -55,6 +55,7 @@
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
 #include <linux/elf.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
diff -puN mm/mempolicy.c~include-linux-ptemaph-at-all-call-sites mm/mempolicy.c
--- linux-2.6.git/mm/mempolicy.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/mempolicy.c	2009-05-01 11:31:53.000000000 -0700
@@ -89,6 +89,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/ctype.h>
+#include <linux/ptemap.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
diff -puN mm/migrate.c~include-linux-ptemaph-at-all-call-sites mm/migrate.c
--- linux-2.6.git/mm/migrate.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/migrate.c	2009-05-01 11:31:53.000000000 -0700
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/memcontrol.h>
 #include <linux/syscalls.h>
+#include <linux/ptemap.h>
 
 #include "internal.h"
 
diff -puN mm/mincore.c~include-linux-ptemaph-at-all-call-sites mm/mincore.c
--- linux-2.6.git/mm/mincore.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/mincore.c	2009-05-01 11:31:53.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/ptemap.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff -puN mm/mprotect.c~include-linux-ptemaph-at-all-call-sites mm/mprotect.c
--- linux-2.6.git/mm/mprotect.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/mprotect.c	2009-05-01 11:31:53.000000000 -0700
@@ -23,6 +23,7 @@
 #include <linux/swapops.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
+#include <linux/ptemap.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
diff -puN mm/mremap.c~include-linux-ptemaph-at-all-call-sites mm/mremap.c
--- linux-2.6.git/mm/mremap.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/mremap.c	2009-05-01 11:31:53.000000000 -0700
@@ -19,6 +19,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
+#include <linux/ptemap.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff -puN mm/pagewalk.c~include-linux-ptemaph-at-all-call-sites mm/pagewalk.c
--- linux-2.6.git/mm/pagewalk.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/pagewalk.c	2009-05-01 11:31:53.000000000 -0700
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
+#include <linux/ptemap.h>
 
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
diff -puN mm/rmap.c~include-linux-ptemaph-at-all-call-sites mm/rmap.c
--- linux-2.6.git/mm/rmap.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:52.000000000 -0700
+++ linux-2.6.git-dave/mm/rmap.c	2009-05-01 11:31:53.000000000 -0700
@@ -50,6 +50,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
+#include <linux/ptemap.h>
 
 #include <asm/tlbflush.h>
 
diff -puN mm/swapfile.c~include-linux-ptemaph-at-all-call-sites mm/swapfile.c
--- linux-2.6.git/mm/swapfile.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:53.000000000 -0700
+++ linux-2.6.git-dave/mm/swapfile.c	2009-05-01 11:31:53.000000000 -0700
@@ -29,6 +29,7 @@
 #include <linux/capability.h>
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
+#include <linux/ptemap.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
diff -puN mm/vmalloc.c~include-linux-ptemaph-at-all-call-sites mm/vmalloc.c
--- linux-2.6.git/mm/vmalloc.c~include-linux-ptemaph-at-all-call-sites	2009-05-01 11:31:53.000000000 -0700
+++ linux-2.6.git-dave/mm/vmalloc.c	2009-05-01 11:31:53.000000000 -0700
@@ -25,6 +25,7 @@
 #include <linux/rcupdate.h>
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
+#include <linux/ptemap.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
_
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index c0f3bee..563d751 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -20,6 +20,7 @@
 #include <linux/proc_fs.h>
 #include <linux/bitops.h>
 #include <linux/kexec.h>
+#include <linux/ptemap.h>
 
 #include <asm/dma.h>
 #include <asm/ia32.h>
