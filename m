Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZDBEzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZDBEzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbZDBEyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:54:51 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:38057 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751620AbZDBEyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:54:50 -0400
Date: Thu, 2 Apr 2009 14:53:37 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200904020453.n324rbR3018691@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch updates
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from to get a set of updates for the m68knommu arch.

There is a lot of header file clean ups after the m68knommu/m68k
header file merge.  Most of the separate files only differ in minor
ways, and are easy to merge into a single file.

There is a handful of other fixes too. In particular to the UART
settings in the platform code of some ColdFire family members.

Regards
Greg



The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Geert Uytterhoeven (2):
      m68k: Use dma_addr_t for scatterlist.dma_address
      m68k: Restore correct include guards for <asm/unaligned.h>

Greg Ungerer (38):
      m68knommu: mark all RAM as ZONE_DMA
      m68knommu: add a local dma_sync_single_for_cpu() function
      m68k: use the mmu pci.h for m68knommu as well
      m68k: swtich non-mmu setups to use the mmu dma-mapping.h
      m68k: use the mc146818rtc.h for non-mmu setups as well.
      m68k: use mmu kmap_types.h for non-mmu setups as well
      m68knommu: remove no longer used mcfpci.h
      m68k: merge the mmu and non-mmu versions of mmu.h
      m68k: use mmu scatterlist.h for non-mmu setups as well
      m68k: use mmu fpu.h for non-mmu builds as well
      m68k: use mmu timex.h for non-mmu setups as well
      m68k: use mmu version of elf.h for non-mmu builds as well
      m68k: use non-mmu version of unaligned.h for all m68k
      m68k: the one hw_irq.h can be used buy all m68k
      m68k: merge the mmu and non-mmu versions of page_offset.h
      m68knommu: mv definition of check_pgt_cache()
      m68k: merge the mmu and non-mmu versions of pgalloc.h
      m68k: merge the mmu and non-mmu versions of ucontext.h
      m68k: merge the mmu and non-mmu versions of segment.h
      m68k: merge the mmu and non-mmu versions of fb.h
      m68k: use the mmu version of bootinfo.h for m68knommu as well
      m68k: use the mmu version of cache.h for m68knommu as well
      m68k: merge the mmu and non-mmu versions of bug.h
      m68k: merge the mmu and non-mmu versions of bugs.h
      m68k: merge the mmu and non-mmu versions of div64.h
      m68k: merge the mmu and non-mmu versions of current.h
      m68k: merge the mmu and non-mmu versions of mmu_context.h
      m68knommu: add missing interrupt line definition for UART 2
      m68k: merge the mmu and non-mmu versions of module.h
      m68knommu: introduce basic clk infrastructure
      m68k: merge the mmu and non-mmu versions of tlbflush.h
      m68knommu: switch to using generic_handle_irq()
      m68knommu: fix end of uart table marker
      m68knommu: fix 5249 ColdFire UART setup
      m68knommu: fix 5249 ColdFire UART vector setup
      m68knommu: fix 5307 ColdFire UART vector setup
      m68knommu: fix 5407 ColdFire UART vector setup
      m68knommu: improve compile arch switch settings

