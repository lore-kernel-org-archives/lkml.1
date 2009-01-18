Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbZAREVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbZAREVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZAREVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:21:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:50781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbZAREVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:21:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,282,1231142400"; 
   d="scan'208";a="101153945"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v2 0/6] ATS capability support for Intel IOMMU
Date: Sun, 18 Jan 2009 12:17:28 +0800
Message-Id: <1232252254-7614-1-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements Address Translation Service support for
the Intel IOMMU. ATS makes the PCI Endpoint be able to request the
DMA address translation from the IOMMU and cache the translation in
the Endpoint, thus alleviate IOMMU pressure and improve the hardware
performance in the I/O virtualization environment.

Changelog: v1 -> v2
  added 'static' prefix to a local LIST_HEAD (Andrew Morton)


Yu Zhao (6):
  PCI: support the ATS capability
  VT-d: parse ATSR in DMA Remapping Reporting Structure
  VT-d: add queue invalidation fault status support
  VT-d: add device IOTLB invalidation support
  VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
  VT-d: support the device IOTLB

 drivers/pci/dmar.c           |  226 ++++++++++++++++++++++++++++++++++++++----
 drivers/pci/intel-iommu.c    |  137 +++++++++++++++++++++-----
 drivers/pci/intr_remapping.c |   21 +++--
 drivers/pci/pci.c            |   68 +++++++++++++
 include/linux/dmar.h         |    9 ++
 include/linux/intel-iommu.h  |   19 +++-
 include/linux/pci.h          |   15 +++
 include/linux/pci_regs.h     |   10 ++
 8 files changed, 450 insertions(+), 55 deletions(-)

