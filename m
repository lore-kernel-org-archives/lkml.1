Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbYLDRcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbYLDRcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYLDR31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:27 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:20640 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYLDR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:16 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4K5-03-CR6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/11] select IOMMU_API when DMAR and/or AMD_IOMMU is selected
Date: Thu, 4 Dec 2008 18:28:49 +0100
Message-ID: <1228411736-22644-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0678 (UTC) FILETIME=[C9453060:01C95635]
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