Len Sorensen (1):
      m68knommu: Fix support for console port other than ttyS0 on mcf.c

 arch/m68k/include/asm/bootinfo.h          |  381 ++++++++++++++++++++++++++++-
 arch/m68k/include/asm/bootinfo_mm.h       |  378 ----------------------------
 arch/m68k/include/asm/bootinfo_no.h       |    2 -
 arch/m68k/include/asm/bug.h               |   31 ++-
 arch/m68k/include/asm/bug_mm.h            |   29 ---
 arch/m68k/include/asm/bug_no.h            |    4 -
 arch/m68k/include/asm/bugs.h              |   21 ++-
 arch/m68k/include/asm/bugs_mm.h           |   14 -
 arch/m68k/include/asm/bugs_no.h           |   16 --
 arch/m68k/include/asm/cache.h             |   14 +-
 arch/m68k/include/asm/cache_mm.h          |   11 -
 arch/m68k/include/asm/cache_no.h          |   12 -
 arch/m68k/include/asm/current.h           |   31 ++-
 arch/m68k/include/asm/current_mm.h        |    6 -
 arch/m68k/include/asm/current_no.h        |   24 --
 arch/m68k/include/asm/div64.h             |   37 +++-
 arch/m68k/include/asm/div64_mm.h          |   28 --
 arch/m68k/include/asm/div64_no.h          |    1 -
 arch/m68k/include/asm/dma-mapping.h       |  113 +++++++++-
 arch/m68k/include/asm/dma-mapping_mm.h    |  112 ---------
 arch/m68k/include/asm/dma-mapping_no.h    |    6 -
 arch/m68k/include/asm/elf.h               |  120 +++++++++-
 arch/m68k/include/asm/elf_mm.h            |  119 ---------
 arch/m68k/include/asm/elf_no.h            |  110 ---------
 arch/m68k/include/asm/fb.h                |   41 +++-
 arch/m68k/include/asm/fb_mm.h             |   34 ---
 arch/m68k/include/asm/fb_no.h             |   12 -
 arch/m68k/include/asm/fpu.h               |   22 ++-
 arch/m68k/include/asm/fpu_mm.h            |   21 --
 arch/m68k/include/asm/fpu_no.h            |   21 --
 arch/m68k/include/asm/hw_irq.h            |    9 +-
 arch/m68k/include/asm/hw_irq_mm.h         |    6 -
 arch/m68k/include/asm/hw_irq_no.h         |    4 -
 arch/m68k/include/asm/kmap_types.h        |   26 ++-
 arch/m68k/include/asm/kmap_types_mm.h     |   21 --
 arch/m68k/include/asm/kmap_types_no.h     |   21 --
 arch/m68k/include/asm/m532xsim.h          |    1 +
 arch/m68k/include/asm/mc146818rtc.h       |   31 ++-
 arch/m68k/include/asm/mc146818rtc_mm.h    |   26 --
 arch/m68k/include/asm/mc146818rtc_no.h    |    9 -
 arch/m68k/include/asm/mcfpci.h            |  119 ---------
 arch/m68k/include/asm/mmu.h               |   14 +-
 arch/m68k/include/asm/mmu_context.h       |  176 +++++++++++++-
 arch/m68k/include/asm/mmu_context_mm.h    |  154 ------------
 arch/m68k/include/asm/mmu_context_no.h    |   33 ---
 arch/m68k/include/asm/mmu_mm.h            |    7 -
 arch/m68k/include/asm/mmu_no.h            |   10 -
 arch/m68k/include/asm/module.h            |   51 ++++-
 arch/m68k/include/asm/module_mm.h         |   39 ---
 arch/m68k/include/asm/module_no.h         |   11 -
 arch/m68k/include/asm/page_offset.h       |   12 +-
 arch/m68k/include/asm/page_offset_mm.h    |    8 -
 arch/m68k/include/asm/page_offset_no.h    |    5 -
 arch/m68k/include/asm/pci.h               |   17 +-
 arch/m68k/include/asm/pci_mm.h            |   12 -
 arch/m68k/include/asm/pci_no.h            |   29 ---
 arch/m68k/include/asm/pgalloc.h           |   20 ++-
 arch/m68k/include/asm/pgalloc_mm.h        |   19 --
 arch/m68k/include/asm/pgalloc_no.h        |    8 -
 arch/m68k/include/asm/pgtable_no.h        |    2 +
 arch/m68k/include/asm/scatterlist.h       |   26 ++-
 arch/m68k/include/asm/scatterlist_mm.h    |   23 --
 arch/m68k/include/asm/scatterlist_no.h    |   22 --
 arch/m68k/include/asm/segment.h           |   64 +++++-
 arch/m68k/include/asm/segment_mm.h        |   57 -----
 arch/m68k/include/asm/segment_no.h        |   51 ----
 arch/m68k/include/asm/timex.h             |   21 ++-
 arch/m68k/include/asm/timex_mm.h          |   18 --
 arch/m68k/include/asm/timex_no.h          |   23 --
 arch/m68k/include/asm/tlbflush.h          |  268 ++++++++++++++++++++-
 arch/m68k/include/asm/tlbflush_mm.h       |  219 -----------------
 arch/m68k/include/asm/tlbflush_no.h       |   55 ----
 arch/m68k/include/asm/ucontext.h          |   33 +++-
 arch/m68k/include/asm/ucontext_mm.h       |   30 ---
 arch/m68k/include/asm/ucontext_no.h       |   32 ---
 arch/m68k/include/asm/unaligned.h         |   26 ++-
 arch/m68k/include/asm/unaligned_mm.h      |   13 -
 arch/m68k/include/asm/unaligned_no.h      |   25 --
 arch/m68knommu/Makefile                   |   14 +-
 arch/m68knommu/kernel/dma.c               |    8 +-
 arch/m68knommu/kernel/irq.c               |    2 +-
 arch/m68knommu/mm/init.c                  |    6 +-
 arch/m68knommu/platform/5249/config.c     |   11 +-
 arch/m68knommu/platform/5307/config.c     |    8 +-
 arch/m68knommu/platform/5407/config.c     |    8 +-
 arch/m68knommu/platform/coldfire/Makefile |    2 +-
 arch/m68knommu/platform/coldfire/clk.c    |   40 +++
 drivers/serial/mcf.c                      |    2 +-
 88 files changed, 1589 insertions(+), 2189 deletions(-)
 delete mode 100644 arch/m68k/include/asm/bootinfo_mm.h
 delete mode 100644 arch/m68k/include/asm/bootinfo_no.h
 delete mode 100644 arch/m68k/include/asm/bug_mm.h
 delete mode 100644 arch/m68k/include/asm/bug_no.h
 delete mode 100644 arch/m68k/include/asm/bugs_mm.h
 delete mode 100644 arch/m68k/include/asm/bugs_no.h
 delete mode 100644 arch/m68k/include/asm/cache_mm.h
 delete mode 100644 arch/m68k/include/asm/cache_no.h
 delete mode 100644 arch/m68k/include/asm/current_mm.h
 delete mode 100644 arch/m68k/include/asm/current_no.h
 delete mode 100644 arch/m68k/include/asm/div64_mm.h
 delete mode 100644 arch/m68k/include/asm/div64_no.h
 delete mode 100644 arch/m68k/include/asm/dma-mapping_mm.h
 delete mode 100644 arch/m68k/include/asm/dma-mapping_no.h
 delete mode 100644 arch/m68k/include/asm/elf_mm.h
 delete mode 100644 arch/m68k/include/asm/elf_no.h
 delete mode 100644 arch/m68k/include/asm/fb_mm.h
 delete mode 100644 arch/m68k/include/asm/fb_no.h
 delete mode 100644 arch/m68k/include/asm/fpu_mm.h
 delete mode 100644 arch/m68k/include/asm/fpu_no.h
 delete mode 100644 arch/m68k/include/asm/hw_irq_mm.h
 delete mode 100644 arch/m68k/include/asm/hw_irq_no.h
 delete mode 100644 arch/m68k/include/asm/kmap_types_mm.h
 delete mode 100644 arch/m68k/include/asm/kmap_types_no.h
 delete mode 100644 arch/m68k/include/asm/mc146818rtc_mm.h
 delete mode 100644 arch/m68k/include/asm/mc146818rtc_no.h
 delete mode 100644 arch/m68k/include/asm/mcfpci.h
 delete mode 100644 arch/m68k/include/asm/mmu_context_mm.h
 delete mode 100644 arch/m68k/include/asm/mmu_context_no.h
 delete mode 100644 arch/m68k/include/asm/mmu_mm.h
 delete mode 100644 arch/m68k/include/asm/mmu_no.h
 delete mode 100644 arch/m68k/include/asm/module_mm.h
 delete mode 100644 arch/m68k/include/asm/module_no.h
 delete mode 100644 arch/m68k/include/asm/page_offset_mm.h
 delete mode 100644 arch/m68k/include/asm/page_offset_no.h
 delete mode 100644 arch/m68k/include/asm/pci_mm.h
 delete mode 100644 arch/m68k/include/asm/pci_no.h
 delete mode 100644 arch/m68k/include/asm/pgalloc_mm.h
 delete mode 100644 arch/m68k/include/asm/pgalloc_no.h
 delete mode 100644 arch/m68k/include/asm/scatterlist_mm.h
 delete mode 100644 arch/m68k/include/asm/scatterlist_no.h
 delete mode 100644 arch/m68k/include/asm/segment_mm.h
 delete mode 100644 arch/m68k/include/asm/segment_no.h
 delete mode 100644 arch/m68k/include/asm/timex_mm.h
 delete mode 100644 arch/m68k/include/asm/timex_no.h
 delete mode 100644 arch/m68k/include/asm/tlbflush_mm.h
 delete mode 100644 arch/m68k/include/asm/tlbflush_no.h
 delete mode 100644 arch/m68k/include/asm/ucontext_mm.h
 delete mode 100644 arch/m68k/include/asm/ucontext_no.h
 delete mode 100644 arch/m68k/include/asm/unaligned_mm.h
 delete mode 100644 arch/m68k/include/asm/unaligned_no.h
 create mode 100644 arch/m68knommu/platform/coldfire/clk.c
