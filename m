Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZCWH6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZCWH6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZCWH6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:58:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:44378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbZCWH6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:58:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,407,1233561600"; 
   d="scan'208";a="396704167"
From: Yu Zhao <yu.zhao@intel.com>
To: dwmw2@infradead.org, jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v4 0/6] PCI: support the ATS capability
Date: Mon, 23 Mar 2009 15:58:56 +0800
Message-Id: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements Address Translation Service support for
the Intel IOMMU. The PCIe Endpoint that supports ATS capability can
request the DMA address translation from the IOMMU and cache the
translation itself. This can alleviate IOMMU TLB pressure and improve
the hardware performance in the I/O virtualization environment.

The ATS is one of PCI-SIG I/O Virtualization (IOV) Specifications. The
spec can be found at: http://www.pcisig.com/specifications/iov/ats/
(it requires membership).


Changelog:
v3 -> v4
  1, coding style fixes (Grant Grundler)
  2, support the Virtual Function ATS capability

v2 -> v3
  1, throw error message if VT-d hardware detects invalid descriptor
     on Queued Invalidation interface (David Woodhouse)
  2, avoid using pci_find_ext_capability every time when reading ATS
     Invalidate Queue Depth (Matthew Wilcox)

v1 -> v2
  added 'static' prefix to a local LIST_HEAD (Andrew Morton)


Yu Zhao (6):
  PCI: support the ATS capability
  PCI: handle Virtual Function ATS enabling
  VT-d: parse ATSR in DMA Remapping Reporting Structure
  VT-d: add device IOTLB invalidation support
  VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
  VT-d: support the device IOTLB

 drivers/pci/dmar.c          |  189 +++++++++++++++++++++++++++++++++++++++---
 drivers/pci/intel-iommu.c   |  139 ++++++++++++++++++++++++++------
 drivers/pci/iov.c           |  155 ++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.h           |   39 +++++++++
 include/linux/dmar.h        |    9 ++
 include/linux/intel-iommu.h |   16 ++++-
 include/linux/pci.h         |    2 +
 include/linux/pci_regs.h    |   10 +++
 8 files changed, 514 insertions(+), 45 deletions(-)

