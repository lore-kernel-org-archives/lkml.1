Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYGCRiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYGCRiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYGCRiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:38:00 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:2738 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYGCRh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:37:59 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3FY6K-04-36T-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/6] AMD IOMMU: remove unnecessary set_bit_string
Date: Thu, 3 Jul 2008 19:35:07 +0200
Message-ID: <1215106511-12915-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0091 (UTC) FILETIME=[256B2AB0:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set_bit_string call in the address allocator is not necessary because its
already called in iommu_area_alloc().

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a1b3856..329b2c3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -301,7 +301,6 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 				0, boundary_size, 0);
 
 	if (likely(address != -1)) {
-		set_bit_string(dom->bitmap, address, pages);
 		dom->next_bit = address + pages;
 		address <<= PAGE_SHIFT;
 	} else
-- 
1.5.3.7


