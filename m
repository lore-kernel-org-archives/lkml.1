Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbZIDJtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbZIDJtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933342AbZIDJtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:49:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:59177
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933375AbZIDJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:49:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KPFXXM-02-2HF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 4/4] x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices
Date: Fri, 4 Sep 2009 11:47:27 +0200
Message-ID: <1252057647-32322-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
References: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:47:29.0468 (UTC) FILETIME=[B797B7C0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amd_iommu_pd_table is indexed by protection domain
number and not by device id. So this check is broken and
must be removed.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 3e62d78..009d722 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -479,8 +479,6 @@ void amd_iommu_flush_all_devices(void)
 	int i;
 
 	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (amd_iommu_pd_table[i] == NULL)
-			continue;
 
 		iommu = amd_iommu_rlookup_table[i];
 		if (!iommu)
-- 
1.6.3.3


