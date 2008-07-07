Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYGGOnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYGGOnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYGGOn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:43:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34302 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYGGOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:43:26 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3N4VJ-04-IQQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] AMD IOMMU: initialize IOMMU when GART is detected
Date: Mon, 7 Jul 2008 16:42:50 +0200
Message-ID: <1215441770-10314-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 07 Jul 2008 14:42:50.0985 (UTC) FILETIME=[BB4A9D90:01C8E03F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the last IOMMU updates covered a bug in the AMD IOMMU code. The early
detection code does not succeed if the GART is already detected. This patch
fixes this by removing the check for iommu_detected in the early detect code.
On AMD systems only the GART code sets this variable to one beside the AMD
IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 2a13e43..71e13af 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -828,7 +828,7 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 
 void __init amd_iommu_detect(void)
 {
-	if (swiotlb || no_iommu || iommu_detected)
+	if (swiotlb || no_iommu)
 		return;
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
-- 
1.5.3.7


