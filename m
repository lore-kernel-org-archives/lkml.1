Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYJJAAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYJJAAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYJJAAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:00:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYJJAAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:00:01 -0400
Date: Fri, 10 Oct 2008 01:59:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #3 - IOMMU
Message-ID: <20081009235945.GA31581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-v28-for-linus-phase3 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase3

IOMMU updates.

out-of-topic modifications in x86-v28-for-linus-phase3:
-------------------------------------------------------
MAINTAINERS                        # bbd001c: add AMD IOMMU tree to MAINTAINERS
arch/ia64/include/asm/dma-mapping.h# 3a80b6a: ia64: dma_alloc_coherent always u
drivers/char/agp/uninorth-agp.c    # c09ff7e: linux-next: fix x86 tree build fa
include/linux/dma-mapping.h        # 07a2c01: convert swiotlb to use dma_get_ma
                                   # 589fc9a6: iommu: add dma_get_mask helper f
                                   # 636dc67: add is_buffer_dma_capable helper 
include/linux/iommu-helper.h       # 1e19b16: AMD IOMMU: use iommu_device_max_i
                                   # d26dbc5: iommu: export iommu_area_reserve 
                                   # eecfffc: iommu: add iommu_device_max_index
include/linux/pci_ids.h            # 2426824: x86: add PCI IDs for AMD Barcelon
                                   # ca1af29: x86, pci: add northbridge pci ids
kernel/dma-coherent.c              # a38409f: dma-coherent: export dma_[alloc|r
lib/iommu-helper.c                 # d26dbc5: iommu: export iommu_area_reserve 
lib/swiotlb.c                      # 07a2c01: convert swiotlb to use dma_get_ma
                                   # 2797982: swiotlb: convert swiotlb to use i
                                   # 640aebf: swiotlb: add is_swiotlb_buffer he
                                   # 21f6c4d: swiotlb: use unmap_single instead
                                   # 9dfda12: swiotlb: use map_single instead o
                                   # 68e91d6: swiotlb: remove GFP_DMA hack in s

 Thanks,

	Ingo

------------------>
David Woodhouse (1):
      x86: blacklist DMAR on Intel G31/G33 chipsets

FUJITA Tomonori (32):
      dma-mapping.h, x86: remove last user of dma_mapping_ops->map_simple
      x86: dma_*_coherent rework patchset v2, fix
      x86: gart alloc_coherent doesn't need to check NULL device argument
      ia64: dma_alloc_coherent always use GFP_DMA
      x86: move pci-nommu's dma_mask check to common code
      x86: fix nommu_alloc_coherent allocation with NULL device argument
      x86: dma_alloc_coherent sets gfp flags properly
      swiotlb: remove GFP_DMA hack in swiotlb_alloc_coherent
      swiotlb: use map_single instead of swiotlb_map_single in swiotlb_alloc_coherent
      swiotlb: use unmap_single instead of swiotlb_unmap_single in swiotlb_free_coherent
      swiotlb: add is_swiotlb_buffer helper function
      add is_buffer_dma_capable helper function
      x86: convert gart to use is_buffer_dma_capable helper function
      x86: convert pci-nommu to use is_buffer_dma_capable helper function
      swiotlb: convert swiotlb to use is_buffer_dma_capable helper function
      x86: remove duplicated extern force_iommu
      x86: convert dma_alloc_coherent to use is_device_dma_capable
      iommu: add iommu_device_max_index IOMMU helper function
      iommu: add dma_get_mask helper function
      x86: make GART to respect device's dma_mask about virtual mappings
      x86: avoid unnecessary low zone allocation in Calgary's alloc_coherent
      x86: gart alloc_coherent does virtual mapppings only when necessary
      convert swiotlb to use dma_get_mask
      AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
      iommu: export iommu_area_reserve helper function
      x86: remove set_bit_string()
      iommu: remove fullflush and nofullflush in IOMMU generic option
      x86: export pci-nommu's alloc_coherent
      revert "x86: make GART to respect device's dma_mask about virtual mappings"
      x86: restore old GART alloc_coherent behavior
      x86 gart: remove unnecessary initialization
      AMD IOMMU: use iommu_device_max_index

