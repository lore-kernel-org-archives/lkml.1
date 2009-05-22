Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZEVMW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZEVMW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbZEVMWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:14 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:16679 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757749AbZEVMWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:12 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 08:22:12 EDT
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KK1OBG-02-J0U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] amd-iommu: make sure only ivmd entries are parsed
Date: Fri, 22 May 2009 14:06:30 +0200
Message-ID: <1242993991-28613-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
References: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:06:47.0705 (UTC) FILETIME=[C81DB890:01C9DAD5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: protect against broken ivrs acpi table ]

The bug never triggered. But it should be fixed to protect against
broken ACPI tables in the future.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 53f93db..a3a2b98 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -906,6 +906,8 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 
 	switch (m->type) {
 	default:
+		kfree(e);
+		return 0;
 	case ACPI_IVMD_TYPE:
 		e->devid_start = e->devid_end = m->devid;
 		break;
-- 
1.6.3.1


