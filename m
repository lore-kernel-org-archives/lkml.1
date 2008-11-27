Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYK0Plx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYK0Plx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYK0PlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:12 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29882 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0PlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:09 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KB00W8-03-L7F-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] VT-d: add device attach and detach functions for IOMMU API
Date: Thu, 27 Nov 2008 16:40:51 +0100
Message-ID: <1227800454-9555-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0914 (UTC) FILETIME=[88F23E20:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b958b6f..a90c832 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2460,3 +2460,35 @@ static void intel_iommu_domain_destroy(struct iommu_domain *domain)
 	intel_iommu_domain_exit(dmar_domain);
 	domain->priv = NULL;
 }
+
+static int intel_iommu_attach_device(struct iommu_domain *domain,
+				     struct device *dev)
+{
+	struct dmar_domain *dmar_domain;
+	struct pci_dev *pdev;
+
+	dmar_domain = domain->priv;
+	pdev = to_pci_dev(dev);
+
+	if (!pdev)
+		return -EINVAL;
+
+	intel_iommu_context_mapping(dmar_domain, pdev);
+
+	return 0;
+}
+
+static void intel_iommu_detach_device(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct dmar_domain *dmar_domain;
+	struct pci_dev *pdev;
+
+	dmar_domain = domain->priv;
+	pdev = to_pci_dev(dev);
+
+	if (!pdev)
+		return;
+
+	intel_iommu_detach_dev(dmar_domain, pdev->bus->number, pdev->devfn);
+}
-- 
1.5.6.4


