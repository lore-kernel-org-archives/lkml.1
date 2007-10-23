Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbXJWPUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbXJWPUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXJWPUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:20:23 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9252 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbXJWPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:20:21 -0400
Date: Tue, 23 Oct 2007 09:20:25 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Bugfix to commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15
To: linux-kernel@vger.kernel.org, Jens@secretlab.ca,
       "Axboe <jens.axboe"@oracle.com, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org
Message-id: <20071023151929.12090.3835.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Fixup for commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15.  Changes to
dma_map_sg where done in asm-x86/dma-mapping_32.h, but were not mirrored
in include/asm-powerpc/dma-mapping.h

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Linus, I cannot build an arch/powerpc kernel without this patch.

Cheers,
g.

 include/asm-powerpc/dma-mapping.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 65be95d..fd33ce4 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -285,9 +285,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i) {
-		BUG_ON(!sg->page);
+		BUG_ON(!sg_page(sg));
 		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
-		sg->dma_address = page_to_bus(sg->page) + sg->offset;
+		sg->dma_address = sg_phys(sg);
 	}
 
 	return nents;