Ingo Molnar (2):
      dma-coherent: export dma_[alloc|release]_from_coherent methods
      x86: add PCI IDs for AMD Barcelona PCI devices

Joerg Roedel (37):
      x86: add alloc_coherent dma_ops callback to GART driver
      x86: add free_coherent dma_ops callback to GART driver
      x86: add free_coherent dma_ops callback to Calgary IOMMU driver
      x86: add alloc_coherent dma_ops callback to NOMMU driver
      x86: add free_coherent dma_ops callback to NOMMU driver
      x86: cleanup dma_*_coherent functions
      x86: move dma_*_coherent functions to include file
      x86, AMD IOMMU: remove obsolete FIXME comment
      x86, pci: add northbridge pci ids for fam 0x11 processors
      x86, gart: add detection of AMD family 0x11 northbridges
      AMD IOMMU: check for invalid device pointers
      AMD IOMMU: move TLB flushing to the map/unmap helper functions
      x86: move GART TLB flushing options to generic code
      AMD IOMMU: implement lazy IO/TLB flushing
      AMD IOMMU: add branch hints to completion wait checks
      AMD IOMMU: align alloc_coherent addresses properly
      AMD IOMMU: add event buffer allocation
      AMD IOMMU: save pci segment from ACPI tables
      AMD IOMMU: save pci_dev instead of devid
      AMD IOMMU: add MSI interrupt support
      AMD IOMMU: add event handling code
      AMD IOMMU: enable event logging
      AMD IOMMU: allow IO page faults from devices
      AMD IOMMU: add dma_supported callback
      AMD IOMMU: don't assign preallocated protection domains to devices
      AMD IOMMU: some set_device_domain cleanups
      AMD IOMMU: replace memset with __GFP_ZERO in alloc_coherent
      AMD IOMMU: simplify dma_mask_to_pages
      AMD IOMMU: free domain bitmap with its allocation order
      AMD IOMMU: remove unnecessary cast to u64 in the init code
      AMD IOMMU: calculate IVHD size with a function
      AMD IOMMU: use cmd_buf_size when freeing the command buffer
      add AMD IOMMU tree to MAINTAINERS file
      AMD IOMMU: use coherent_dma_mask in alloc_coherent
      x86/iommu: make GART driver checkpatch clean
      x86/iommu: convert GART need_flush to bool
      x86/iommu: use __GFP_ZERO instead of memset for GART

Steven Noonan (1):
      x86: unused variable in dma_alloc_coherent_gfp_flags()

Thomas Gleixner (1):
      AMD IOMMU: use iommu_device_max_index, fix


 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |    1 +
 arch/ia64/include/asm/dma-mapping.h |    4 +-
 arch/x86/Kconfig                    |    1 +
 arch/x86/kernel/amd_iommu.c         |  328 ++++++++++++++++++++++++++++-------
 arch/x86/kernel/amd_iommu_init.c    |  194 +++++++++++++++++++--
 arch/x86/kernel/early-quirks.c      |   18 ++
 arch/x86/kernel/k8.c                |    5 +-
 arch/x86/kernel/pci-calgary_64.c    |   18 ++-
 arch/x86/kernel/pci-dma.c           |  177 ++++---------------
 arch/x86/kernel/pci-gart_64.c       |  125 +++++++------
 arch/x86/kernel/pci-nommu.c         |   10 +-
 drivers/pci/intel-iommu.c           |    2 +-
 include/asm-x86/amd_iommu.h         |    3 +
 include/asm-x86/amd_iommu_types.h   |   64 +++++++-
 include/asm-x86/bitops.h            |   10 -
 include/asm-x86/dma-mapping.h       |   87 ++++++++--
 include/asm-x86/gart.h              |    2 +
 include/asm-x86/iommu.h             |    1 +
 include/linux/dma-mapping.h         |   12 ++
 include/linux/iommu-helper.h        |   16 ++
 include/linux/pci_ids.h             |   10 +
 kernel/dma-coherent.c               |    2 +
 lib/iommu-helper.c                  |    5 +-
 lib/swiotlb.c                       |   49 ++---
 25 files changed, 803 insertions(+), 346 deletions(-)

