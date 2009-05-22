Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZEVMNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZEVMNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZEVMNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:14 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:8445 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756138AbZEVMNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:13 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OLI-03-92P-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] amd-iommu: add dump for iommus described in ivrs table
Date: Fri, 22 May 2009 14:12:44 +0200
Message-ID: <1242994369-28697-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:49.0839 (UTC) FILETIME=[9FF6FBF0:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: get information about iommus described in the ivrs acpi table ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 57fb7a7..2816590 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -748,6 +748,15 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 		h = (struct ivhd_header *)p;
 		switch (*p) {
 		case ACPI_IVHD_TYPE:
+
+			DUMP_printk("IOMMU: device: %02x:%02x.%01x cap: %04x "
+				    "seg: %d flags: %01x info %04x\n",
+				    PCI_BUS(h->devid), PCI_SLOT(h->devid),
+				    PCI_FUNC(h->devid), h->cap_ptr,
+				    h->pci_seg, h->flags, h->info);
+			DUMP_printk("       mmio-addr: %016llx\n",
+				    h->mmio_phys);
+
 			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
 			if (iommu == NULL)
 				return -ENOMEM;
-- 
1.6.3.1


