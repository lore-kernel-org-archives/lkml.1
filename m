Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZGCIaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZGCIaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZGCIaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:30:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:49872 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZGCIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:30:15 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KM76A4-01-IVW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] amd-iommu: set evt_buf_size correctly
Date: Fri, 3 Jul 2009 10:29:13 +0200
Message-ID: <1246609753-30929-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
References: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2009 08:29:18.0525 (UTC) FILETIME=[5B8C5ED0:01C9FBB8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The setting of this variable got lost during the suspend/resume
implementation.  But keeping this variable zero causes a divide-by-zero
error in the interrupt handler. This patch fixes this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index ec72c77..c1b17e9 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -472,6 +472,8 @@ static u8 * __init alloc_event_buffer(struct amd_iommu *iommu)
 	if (iommu->evt_buf == NULL)
 		return NULL;
 
+	iommu->evt_buf_size = EVT_BUFFER_SIZE;
+
 	return iommu->evt_buf;
 }
 
-- 
1.6.3.3


