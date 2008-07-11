Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbYGKPRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbYGKPRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758782AbYGKPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:08 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5606 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYGKPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:04 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3UL0F-03-1OS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/16] AMD IOMMU: use true/false instead of 0/1 for bool value
Date: Fri, 11 Jul 2008 17:14:30 +0200
Message-ID: <1215789275-20975-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0243 (UTC) FILETIME=[D490EA30:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the integer values used for the bool variable in ACPI
scanning code with true and false.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0124995..316fe2e 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -509,7 +509,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	u8 *end = p, flags = 0;
 	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
 	u32 ext_flags = 0;
-	bool alias = 0;
+	bool alias = false;
 	struct ivhd_entry *e;
 
 	/*
@@ -559,7 +559,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			devid_start = e->devid;
 			flags = e->flags;
 			ext_flags = 0;
-			alias = 0;
+			alias = false;
 			break;
 		case IVHD_DEV_ALIAS:
 			devid = e->devid;
@@ -572,7 +572,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			flags = e->flags;
 			devid_to = e->ext >> 8;
 			ext_flags = 0;
-			alias = 1;
+			alias = true;
 			break;
 		case IVHD_DEV_EXT_SELECT:
 			devid = e->devid;
@@ -582,7 +582,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			devid_start = e->devid;
 			flags = e->flags;
 			ext_flags = e->ext;
-			alias = 0;
+			alias = false;
 			break;
 		case IVHD_DEV_RANGE_END:
 			devid = e->devid;
-- 
1.5.3.7


