Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYGKPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYGKPSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYGKPPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:13 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5816 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636AbYGKPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:07 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K3UL0H-03-1OW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/16] AMD IOMMU: do runtime list initialization at compile time
Date: Fri, 11 Jul 2008 17:14:31 +0200
Message-ID: <1215789275-20975-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0258 (UTC) FILETIME=[D4933420:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the list initialization for the iommu list and the unity map
list from runtime to compile time.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 316fe2e..0c24703 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -118,12 +118,12 @@ static int __initdata amd_iommu_detected;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
-struct list_head amd_iommu_unity_map;	/* a list of required unity mappings
+LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
 int amd_iommu_isolate;			/* if 1, device isolation is enabled */
 
-struct list_head amd_iommu_list;	/* list of all AMD IOMMUs in the
+LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
 
 /*
@@ -673,8 +673,6 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	struct amd_iommu *iommu;
 	int ret;
 
-	INIT_LIST_HEAD(&amd_iommu_list);
-
 	end += table->length;
 	p += IVRS_HEADER_LENGTH;
 
@@ -780,8 +778,6 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 	u8 *p = (u8 *)table, *end = (u8 *)table;
 	struct ivmd_header *m;
 
-	INIT_LIST_HEAD(&amd_iommu_unity_map);
-
 	end += table->length;
 	p += IVRS_HEADER_LENGTH;
 
-- 
1.5.3.7


