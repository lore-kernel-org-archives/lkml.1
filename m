Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYHSNrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYHSNrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYHSNrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:47:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60737 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbYHSNrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:47:08 -0400
Date: Tue, 19 Aug 2008 16:46:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>,
       wli@holomorphy.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/hugetlb.c: make resv_map_{alloc,release}() static
Message-ID: <20080819134657.GD8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global resv_map_{alloc,release}()
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
99bcfd48d93a0c6286b6345f52d10a0a1a43f8c4 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 28a2980..c3bb4d6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -262,7 +262,7 @@ struct resv_map {
 	struct list_head regions;
 };
 
-struct resv_map *resv_map_alloc(void)
+static struct resv_map *resv_map_alloc(void)
 {
 	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
 	if (!resv_map)
@@ -274,7 +274,7 @@ struct resv_map *resv_map_alloc(void)
 	return resv_map;
 }
 
-void resv_map_release(struct kref *ref)
+static void resv_map_release(struct kref *ref)
 {
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
 

