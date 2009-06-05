Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZFEOdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZFEOdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZFEOds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:33:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:55299 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFEOdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NRUNwmU23JJKDramv724N3ayiAeCG1V7xGWVYxP6Y/VyvjVkNajk+zi+7ss+oHIPLM
         BHZp6cwhhs7gMGHBUaRHN2IEOtw0xKW8bYkExvLaYWZ3hyJOnCzyBeEphWqiwy3I62SL
         DHYBPR8iqMrga5Ffr5a0fsJp2+OZeTRy1cRt8=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH][mmtom] remove file arguement of swap_readpage
Date: Fri,  5 Jun 2009 23:33:43 +0900
Message-Id: <1244212423-18629-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file argument resulted from address_space's readpage
long time ago.

Now we don't use it any more. Let's remove unnecessary
argement.

This patch cleans up swap_readpage.
It doesn't affect behavior of function.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
---
 include/linux/swap.h |    2 +-
 mm/page_io.c         |    2 +-
 mm/swap_state.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2dedc2d..c88b366 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -256,7 +256,7 @@ extern void swap_unplug_io_fn(struct backing_dev_info *, struct page *);
 
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
-extern int swap_readpage(struct file *, struct page *);
+extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 3023c47..c6f3e50 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -120,7 +120,7 @@ out:
 	return ret;
 }
 
-int swap_readpage(struct file *file, struct page *page)
+int swap_readpage(struct page *page)
 {
 	struct bio *bio;
 	int ret = 0;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b62e7f5..42cd38e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -313,7 +313,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			 * Initiate read into locked page and return.
 			 */
 			lru_cache_add_anon(new_page);
-			swap_readpage(NULL, new_page);
+			swap_readpage(new_page);
 			return new_page;
 		}
 		ClearPageSwapBacked(new_page);
-- 
1.5.6.5

