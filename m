Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYIRQan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYIRQan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYIRQaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:30:35 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58186 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbYIRQae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:30:34 -0400
Date: Fri, 19 Sep 2008 01:29:55 +0900
To: linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Subject: [PATCH] fix an example of scatterlists handling in DMA-API.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919012902J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This example isn't the proper way to handle scatterlists (can't handle
sg chaining).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index d8b63d1..b8e8646 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -337,7 +337,7 @@ With scatterlists, you use the resulting mapping like this:
 	int i, count = dma_map_sg(dev, sglist, nents, direction);
 	struct scatterlist *sg;
 
-	for (i = 0, sg = sglist; i < count; i++, sg++) {
+	for_each_sg(sglist, sg, count, i) {
 		hw_address[i] = sg_dma_address(sg);
 		hw_len[i] = sg_dma_len(sg);
 	}
-- 
1.5.4.2

