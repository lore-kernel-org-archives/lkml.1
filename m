Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZEVMOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZEVMOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbZEVMNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:21 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:56799
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757371AbZEVMNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:17 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KK1OLM-04-9W3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] amd-iommu: disable device isolation with CONFIG_IOMMU_STRESS
Date: Fri, 22 May 2009 14:12:49 +0200
Message-ID: <1242994369-28697-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:50.0168 (UTC) FILETIME=[A0292F80:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: test for race conditions in dma_ops related code ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b90a78c..6694112 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -124,8 +124,14 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
+
+#ifdef CONFIG_IOMMU_STRESS
+bool amd_iommu_isolate = false;
+#else
 bool amd_iommu_isolate = true;		/* if true, device isolation is
 					   enabled */
+#endif
+
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
-- 
1.6.3.1


