Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZEVMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZEVMHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZEVMHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:07:07 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:46975 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZEVMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:07:04 -0400
X-BigFish: VPS1(zzzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KK1OBF-02-J0S-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Neil Turton <nturton@solarflare.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] amd-iommu: fix the handling of device aliases in the AMD IOMMU driver.
Date: Fri, 22 May 2009 14:06:29 +0200
Message-ID: <1242993991-28613-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
References: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:06:47.0673 (UTC) FILETIME=[C818D690:01C9DAD5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Turton <nturton@solarflare.com>

[ impact: set flags for the right req-id in the device table ]

The devid parameter to set_dev_entry_from_acpi is the requester ID
rather than the device ID since it is used to index the IOMMU device
table.  The handling of IVHD_DEV_ALIAS used to pass the device ID.
This patch fixes it to pass the requester ID.

Signed-off-by: Neil Turton <nturton@solarflare.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 35fc965..53f93db 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -618,7 +618,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 		case IVHD_DEV_ALIAS:
 			devid = e->devid;
 			devid_to = e->ext >> 8;
-			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
+			set_dev_entry_from_acpi(iommu, devid_to, e->flags, 0);
 			amd_iommu_alias_table[devid] = devid_to;
 			break;
 		case IVHD_DEV_ALIAS_RANGE:
-- 
1.6.3.1


