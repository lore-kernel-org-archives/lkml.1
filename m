Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYHUR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYHUR27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYHUR2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:28:50 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5157 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYHUR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:28:49 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K5YOJB-03-SAO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: make gart_alloc_coherent return zeroed memory
Date: Thu, 21 Aug 2008 19:28:27 +0200
Message-ID: <1219339707-30592-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <20080821225038E.fujita.tomonori@lab.ntt.co.jp>
References: <20080821225038E.fujita.tomonori@lab.ntt.co.jp>
X-OriginalArrivalTime: 21 Aug 2008 17:28:27.0663 (UTC) FILETIME=[529A19F0:01C903B3]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_alloc_coherent function should return memory set to zero. This patch
adds this to the GART implementation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 92f5c67..3b5e9e8 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -513,7 +513,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 {
 	void *vaddr;
 
-	vaddr = (void *)__get_free_pages(flag, get_order(size));
+	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
 	if (!vaddr)
 		return NULL;
 
-- 
1.5.3.7


