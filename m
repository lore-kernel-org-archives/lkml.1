Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYLIOY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYLIOY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYLIORH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:07 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41099 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYLIOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:41 -0500
X-BigFish: VPS10(zzzzzzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0KBM4Z6-04-AEN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/21] AMD IOMMU: add domain id free function
Date: Tue, 9 Dec 2008 15:16:02 +0100
Message-ID: <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0849 (UTC) FILETIME=[B4553110:01C95A08]
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
index 85a62e9..11de0f1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -569,6 +569,16 @@ static u16 domain_id_alloc(void)
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


