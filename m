Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZAEO76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZAEO76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZAEO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:59:45 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:54721 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbZAEO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:59:44 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] unifying ways to handle multiple sets of dma mapping ops
Date: Mon,  5 Jan 2009 23:59:00 +0900
Message-Id: <1231167543-20259-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the final (third) part of the unification of ways to
handle multiple sets of dma mapping API. The whole work consists of
three patchset. This depends on IA64 and X86 preparation patchset:

The patchset for IA64:

http://marc.info/?l=linux-kernel&m=123116676006794&w=2

The patchset for X86:

http://marc.info/?l=linux-kernel&m=123116708307468&w=2

This adds struct dma_map_ops include/linux/dma-mapping.h and coverts
IA64 and X86 to use it (and removes lots of duplication and
workarounds). I use 'dma_map_ops' name instead dma_mapping_ops to just
avoid breaking POWER build. I have no preference.

The second patch converts IA64 and X86 to use struct dma_map_ops.
It's a bit large but pretty boring. The major change for X86 is
converting 'int dir' to 'enum dma_data_direction dir' in DMA mapping
operations. The major changes for IA64 is using map_page and
unmap_page instead of map_single and unmap_single.

=
 arch/ia64/dig/Makefile                        |    4 +-
 arch/ia64/dig/dig_vtd_iommu.c                 |   59 --------
 arch/ia64/hp/common/hwsw_iommu.c              |  165 ++--------------------
 arch/ia64/hp/common/sba_iommu.c               |   79 ++++++++---
 arch/ia64/include/asm/dma-mapping.h           |  189 ++++++++++++++-----------
 arch/ia64/include/asm/machvec.h               |  107 ++------------
 arch/ia64/include/asm/machvec_dig_vtd.h       |   20 ---
 arch/ia64/include/asm/machvec_hpzx1.h         |   23 +---
 arch/ia64/include/asm/machvec_hpzx1_swiotlb.h |   27 +----
 arch/ia64/include/asm/machvec_sn2.h           |   27 +----
 arch/ia64/kernel/Makefile                     |    4 +-
 arch/ia64/kernel/dma-mapping.c                |   10 ++
 arch/ia64/kernel/machvec.c                    |    8 +-
 arch/ia64/kernel/pci-dma.c                    |   52 ++++---
 arch/ia64/kernel/pci-swiotlb.c                |   23 ++-
 arch/ia64/sn/pci/pci_dma.c                    |   99 +++++++------
 arch/x86/include/asm/device.h                 |    2 +-
 arch/x86/include/asm/dma-mapping.h            |  149 ++++++++------------
 arch/x86/include/asm/iommu.h                  |    2 +-
 arch/x86/kernel/amd_iommu.c                   |   24 ++--
 arch/x86/kernel/pci-calgary_64.c              |   38 +++---
 arch/x86/kernel/pci-dma.c                     |    4 +-
 arch/x86/kernel/pci-gart_64.c                 |   34 +++--
 arch/x86/kernel/pci-nommu.c                   |   21 ++--
 arch/x86/kernel/pci-swiotlb_64.c              |   17 +--
 drivers/pci/intel-iommu.c                     |   31 +++-
 include/linux/dma-mapping.h                   |   48 +++++++
 include/linux/intel-iommu.h                   |    6 +-
 include/linux/swiotlb.h                       |   39 +++---
 lib/swiotlb.c                                 |   66 ++++-----
 30 files changed, 569 insertions(+), 808 deletions(-)



