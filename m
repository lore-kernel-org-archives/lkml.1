Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYBPJJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYBPJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYBPJJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:09:44 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59884 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYBPJJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:09:42 -0500
Date: Sat, 16 Feb 2008 18:09:36 +0900
To: linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH] iommu-helper: segment boundary limit should be a power of 2
From: FUJITA Tomonori <tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080216180935E.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The segment boundary limit should be a power of 2 so let's make it
clear.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/iommu-helper.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 495575a..de0eced 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -54,6 +54,8 @@ unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 			       unsigned long align_mask)
 {
 	unsigned long index;
+
+	BUG_ON(!is_power_of_2(boundary_size));
 again:
 	index = find_next_zero_area(map, size, start, nr, align_mask);
 	if (index != -1) {
-- 
1.5.3.7

