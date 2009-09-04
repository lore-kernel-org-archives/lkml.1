Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbZIDJmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbZIDJmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbZIDJmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:19 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:43828 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbZIDJmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KPFXLZ-03-O1O-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/14] x86/amd-iommu: Remove bus_addr check in iommu_map_page
Date: Fri, 4 Sep 2009 11:40:48 +0200
Message-ID: <1252057252-32074-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0595 (UTC) FILETIME=[CCD377B0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver now supports full 64 bit device address spaces.
So this check is not longer required.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ebc1c84..6ffb3e6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -530,8 +530,7 @@ static int iommu_map_page(struct protection_domain *dom,
 	bus_addr  = PAGE_ALIGN(bus_addr);
 	phys_addr = PAGE_ALIGN(phys_addr);
 
-	/* only support 512GB address spaces for now */
-	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
+	if (!(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
 	pte = alloc_pte(dom, bus_addr, NULL, GFP_KERNEL);
-- 
1.6.3.3


