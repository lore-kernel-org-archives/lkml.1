Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbXJKGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbXJKGrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXJKGrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:47:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:34977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbXJKGrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sgAFTNtrZcVzk0FcA3p7OZT+8Fa7s7Vu+VqzPwTe56543e+5ltddm+ddxfGf39Mg1YiebL5i9eSG6WVEDq6VTOO8RER2MLjX+zJEEoGz/aPm4JMN8wXnpDDRhzhuQGce6aWJp0UK5jFqsr6aS58P86Bt6hGO6kWr91zY86G0uBM=
Subject: [PATCH] mm: Fix printk format strings
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Oct 2007 08:47:01 +0200
Message-Id: <1192085221.26648.31.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure printk format strings contain no more than a single
line.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 mm/page_alloc.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1a8c595..96f0b33 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -198,13 +198,15 @@ static inline int bad_range(struct zone *zone, struct page *page)
 
 static void bad_page(struct page *page)
 {
-	printk(KERN_EMERG "Bad page state in process '%s'\n"
-		KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
-		KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
-		KERN_EMERG "Backtrace:\n",
-		current->comm, page, (int)(2*sizeof(unsigned long)),
-		(unsigned long)page->flags, page->mapping,
+	printk(KERN_EMERG "Bad page state in process '%s'\n", current->comm);
+	printk(KERN_EMERG
+		"page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n",
+		page, (int) (2 * sizeof(unsigned long)),
+		(unsigned long) page->flags, page->mapping,
 		page_mapcount(page), page_count(page));
+	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
+	printk(KERN_EMERG "Backtrace:\n");
+
 	dump_stack();
 	page->flags &= ~(1 << PG_lru	|
 			1 << PG_private |
@@ -1575,13 +1577,13 @@ void show_free_areas(void)
 		}
 	}
 
-	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
+	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n",
 		global_page_state(NR_ACTIVE),
 		global_page_state(NR_INACTIVE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
-		global_page_state(NR_UNSTABLE_NFS),
+		global_page_state(NR_UNSTABLE_NFS));
+	printk(" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_FREE_PAGES),
 		global_page_state(NR_SLAB_RECLAIMABLE) +
 			global_page_state(NR_SLAB_UNRECLAIMABLE),
-- 
1.5.2.4



