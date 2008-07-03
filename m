Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYGCTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYGCTFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYGCTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:05:22 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:45604 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYGCTFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:05:21 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3FY6N-04-36W-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/6] AMD IOMMU: honor iommu=off instead of amd_iommu=off
Date: Thu, 3 Jul 2008 19:35:09 +0200
Message-ID: <1215106511-12915-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0210 (UTC) FILETIME=[257D5320:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the amd_iommu=off kernel parameter and honors the generic
iommu=off parameter for the same purpose.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 5d9e45c..c54c823 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -101,8 +101,6 @@ struct ivmd_header {
 	u64 range_length;
 } __attribute__((packed));
 
-static int __initdata amd_iommu_disable;
-
 u16 amd_iommu_last_bdf;
 struct list_head amd_iommu_unity_map;
 unsigned amd_iommu_aperture_order = 26;
@@ -686,7 +684,7 @@ int __init amd_iommu_init(void)
 	int i, ret = 0;
 
 
-	if (amd_iommu_disable) {
+	if (no_iommu) {
 		printk(KERN_INFO "AMD IOMMU disabled by kernel command line\n");
 		return 0;
 	}
@@ -831,9 +829,6 @@ void __init amd_iommu_detect(void)
 	if (swiotlb || no_iommu || iommu_detected)
 		return;
 
-	if (amd_iommu_disable)
-		return;
-
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
 #ifdef CONFIG_GART_IOMMU
@@ -846,8 +841,6 @@ void __init amd_iommu_detect(void)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-		if (strcmp(str, "off") == 0)
-			amd_iommu_disable = 1;
 		if (strcmp(str, "isolate") == 0)
 			amd_iommu_isolate = 1;
 	}
-- 
1.5.3.7


