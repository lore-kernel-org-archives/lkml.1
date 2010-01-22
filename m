Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577Ab0AVRSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0AVRSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128Ab0AVRS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:18:29 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13903 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0AVRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:18:28 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KWNS2D-02-7F8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 1/5] x86/amd-iommu: Fix possible integer overflow
Date: Fri, 22 Jan 2010 18:18:09 +0100
Message-ID: <1264180693-27197-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
References: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 17:18:15.0657 (UTC) FILETIME=[E235A590:01CA9B86]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable i in this function could be increased to over
2**32 which would result in an integer overflow when using
int. Fix it by changing i to unsigned long.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 23824fe..c2ccbd7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -980,7 +980,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
 	struct amd_iommu *iommu;
-	int i;
+	unsigned long i;
 
 #ifdef CONFIG_IOMMU_STRESS
 	populate = false;
-- 
1.6.6


