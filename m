Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYLDRhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYLDRhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbYLDRcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:24 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27818 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbYLDRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:11 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4P9-04-YDP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/19] AMD IOMMU: add domain destroy function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:50 +0100
Message-ID: <1228411916-22668-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0324 (UTC) FILETIME=[34F194C0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function for releasing protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5d56cba..fd42926 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1511,3 +1511,21 @@ out_free:
 
 	return -ENOMEM;
 }
+
+static void amd_iommu_domain_destroy(struct iommu_domain *dom)
+{
+	struct protection_domain *domain = dom->priv;
+
+	if (!domain)
+		return;
+
+	BUG_ON(domain->dev_cnt);
+
+	free_pagetable(domain);
+
+	domain_id_free(domain->id);
+
+	kfree(domain);
+
+	dom->priv = NULL;
+}
-- 
1.5.6.4


