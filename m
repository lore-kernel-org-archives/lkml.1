Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZBAMqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZBAMqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 07:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZBAMqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 07:46:36 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:40452 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752584AbZBAMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 07:46:34 -0500
Message-ID: <498599A6.7080202@snapgear.com>
Date: Sun, 01 Feb 2009 22:46:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: Greg Ungerer <gerg@uclinux.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] [PATCH] m68k: Unify arch/m68k/include/asm/unistd.h
References: <Pine.LNX.4.64.0902011114410.30504@anakin>
In-Reply-To: <Pine.LNX.4.64.0902011114410.30504@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Geert Uytterhoeven wrote:
>>From b708bab9dbc93bc80bd06c9222ab34530736f737 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Thu, 29 Jan 2009 21:21:40 +0100
> Subject: [PATCH] m68k: Unify arch/m68k/include/asm/unistd.h
> 
> arch/m68k/include/asm/unistd_{no,mm}.h are identical, except for whitespace
> differences, so unify them.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Looks good to me.

I started down the track of merging similar headers on Friday too.

So far I have about 12 or so for review at in the git tree below.
(One of which is exactly this unistd.h merge :-)  Still plenty of
easy merges amongst the other files too...


The following changes since commit 18e352e4a73465349711a9324767e1b2453383e2:
   Linus Torvalds (1):
         Linux 2.6.29-rc3

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git 
for-linus

Greg Ungerer (15):
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
       m68k: remove non-mmu unistd.h
       m68k: the one hw_irq.h can be used buy all m68k

  arch/m68k/include/asm/dma-mapping.h    |  113 +++++++++-
  arch/m68k/include/asm/dma-mapping_mm.h |  112 ----------
  arch/m68k/include/asm/dma-mapping_no.h |    6 -
  arch/m68k/include/asm/elf.h            |  120 ++++++++++-
  arch/m68k/include/asm/elf_mm.h         |  119 ----------
  arch/m68k/include/asm/elf_no.h         |  110 ---------
  arch/m68k/include/asm/fpu.h            |   22 ++-
  arch/m68k/include/asm/fpu_mm.h         |   21 --
  arch/m68k/include/asm/fpu_no.h         |   21 --
  arch/m68k/include/asm/hw_irq.h         |    9 +-
  arch/m68k/include/asm/hw_irq_mm.h      |    6 -
  arch/m68k/include/asm/hw_irq_no.h      |    4 -
  arch/m68k/include/asm/kmap_types.h     |   26 ++-
  arch/m68k/include/asm/kmap_types_mm.h  |   21 --
  arch/m68k/include/asm/kmap_types_no.h  |   21 --
  arch/m68k/include/asm/mc146818rtc.h    |   31 +++-
  arch/m68k/include/asm/mc146818rtc_mm.h |   26 ---
  arch/m68k/include/asm/mc146818rtc_no.h |    9 -
  arch/m68k/include/asm/mcfpci.h         |  119 ----------
  arch/m68k/include/asm/mmu.h            |   14 +-
  arch/m68k/include/asm/mmu_mm.h         |    7 -
  arch/m68k/include/asm/mmu_no.h         |   10 -
  arch/m68k/include/asm/pci.h            |   17 +-
  arch/m68k/include/asm/pci_mm.h         |   12 -
  arch/m68k/include/asm/pci_no.h         |   29 ---
  arch/m68k/include/asm/scatterlist.h    |   26 ++-
  arch/m68k/include/asm/scatterlist_mm.h |   23 --
  arch/m68k/include/asm/scatterlist_no.h |   22 --
  arch/m68k/include/asm/timex.h          |   21 ++-
  arch/m68k/include/asm/timex_mm.h       |   18 --
  arch/m68k/include/asm/timex_no.h       |   23 --
  arch/m68k/include/asm/unaligned.h      |   26 ++-
  arch/m68k/include/asm/unaligned_mm.h   |   13 -
  arch/m68k/include/asm/unaligned_no.h   |   25 --
  arch/m68k/include/asm/unistd.h         |  377 
+++++++++++++++++++++++++++++++-
  arch/m68k/include/asm/unistd_mm.h      |  372 
-------------------------------
  arch/m68k/include/asm/unistd_no.h      |  372 
-------------------------------
  arch/m68knommu/kernel/dma.c            |    8 +-
  arch/m68knommu/mm/init.c               |    6 +-
  39 files changed, 763 insertions(+), 1574 deletions(-)
  delete mode 100644 arch/m68k/include/asm/dma-mapping_mm.h
  delete mode 100644 arch/m68k/include/asm/dma-mapping_no.h
  delete mode 100644 arch/m68k/include/asm/elf_mm.h
  delete mode 100644 arch/m68k/include/asm/elf_no.h
  delete mode 100644 arch/m68k/include/asm/fpu_mm.h
  delete mode 100644 arch/m68k/include/asm/fpu_no.h
  delete mode 100644 arch/m68k/include/asm/hw_irq_mm.h
  delete mode 100644 arch/m68k/include/asm/hw_irq_no.h
  delete mode 100644 arch/m68k/include/asm/kmap_types_mm.h
  delete mode 100644 arch/m68k/include/asm/kmap_types_no.h
  delete mode 100644 arch/m68k/include/asm/mc146818rtc_mm.h
  delete mode 100644 arch/m68k/include/asm/mc146818rtc_no.h
  delete mode 100644 arch/m68k/include/asm/mcfpci.h
  delete mode 100644 arch/m68k/include/asm/mmu_mm.h
  delete mode 100644 arch/m68k/include/asm/mmu_no.h
  delete mode 100644 arch/m68k/include/asm/pci_mm.h
  delete mode 100644 arch/m68k/include/asm/pci_no.h
  delete mode 100644 arch/m68k/include/asm/scatterlist_mm.h
  delete mode 100644 arch/m68k/include/asm/scatterlist_no.h
  delete mode 100644 arch/m68k/include/asm/timex_mm.h
  delete mode 100644 arch/m68k/include/asm/timex_no.h
  delete mode 100644 arch/m68k/include/asm/unaligned_mm.h
  delete mode 100644 arch/m68k/include/asm/unaligned_no.h
  delete mode 100644 arch/m68k/include/asm/unistd_mm.h
  delete mode 100644 arch/m68k/include/asm/unistd_no.h


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
