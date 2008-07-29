Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYG2Au3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYG2Au3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYG2AuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:50:19 -0400
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:34346 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751263AbYG2AuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:50:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OX/C5lVjJJijc1JuuDxhS2/9BWhfmU1arv3yaCqsNRH6dzVwQZYBkjE/iJCBLtwQFL3vURtBW+KgimvAe43dvYGPVEuyYijeFdw8y5JoJCaFLZ/roBDeSQH3Iii4XZTc;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] PCI code for 2.6.27-rc1
Date: Mon, 28 Jul 2008 17:50:14 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281750.14142.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

It contains quite a few fixes and changes I'd like to get into 2.6.27-rc1,
including several changes from the x86 forest.  See below for the shortlog
& diffstat.

Thanks,
Jesse

Alan Cox (1):
      PCI: add D3 power state avoidance quirk

Bjorn Helgaas (1):
      x86/PCI: use dev_printk when possible

Dmitry Baryshkov (7):
      generic: per-device coherent dma allocator
      x86: use generic per-device dma coherent allocator
      Generic dma-coherent: fix DMA_MEMORY_EXCLUSIVE
      ARM: support generic per-device coherent dma mem
      Sh: use generic per-device coherent dma allocator
      Cris: convert to using generic dma-coherent mem allocator
      dma-coherent: add documentation to new interfaces

Ingo Molnar (2):
      Merge branch 'linus' into core/generic-dma-coherent
      Merge branch 'linus' into core/generic-dma-coherent

Jesse Barnes (4):
      PCI hotplug: fix typo in pcie hotplug output
      PCI: document pci_target_state
      Merge branch 'x86/iommu' of git://git.kernel.org/.../tip/linux-2.6-tip into for-linus
      Merge branch 'core/generic-dma-coherent' of git://git.kernel.org/.../tip/linux-2.6-tip into for-linus

Joerg Roedel (3):
      iommu: add iommu_num_pages helper function
      x86, AMD IOMMU: replace to_pages macro with iommu_num_pages
      x86 gart: replace to_pages macro with iommu_num_pages

Matthew Wilcox (4):
      PCI: rewrite PCI BAR reading code
      PCI: handle 64-bit resources better on 32-bit machines
      PCI MSI: Don't disable MSIs if the mask bit isn't supported
      PCI: fix bogus "'device' may be used uninitialized" warning in pci_slot

Shaohua Li (3):
      PCI: disable ASPM per ACPI FADT setting
      PCI: disable ASPM on pre-1.1 PCIe devices
      PCI: add an option to allow ASPM enabled forcibly


 arch/arm/Kconfig                     |    1 +
 arch/arm/mm/consistent.c             |    8 +
 arch/cris/arch-v32/drivers/Kconfig   |    1 +
 arch/cris/arch-v32/drivers/pci/dma.c |  106 +--------------
 arch/sh/Kconfig                      |    1 +
 arch/sh/mm/consistent.c              |   98 +-------------
 arch/x86/Kconfig                     |    1 +
 arch/x86/kernel/amd_iommu.c          |   13 +-
 arch/x86/kernel/pci-dma.c            |  122 +-----------------
 arch/x86/kernel/pci-gart_64.c        |   11 +-
 arch/x86/pci/fixup.c                 |    3 +-
 arch/x86/pci/i386.c                  |   26 ++--
 arch/x86/pci/irq.c                   |  106 +++++++--------
 arch/x86/pci/numaq_32.c              |    5 +-
 drivers/acpi/pci_slot.c              |   18 +--
 drivers/pci/hotplug/pciehp_hpc.c     |    2 +-
 drivers/pci/msi.c                    |   15 ++-
 drivers/pci/pci-acpi.c               |    7 +
 drivers/pci/pci.c                    |   10 ++
 drivers/pci/pcie/aspm.c              |   32 ++++-
 drivers/pci/probe.c                  |  245 +++++++++++++++++-----------------
 drivers/pci/quirks.c                 |   13 ++
 include/acpi/actbl.h                 |    1 +
 include/asm-arm/dma-mapping.h        |    2 +
 include/asm-cris/dma-mapping.h       |    2 +
 include/asm-generic/dma-coherent.h   |   32 +++++
 include/asm-sh/dma-mapping.h         |    1 +
 include/asm-x86/dma-mapping.h        |   22 +---
 include/linux/iommu-helper.h         |    1 +
 include/linux/pci-aspm.h             |    5 +
 include/linux/pci.h                  |    2 +
 include/linux/pci_regs.h             |    1 +
 init/Kconfig                         |    4 +
 kernel/Makefile                      |    1 +
 kernel/dma-coherent.c                |  154 +++++++++++++++++++++
 lib/iommu-helper.c                   |    8 +
 36 files changed, 512 insertions(+), 568 deletions(-)
 create mode 100644 include/asm-generic/dma-coherent.h
 create mode 100644 kernel/dma-coherent.c
