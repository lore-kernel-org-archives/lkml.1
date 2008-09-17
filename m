Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYIQQ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYIQQ7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbYIQQx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:29 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53420 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbYIQQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:25 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7CMW8-04-URY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/23] AMD IOMMU: save pci segment from ACPI tables
Date: Wed, 17 Sep 2008 18:52:41 +0200
Message-ID: <1221670377-19295-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0010 (UTC) FILETIME=[D66217A0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pci_seg field to the amd_iommu structure and fills
it with the corresponding value from the ACPI table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c  |    1 +
 include/asm-x86/amd_iommu_types.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index a902eb6..aa26e37 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -677,6 +677,7 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	 */
 	iommu->devid = h->devid;
 	iommu->cap_ptr = h->cap_ptr;
+	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
 	iommu->mmio_base = iommu_map_mmio_space(h->mmio_phys);
 	if (!iommu->mmio_base)
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index eabc316..eb4d47a 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -232,6 +232,9 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/* pci domain of this IOMMU */
+	u16 pci_seg;
+
 	/* first device this IOMMU handles. read from PCI */
 	u16 first_device;
 	/* last device this IOMMU handles. read from PCI */
-- 
1.5.6.4


