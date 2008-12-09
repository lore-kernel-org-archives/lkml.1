Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYLIO3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYLIO3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYLIORp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:45 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:42800 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYLIORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:17:08 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBM4ZA-04-AET-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/21] AMD IOMMU: fix iommu_map_page function
Date: Tue, 9 Dec 2008 15:15:59 +0100
Message-ID: <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0732 (UTC) FILETIME=[B44356C0:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix in iommu_map_page function

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4db4542..153db6e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -344,7 +344,7 @@ static int iommu_map_page(struct protection_domain *dom,
 	u64 __pte, *pte, *page;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
-	phys_addr = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(phys_addr);
 
 	/* only support 512GB address spaces for now */
 	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
-- 
1.5.6.4


