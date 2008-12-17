Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758761AbYLQL1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYLQL1o (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYLQL1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:27:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58051 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYLQL1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:27:33 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: kill page_queue_congested()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081217202547.FF22.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 17 Dec 2008 20:27:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


==
Subject: [PATCH] mm: kill page_queue_congested()

page_queue_congested() was introduced at 2002.
but it is unused until now at all.

it can be removed.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/swapfile.c |   20 --------------------
 1 file changed, 20 deletions(-)

Index: b/mm/swapfile.c
===================================================================
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1203,26 +1203,6 @@ out:
 	return ret;
 }
 
-#if 0	/* We don't need this yet */
-#include <linux/backing-dev.h>
-int page_queue_congested(struct page *page)
-{
-	struct backing_dev_info *bdi;
-
-	BUG_ON(!PageLocked(page));	/* It pins the swap_info_struct */
-
-	if (PageSwapCache(page)) {
-		swp_entry_t entry = { .val = page_private(page) };
-		struct swap_info_struct *sis;
-
-		sis = get_swap_info_struct(swp_type(entry));
-		bdi = sis->bdev->bd_inode->i_mapping->backing_dev_info;
-	} else
-		bdi = page->mapping->backing_dev_info;
-	return bdi_write_congested(bdi);
-}
-#endif
-
 asmlinkage long sys_swapoff(const char __user * specialfile)
 {
 	struct swap_info_struct * p = NULL;


