Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYIQQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYIQQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYIQQx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:27 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5042 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYIQQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:25 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7CMWC-03-U9D-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/23] AMD IOMMU: simplify dma_mask_to_pages
Date: Wed, 17 Sep 2008 18:52:52 +0200
Message-ID: <1221670377-19295-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0167 (UTC) FILETIME=[D67A0C70:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current calculation is very complicated. This patch replaces it with
a much simpler version.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 65aed6e..e38719a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -472,8 +472,7 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  ****************************************************************************/
 static unsigned long dma_mask_to_pages(unsigned long mask)
 {
-	return (mask >> PAGE_SHIFT) +
-		(PAGE_ALIGN(mask & ~PAGE_MASK) >> PAGE_SHIFT);
+	return PAGE_ALIGN(mask) >> PAGE_SHIFT;
 }
 
 /*
-- 
1.5.6.4


