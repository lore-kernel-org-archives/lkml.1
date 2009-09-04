Return-Path: <linux-kernel-owner+w=401wt.eu-S933432AbZIDJie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbZIDJie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933421AbZIDJic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:32 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:28604
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933351AbZIDJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:27 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXFW-02-28D-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/8] x86/amd-iommu: Don't detach device from pt domain on driver unbind
Date: Fri, 4 Sep 2009 11:36:33 +0200
Message-ID: <1252056994-31980-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0529 (UTC) FILETIME=[36953F90:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure a device is not detached from the
passthrough domain when the device driver is unloaded or
does otherwise release the device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a8e74c3..12a541d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1195,6 +1195,8 @@ static int device_change_notifier(struct notifier_block *nb,
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 		if (!domain)
 			goto out;
+		if (iommu_pass_through)
+			break;
 		detach_device(domain, devid);
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
-- 
1.6.3.3


