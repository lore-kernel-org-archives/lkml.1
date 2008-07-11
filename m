Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbYGKPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbYGKPQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbYGKPPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:03 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64829 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbYGKPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:01 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL0B-04-EOC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/16] AMD IOMMU: remove unnecessary free checks from init code
Date: Fri, 11 Jul 2008 17:14:26 +0200
Message-ID: <1215789275-20975-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0133 (UTC) FILETIME=[D4802150:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary checks before memory is released.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 1f14839..0f5a911 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -417,9 +417,7 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	if (iommu->cmd_buf)
-		free_pages((unsigned long)iommu->cmd_buf,
-				get_order(CMD_BUFFER_SIZE));
+	free_pages((unsigned long)iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
 }
 
 /* sets a specific bit in the device table entry. */
@@ -987,24 +985,19 @@ out:
 	return ret;
 
 free:
-	if (amd_iommu_pd_alloc_bitmap)
-		free_pages((unsigned long)amd_iommu_pd_alloc_bitmap, 1);
+	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap, 1);
 
-	if (amd_iommu_pd_table)
-		free_pages((unsigned long)amd_iommu_pd_table,
-				get_order(rlookup_table_size));
+	free_pages((unsigned long)amd_iommu_pd_table,
+		   get_order(rlookup_table_size));
 
-	if (amd_iommu_rlookup_table)
-		free_pages((unsigned long)amd_iommu_rlookup_table,
-				get_order(rlookup_table_size));
+	free_pages((unsigned long)amd_iommu_rlookup_table,
+		   get_order(rlookup_table_size));
 
-	if (amd_iommu_alias_table)
-		free_pages((unsigned long)amd_iommu_alias_table,
-				get_order(alias_table_size));
+	free_pages((unsigned long)amd_iommu_alias_table,
+		   get_order(alias_table_size));
 
-	if (amd_iommu_dev_table)
-		free_pages((unsigned long)amd_iommu_dev_table,
-				get_order(dev_table_size));
+	free_pages((unsigned long)amd_iommu_dev_table,
+		   get_order(dev_table_size));
 
 	free_iommu_all();
 
-- 
1.5.3.7


