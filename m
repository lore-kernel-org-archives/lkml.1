Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbZBMCvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbZBMCvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZBMCvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:51:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:61610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZBMCvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:51:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,200,1233561600"; 
   d="scan'208";a="430659328"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Date: Thu, 12 Feb 2009 20:50:32 +0800
Message-Id: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements Address Translation Service support for
the Intel IOMMU. ATS makes the PCI Endpoint be able to request the
DMA address translation from the IOMMU and cache the translation in
the Endpoint, thus alleviate IOMMU pressure and improve the hardware
performance in the I/O virtualization environment.


Changelog: v2 -> v3
  1, throw error message if VT-d hardware detects invalid descriptor
     on Queued Invalidation interface (David Woodhouse)
  2, avoid using pci_find_ext_capability every time when reading ATS
     Invalidate Queue Depth (Matthew Wilcox)
Changelog: v1 -> v2
  added 'static' prefix to a local LIST_HEAD (Andrew Morton)


Yu Zhao (6):
  PCI: support the ATS capability
  VT-d: parse ATSR in DMA Remapping Reporting Structure
  VT-d: add queue invalidation fault status support
  VT-d: add device IOTLB invalidation support
  VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
  VT-d: support the device IOTLB

 drivers/pci/dmar.c           |  230 ++++++++++++++++++++++++++++++++++++++----
 drivers/pci/intel-iommu.c    |  135 ++++++++++++++++++++-----
 drivers/pci/intr_remapping.c |   21 ++--
 drivers/pci/pci.c            |   72 +++++++++++++
 include/linux/dmar.h         |    9 ++
 include/linux/intel-iommu.h  |   19 +++-
 include/linux/pci.h          |   16 +++
 include/linux/pci_regs.h     |   10 ++
 8 files changed, 457 insertions(+), 55 deletions(-)

