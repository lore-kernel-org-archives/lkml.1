Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYIQQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYIQQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYIQQxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:22 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11733 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbYIQQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:19 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K7CMWD-03-U9H-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/23] AMD IOMMU: replace memset with __GFP_ZERO in alloc_coherent
Date: Wed, 17 Sep 2008 18:52:51 +0200
Message-ID: <1221670377-19295-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0151 (UTC) FILETIME=[D6779B70:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the memset to 0 and use __GFP_ZERO at allocation time instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 963b8bb..65aed6e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1176,11 +1176,11 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	if (!get_device_resources(dev, &iommu, &domain, &devid))
 		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
+	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return 0;
 
-	memset(virt_addr, 0, size);
 	paddr = virt_to_phys(virt_addr);
 
 	if (!iommu || !domain) {
-- 
1.5.6.4


