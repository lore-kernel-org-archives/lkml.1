Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYIQQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYIQQyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYIQQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:13 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:64479 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYIQQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:11 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K7CMWC-04-US6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@lemmy.amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/23] AMD IOMMU: use cmd_buf_size when freeing the command buffer
Date: Wed, 17 Sep 2008 18:52:56 +0200
Message-ID: <1221670377-19295-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0229 (UTC) FILETIME=[D6838250:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@lemmy.amd.com>

The command buffer release function uses the CMD_BUF_SIZE macro for
get_order. Replace this with iommu->cmd_buf_size which is more reliable
about the actual size of the buffer.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 5303404..d0ea4d3 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -434,7 +434,8 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	free_pages((unsigned long)iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
+	free_pages((unsigned long)iommu->cmd_buf,
+		   get_order(iommu->cmd_buf_size));
 }
 
 /* allocates the memory where the IOMMU will log its events to */
-- 
1.5.6.4


