Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYIHJMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYIHJMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYIHJMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:12:00 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48040 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbYIHJL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:11:59 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, joerg.roedel@amd.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 5/5] swiotlb: remove GFP_DMA hack in swiotlb_alloc_coherent
Date: Mon,  8 Sep 2008 18:10:14 +0900
Message-Id: <1220865014-1169-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220865014-1169-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers are supposed to set up the gfp flags appropriately.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 977edbd..3066ffe 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -467,13 +467,6 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	void *ret;
 	int order = get_order(size);
 
-	/*
-	 * XXX fix me: the DMA API should pass us an explicit DMA mask
-	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
-	 * bit range instead of a 16MB one).
-	 */
-	flags |= GFP_DMA;
-
 	ret = (void *)__get_free_pages(flags, order);
 	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
 		/*
-- 
1.5.5.GIT

