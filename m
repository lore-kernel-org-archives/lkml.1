Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYLDRfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYLDRfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbYLDRcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:10 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27818 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbYLDRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:08 -0500
X-BigFish: VPS10(zzzzzzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0KBD4P6-04-YDJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/19] AMD IOMMU: add domain id free function
Date: Thu, 4 Dec 2008 18:31:42 +0100
Message-ID: <1228411916-22668-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0074 (UTC) FILETIME=[34CB6F20:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add code to release a domain id

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index bec34fd..b774638 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -568,6 +568,16 @@ static u16 domain_id_alloc(void)
 	return id;
 }
 
+static void domain_id_free(int id)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	if (id > 0 && id < MAX_DOMAIN_ID)
+		__clear_bit(id, amd_iommu_pd_alloc_bitmap);
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+}
+
 /*
  * Used to reserve address ranges in the aperture (e.g. for exclusion
  * ranges.
-- 
1.5.6.4


