Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZEVMHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZEVMHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZEVMHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:07:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48223 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbZEVMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:07:31 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KK1OBA-01-JCG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Neil Turton <nturton@solarflare.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] amd-iommu: fix an off-by-one error in the AMD IOMMU driver.
Date: Fri, 22 May 2009 14:06:28 +0200
Message-ID: <1242993991-28613-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
References: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:06:47.0611 (UTC) FILETIME=[C80F60B0:01C9DAD5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Turton <nturton@solarflare.com>

[ impact: bugfix ]

The variable amd_iommu_last_bdf holds the maximum bdf of any device
controlled by an IOMMU, so the number of device entries needed is
amd_iommu_last_bdf+1.  The function tbl_size used amd_iommu_last_bdf
instead.  This would be a problem if the last device were a large
enough power of 2.

Signed-off-by: Neil Turton <nturton@solarflare.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..35fc965 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -175,7 +175,7 @@ static inline void update_last_devid(u16 devid)
 static inline unsigned long tbl_size(int entry_size)
 {
 	unsigned shift = PAGE_SHIFT +
-			 get_order(amd_iommu_last_bdf * entry_size);
+			 get_order(((int)amd_iommu_last_bdf + 1) * entry_size);
 
 	return 1UL << shift;
 }
-- 
1.6.3.1


