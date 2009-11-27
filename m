Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZK0OBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZK0OBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZK0Nzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:55:55 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35616 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZK0Nzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:52 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD1-01-6RK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/34] x86/amd-iommu: Remove iommu_flush_domain function
Date: Fri, 27 Nov 2009 14:55:19 +0100
Message-ID: <1259330145-14865-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0029 (UTC) FILETIME=[5286B6D0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This iommu_flush_tlb_pde function does essentially the same.
So the iommu_flush_domain function is redundant and can be
removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c55aa07..b2c19f4 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -528,20 +528,6 @@ static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
 
 }
 
-/*
- * This function is used to flush the IO/TLB for a given protection domain
- * on every IOMMU in the system
- */
-static void iommu_flush_domain(u16 domid)
-{
-	struct amd_iommu *iommu;
-
-	INC_STATS_COUNTER(domain_flush_all);
-
-	for_each_iommu(iommu)
-		flush_domain_on_iommu(iommu, domid);
-}
-
 void amd_iommu_flush_all_domains(void)
 {
 	struct amd_iommu *iommu;
@@ -1464,7 +1450,7 @@ static void update_domain(struct protection_domain *domain)
 
 	update_device_table(domain);
 	flush_devices_by_domain(domain);
-	iommu_flush_domain(domain->id);
+	iommu_flush_tlb_pde(domain);
 
 	domain->updated = false;
 }
@@ -2377,7 +2363,7 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 		iova  += PAGE_SIZE;
 	}
 
-	iommu_flush_domain(domain->id);
+	iommu_flush_tlb_pde(domain);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
-- 
1.6.5.3


