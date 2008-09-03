Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYICSUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYICSUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYICSTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:19:52 -0400
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:36137 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYICSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:19:51 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: joerg.roedel@amd.com, mingo@redhat.com, tony.luck@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com, iommu@lists.linux-foundation.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] swiotlb: use GFP_DMA32 instead of GFP_DMA in swiotlb_alloc_coherent
Date: Thu,  4 Sep 2008 03:04:25 +0900
Message-Id: <1220465065-10533-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220465065-10533-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
 <1220465065-10533-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220465065-10533-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 sets up gfp flag propely so swiotlb_alloc_coherent doesn't need to
use GFP_DMA unconditionally. It leads to allocation failures in some
systems.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 977edbd..b88d7c2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -467,12 +467,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	void *ret;
 	int order = get_order(size);
 
-	/*
-	 * XXX fix me: the DMA API should pass us an explicit DMA mask
-	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
-	 * bit range instead of a 16MB one).
-	 */
-	flags |= GFP_DMA;
+	flags |= GFP_DMA32;
 
 	ret = (void *)__get_free_pages(flags, order);
 	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
-- 
1.5.5.GIT

