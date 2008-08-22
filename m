Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYHVWr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYHVWr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYHVWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:47:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:43867 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYHVWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lgpOOwJrIkPXkZvK0+bab6kMEQvYFTrWYyKN8lX/UMamooUodozR4lHke7Y1V52BDJ
         nliDPdzJtX3roP3YItTZOEqTTVt1I8HLSFcbZ+Vl/l6Ft/stum5Q+HjH0q3z0jVskIKH
         7vPGnr9+JEXKpk7w5dk1jTT8HnK4j0zHZ2CfQ=
Subject: [PATCH] mm: hugetlb.c make functions static, use NULL rather than 0
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 15:47:54 -0700
Message-Id: <1219445274.4493.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/hugetlb.c:265:17: warning: symbol 'resv_map_alloc' was not declared. Should it be static?
mm/hugetlb.c:277:6: warning: symbol 'resv_map_release' was not declared. Should it be static?
mm/hugetlb.c:292:9: warning: Using plain integer as NULL pointer
mm/hugetlb.c:1750:5: warning: symbol 'unmap_ref_private' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 mm/hugetlb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 67a7119..b548a94 100644
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
 
@@ -289,7 +289,7 @@ static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 	if (!(vma->vm_flags & VM_SHARED))
 		return (struct resv_map *)(get_vma_private_data(vma) &
 							~HPAGE_RESV_MASK);
-	return 0;
+	return NULL;
 }
 
 static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
@@ -1747,7 +1747,7 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-int unmap_ref_private(struct mm_struct *mm,
+static int unmap_ref_private(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					struct page *page,
 					unsigned long address)
-- 
1.6.0.340.g84854



