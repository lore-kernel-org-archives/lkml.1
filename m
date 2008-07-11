Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYGKPQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYGKPQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYGKPPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:00 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64638 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYGKPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:14:58 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K3UL0G-04-EOQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/16] AMD IOMMU: remove unneeded initializations from command buffer allocation
Date: Fri, 11 Jul 2008 17:14:29 +0200
Message-ID: <1215789275-20975-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0211 (UTC) FILETIME=[D48C0830:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unneeded initialization from the alloc_command_buffer
function and replaces a memset with __GFP_ZERO.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0f5a911..0124995 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -394,17 +394,15 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
  */
 static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 {
-	u8 *cmd_buf = (u8 *)__get_free_pages(GFP_KERNEL,
+	u8 *cmd_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 			get_order(CMD_BUFFER_SIZE));
-	u64 entry = 0;
+	u64 entry;
 
 	if (cmd_buf == NULL)
 		return NULL;
 
 	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
 
-	memset(cmd_buf, 0, CMD_BUFFER_SIZE);
-
 	entry = (u64)virt_to_phys(cmd_buf);
 	entry |= MMIO_CMD_SIZE_512;
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-- 
1.5.3.7


