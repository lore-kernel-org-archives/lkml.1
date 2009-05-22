Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZEVImF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZEVImF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZEVIlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:41:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:42752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZEVIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:41:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,232,1241420400"; 
   d="scan'208";a="145786359"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, ebiederm@xmission.com,
       Weidong Han <weidong.han@intel.com>
Subject: [PATCH v3 0/2] Intel-IOMMU: source-id checking for interrupt remapping
Date: Sat, 23 May 2009 00:41:13 +0800
Message-Id: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support source-id checking for interrupt remapping, and then
isolates interrupts for guests/VMs with assigned devices.

Eric raised pci rebalance issue with VT-d. Yes, it's an issue now.
Linux needs to handle pci rebalance changes to DRHD scopes. It's
tricky to support it. This patch just supports source-id for
interrupt remapping, won't touch that.

The patchset can be applied on linux-2.6-tip tree.

v2 -> v3 changelog:
	As Ingo suggested, restructured some code and fixed some code
style issues. 	

v1 -> v2 changelog:
        Access PCI directly (read_pci_config_byte) to parse IOAPIC,
instead of PCI related discovery, because PCI subsystem is not
initialized at that time.


Weidong Han (2):
  Intel-IOMMU, intr-remap: set the whole 128bits of irte when
    modify/free it
  Intel-IOMMU, intr-remap: source-id checking

 arch/x86/kernel/apic/io_apic.c |    6 ++
 drivers/pci/intr_remapping.c   |  160 +++++++++++++++++++++++++++++++++++----
 drivers/pci/intr_remapping.h   |    2 +
 include/linux/dmar.h           |   11 +++
 4 files changed, 162 insertions(+), 17 deletions(-)

