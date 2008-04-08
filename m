Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYDHQ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYDHQ1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbYDHQ1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbYDHQ1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:09 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 02/28] x86: delete empty functions from pci-nommu_64.c
Date: Tue,  8 Apr 2008 13:20:44 -0300
Message-Id: <12076716841728-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functions are now called conditionally on their
existence in the struct. So just delete them, instead
of keeping an empty implementation.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-nommu_64.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index 6e33076..90a7c40 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -35,10 +35,6 @@ nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return bus;
 }
 
-static void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
-			int direction)
-{
-}
 
 /* Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scatter-gather version of the
@@ -71,20 +67,9 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
-/* Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-static void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		  int nents, int dir)
-{
-}
-
 const struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
-	.unmap_single = nommu_unmap_single,
 	.map_sg = nommu_map_sg,
-	.unmap_sg = nommu_unmap_sg,
 	.is_phys = 1,
 };
 
-- 
1.5.0.6

