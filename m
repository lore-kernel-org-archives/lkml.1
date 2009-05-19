Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZESKcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZESKcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZESKcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:32:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:40240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZESKcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="144423482"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, Weidong Han <weidong.han@intel.com>
Subject: [PATCH v2 0/2] Intel-IOMMU: source-id checking for interrupt remapping
Date: Wed, 20 May 2009 02:31:50 +0800
Message-Id: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support source-id checking for interrupt remapping, and then
isolates interrupts for guests/VMs with assigned devices.

v1 -> v2 change log:
	Access PCI directly (read_pci_config_byte) to parse IOAPIC,
instead of PCI related discovery, because PCI subsystem is not
initialized at that time.

Weidong Han (2):
  Intel-IOMMU, intr-remap: set the whole 128bits of irte when
    modify/free it
  Intel-IOMMU, intr-remap: source-id checking

 arch/x86/kernel/apic/io_apic.c |    6 ++
 drivers/pci/intr_remapping.c   |  100 +++++++++++++++++++++++++++++++++++++--
 drivers/pci/intr_remapping.h   |    2 +
 include/linux/dmar.h           |   11 ++++
 4 files changed, 113 insertions(+), 6 deletions(-)

