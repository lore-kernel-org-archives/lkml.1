Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZACRcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZACRcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 12:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZACRb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 12:31:59 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:13268 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZACRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 12:31:57 -0500
X-BigFish: VPS-23(z21eW5edJz936eQzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KCWOOG-03-FIA-01
Date: Sat, 3 Jan 2009 18:31:31 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: gregkh@suse.de, avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: [GIT PULL] various IOMMU updates for 2.6.29
Message-ID: <20090103173130.GB6103@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Jan 2009 17:31:31.0137 (UTC) FILETIME=[1DBA4310:01C96DC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6680598b44ed3c0052d155522eb21fc5a00de5f3:
  Ingo Molnar (1):
        Disallow gcc versions 3.{0,1}

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git for-linus

The changes include:

  - VT-d updates for 2.6.29
  - multiple device assignment support for KVM from Han Weidong
  - refactoring of the VT-d functions for KVM into a generic iommu api
    and necessary KVM changes (required for amd iommu support in KVM)
  - AMD IOMMU support for the iommu api (makes AMD IOMMU usable for pci
    device assignment in kvm)
  - other AMD IOMMU updates for 2.6.29 including:
    + cleanups and minor improvements
    + a debugfs stats interface

This code touches areas of various subsystem maintainers. Because it
would have required some special care if we merged this code over the
different subsystems I agreed with David Woodhouse and Avi Kivity that I
send you a seperate pull request for this stuff. The iommu api was
reviewed, discussed with and acked by Greg Kroah-Hartman.
Please pull.

Jaswinder Singh Rajput (1):
      AMD IOMMU: prealloc_protection_domains should be static

Joerg Roedel (58):
      KVM: rename vtd.c to iommu.c
      introcude linux/iommu.h for an iommu api
      add frontend implementation for the IOMMU API
      select IOMMU_API when DMAR and/or AMD_IOMMU is selected
      KVM: change KVM to use IOMMU API
      VT-d: adapt domain init and destroy functions for IOMMU API
      VT-d: adapt device attach and detach functions for IOMMU API
      VT-d: adapt domain map and unmap functions for IOMMU API
      VT-d: adapt domain iova_to_phys function for IOMMU API
      VT-d: register functions for the IOMMU API
      VT-d: remove now unused intel_iommu_found function
      AMD IOMMU: rename iommu_map to iommu_map_page
      AMD IOMMU: make dma_ops_free_pagetable generic
      AMD IOMMU: add domain id free function
      AMD IOMMU: refactor completion wait handling into separate functions
      AMD IOMMU: move invalidation command building to a separate function
      AMD IOMMU: don't remove protection domain from iommu_pd_list
      AMD IOMMU: add iommu_flush_domain function
      AMD IOMMU: add protection domain flags
      AMD IOMMU: add checks for dma_ops domain to dma_ops functions
      AMD IOMMU: add device reference counting for protection domains
      AMD IOMMU: rename set_device_domain function
      AMD IOMMU: add device detach helper functions
      AMD IOMMU: add device notifier callback
      AMD IOMMU: add domain cleanup helper function
      AMD IOMMU: add domain init function for IOMMU API
      AMD IOMMU: add domain destroy function for IOMMU API
      AMD IOMMU: add device detach function for IOMMU API
      AMD IOMMU: add device attach function for IOMMU API
      AMD IOMMU: add domain map function for IOMMU API
      AMD IOMMU: add domain unmap function for IOMMU API
      AMD IOMMU: add domain address lookup function for IOMMU API
      AMD IOMMU: register functions for the IOMMU API
      AMD IOMMU: add a domain flag for default domains
      AMD IOMMU: allocate a new protection for hotplugged devices
      AMD IOMMU: use dev_name instead of self-build print_devid
      AMD IOMMU: convert iommu->need_sync to bool
      AMD IOMMU: convert amd_iommu_isolate to bool
      AMD IOMMU: use calc_devid in prealloc_protection_domains
      AMD IOMMU: use dev_name in iommu_enable function
      AMD IOMMU: add Kconfig entry for statistic collection code
      AMD IOMMU: add necessary header defines for stats counting
      AMD IOMMU: add init code for statistic collection
      AMD IOMMU: add stats counter for completion wait events
      AMD IOMMU: add stats counter for map_single requests
      AMD IOMMU: add stats counter for unmap_single requests
      AMD IOMMU: add stats counter for map_sg requests
      AMD IOMMU: add stats counter for unmap_sg requests
      AMD IOMMU: add stats counter for alloc_coherent requests
      AMD IOMMU: add stats counter for free_coherent requests
      AMD IOMMU: add stats counter for cross-page request
      AMD IOMMU: add stats counter for single iommu domain tlb flushes
      AMD IOMMU: add stats counter for domain tlb flushes
      AMD IOMMU: add statistics about allocated io memory
      AMD IOMMU: add statistics about total number of map requests
      kvm/iommu: fix compile warning
      Merge branches 'iommu/api' and 'iommu/amd' into for-linus
      AMD IOMMU: remove now unnecessary #ifdefs

Mark McLoughlin (12):
      intel-iommu: remove some unused struct intel_iommu fields
      intel-iommu: make init_dmars() static
      intel-iommu: move DMA_32/64BIT_PFN into intel-iommu.c
      intel-iommu: move root entry defs from dma_remapping.h
      intel-iommu: move context entry defs out from dma_remapping.h
      intel-iommu: move DMA PTE defs out of dma_remapping.h
      intel-iommu: move struct dmar_domain def out dma_remapping.h
      intel-iommu: move struct device_domain_info out of dma_remapping.h
      intel-iommu: kill off duplicate def of dmar_disabled
      intel-iommu: move iommu_prepare_gfx_mapping() out of dma_remapping.h
      intel-iommu: trivially inline context entry macros
      intel-iommu: trivially inline DMA PTE macros

Mike Day (1):
      intel-iommu: fix bit shift at DOMAIN_FLAG_P2P_MULTIPLE_DEVICES

Weidong Han (17):
      Initialize domain flags to 0
      change P2P domain flags
      Add global iommu list
      Get iommu from g_iommus for deferred flush
      iommu bitmap instead of iommu pointer in dmar_domain
      calculate agaw for each iommu
      iommu coherency
      Add domain flag DOMAIN_FLAG_VIRTUAL_MACHINE
      Add/remove domain device info for virtual machine domain
      Add domain_flush_cache
      Allocation and free functions of virtual machine domain
      Change domain_context_mapping_one for virtual machine domain
      Change intel iommu APIs of virtual machine domain
      Check agaw is sufficient for mapped memory
      KVM: use the new intel iommu APIs
      KVM: support device deassignment
      Deassign device in kvm_free_assgined_device

Yu Zhao (1):
      VT-d: fix segment number being ignored when searching DRHD

 arch/ia64/Kconfig                      |    3 +
 arch/ia64/include/asm/kvm_host.h       |    2 +-
 arch/ia64/kvm/Makefile                 |    4 +-
 arch/ia64/kvm/kvm-ia64.c               |    3 +-
 arch/x86/Kconfig                       |   13 +
 arch/x86/include/asm/amd_iommu_types.h |   61 ++-
 arch/x86/include/asm/kvm_host.h        |    2 +-
 arch/x86/kernel/amd_iommu.c            |  666 ++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c       |   15 +-
 arch/x86/kvm/Makefile                  |    4 +-
 arch/x86/kvm/x86.c                     |    3 +-
 drivers/base/Makefile                  |    1 +
 drivers/base/iommu.c                   |  100 ++++
 drivers/pci/dmar.c                     |   46 +-
 drivers/pci/intel-iommu.c              |  944 +++++++++++++++++++++++++++-----
 include/linux/dma_remapping.h          |  138 +-----
 include/linux/dmar.h                   |    1 -
 include/linux/intel-iommu.h            |   25 +-
 include/linux/iommu.h                  |  112 ++++
 include/linux/kvm_host.h               |   30 +-
 virt/kvm/{vtd.c => iommu.c}            |  135 +++--
 virt/kvm/kvm_main.c                    |   50 ++-
 22 files changed, 1894 insertions(+), 464 deletions(-)
 create mode 100644 drivers/base/iommu.c
 create mode 100644 include/linux/iommu.h
 rename virt/kvm/{vtd.c => iommu.c} (58%)

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

