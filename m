Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbYK0PnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbYK0PnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYK0Pl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:27 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:30447 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYK0PlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:16 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KB00W6-03-L78-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] select IOMMU_API when DMAR and/or AMD_IOMMU is selected
Date: Thu, 27 Nov 2008 16:40:49 +0100
Message-ID: <1227800454-9555-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0828 (UTC) FILETIME=[88E51EC0:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two IOMMUs can implement the current version of this API. So
select the API if one or both of these IOMMU drivers is selected.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/Kconfig     |    3 +++
 arch/x86/Kconfig      |    3 +++
 drivers/base/Makefile |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 6bd91ed..6a7b0c9 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -687,3 +687,6 @@ config IRQ_PER_CPU
 
 config IOMMU_HELPER
 	def_bool (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC || SWIOTLB)
+
+config IOMMU_API
+	def_bool (DMAR)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..b9f7187 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -580,6 +580,9 @@ config SWIOTLB
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
 
+config IOMMU_API
+	def_bool (AMD_IOMMU || DMAR)
+
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && BROKEN
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index c666373..b5b8ba5 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
+obj-$(CONFIG_IOMMU_API) += iommu.o
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
-- 
1.5.6.4


