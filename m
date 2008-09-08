Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYIHJzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYIHJzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYIHJzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:55:19 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54242 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYIHJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:55:17 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tony.luck@intel.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] swiotlb: use unmap_single instead of swiotlb_unmap_single in swiotlb_free_coherent
Date: Mon,  8 Sep 2008 18:53:49 +0900
Message-Id: <1220867630-1995-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220867630-1995-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220867630-1995-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need any check in swiotlb_unmap_single here. unmap_single is
appropriate.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 2fb485d..bf61c73 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -513,7 +513,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		free_pages((unsigned long) vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		swiotlb_unmap_single (hwdev, dma_handle, size, DMA_TO_DEVICE);
+		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 
 static void
-- 
1.5.5.GIT

