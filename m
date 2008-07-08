Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbYGHMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbYGHMuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbYGHMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:48:15 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50119 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbYGHMsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:48:13 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3OU7R-04-SUF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>,
       Robert Richter <robert.richter@amd.com>,
       Bhavna Sarathy <Bhavna.Sarathy@amd.com>
Subject: [PATCH] AMD IOMMU: ignore detection of GART IOMMU
Date: Tue, 8 Jul 2008 14:47:16 +0200
Message-ID: <1215521236-21269-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 08 Jul 2008 12:47:16.0223 (UTC) FILETIME=[C043A8F0:01C8E0F8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the last IOMMU updates covered a bug in the AMD IOMMU code. The early
detection code does not succeed if the GART is already detected. This patch
fixes this.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Bhavna Sarathy <Bhavna.Sarathy@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 2a13e43..bb02800 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -828,7 +828,7 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 
 void __init amd_iommu_detect(void)
 {
-	if (swiotlb || no_iommu || iommu_detected)
+	if (swiotlb || no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return;
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
-- 
1.5.3.7


