Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZFPI5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZFPI5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZFPI4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:33 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:31761 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755944AbZFPI4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KLBQ5V-01-29I-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/6] amd-iommu: set event buffer head and tail to 0 manually
Date: Tue, 16 Jun 2009 10:56:14 +0200
Message-ID: <1245142575-7166-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0850 (UTC) FILETIME=[4FB801A0:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These registers may contain values from previous kernels. So reset them
to known values before enable the event buffer again.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 48a79b9..068a356 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -486,6 +486,10 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
+
 	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 }
 
-- 
1.6.3.1


