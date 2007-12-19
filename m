Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbXLSGT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbXLSGT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 01:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXLSGTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 01:19:22 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52385 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXLSGTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 01:19:21 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 19 Dec 2007 11:48:34 +0530
Message-Id: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
Subject: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in free_hot_cold_page
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Based on the recommendation and observations of Hugh Dickins,
page_cgroup_assign_cgroup() is not required. This patch replaces it with
a VM_BUG_ON, so that we can catch them in free_hot_cold_page()

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-controller-move-to-bug-on-in-free_hot_cold_page mm/page_alloc.c
--- linux-2.6.24-rc5/mm/page_alloc.c~memory-controller-move-to-bug-on-in-free_hot_cold_page	2007-12-19 11:31:46.000000000 +0530
+++ linux-2.6.24-rc5-balbir/mm/page_alloc.c	2007-12-19 11:33:45.000000000 +0530
@@ -995,7 +995,7 @@ static void fastcall free_hot_cold_page(
 
 	if (!PageHighMem(page))
 		debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
-	page_assign_page_cgroup(page, NULL);
+	VM_BUG_ON(page_get_page_cgroup(page));
 	arch_free_page(page, 0);
 	kernel_map_pages(page, 1, 0);
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
