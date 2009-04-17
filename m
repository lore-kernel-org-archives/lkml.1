Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbZDQImN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbZDQImN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbZDQIlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:41:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:41767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560AbZDQIlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="448762650"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 4/5] x86, intr-remap: add option to disable interrupt remapping
Date: Fri, 17 Apr 2009 16:42:15 +0800
Message-Id: <1239957736-6161-5-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add option "nointremap" to disable interrupt remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/pci/intr_remapping.c        |   11 +++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33989d2..843cb66 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1533,6 +1533,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	noinitrd	[RAM] Tells the kernel not to load any configured
 			initial RAM disk.
 
+	nointremap	[X86-64, Intel-IOMMU] Do not enable interrupt
+			remapping.
+
 	nointroute	[IA-64]
 
 	nojitter	[IA64] Disables jitter checking for ITC timers.
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 5c21426..842039e 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -15,6 +15,14 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
+static int disable_intremap;
+static __init int setup_nointremap(char *str)
+{
+	disable_intremap = 1;
+	return 0;
+}
+early_param("nointremap", setup_nointremap);
+
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -506,6 +514,9 @@ int __init intr_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
 
+	if (disable_intremap)
+		return 0;
+
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
-- 
1.6.0.4

