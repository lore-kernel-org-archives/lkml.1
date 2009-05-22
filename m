Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZEVMYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZEVMYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbZEVMWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21911 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbZEVMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:23 -0400
X-BigFish: VPS1(zzzz1202hzzz32i67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KK1P10-01-JR9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/12] amd-iommu: don't free dma adresses below 512MB with CONFIG_IOMMU_STRESS
Date: Fri, 22 May 2009 14:21:33 +0200
Message-ID: <1242994893-28902-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0126 (UTC) FILETIME=[D7DE3E60:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: stress test automatic aperture enlargement code ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 33434c4..04ff5ec 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -824,6 +824,11 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 
 	BUG_ON(i >= APERTURE_MAX_RANGES || range == NULL);
 
+#ifdef CONFIG_IOMMU_STRESS
+	if (i < 4)
+		return;
+#endif
+
 	if (address >= dom->next_address)
 		dom->need_flush = true;
 
-- 
1.6.3.1


