Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXH0UXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXH0UXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbXH0UXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:00 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43333 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911AbXH0UW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:58 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 02/15] nfsd: remove unused cache_for_each macro
Date: Mon, 27 Aug 2007 16:22:43 -0400
Message-Id: <1188246176897-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <1188246176681-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

This macro is unused.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 include/linux/sunrpc/cache.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index 3699dff..bd7a6b0 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -136,16 +136,6 @@ sunrpc_cache_update(struct cache_detail *detail,
 		    struct cache_head *new, struct cache_head *old, int hash);
 
 
-#define cache_for_each(pos, detail, index, member) 						\
-	for (({read_lock(&(detail)->hash_lock); index = (detail)->hash_size;}) ;		\
-	     ({if (index==0)read_unlock(&(detail)->hash_lock); index--;});			\
-		)										\
-		for (pos = container_of((detail)->hash_table[index], typeof(*pos), member);	\
-		     &pos->member;								\
-		     pos = container_of(pos->member.next, typeof(*pos), member))
-
-	     
-
 extern void cache_clean_deferred(void *owner);
 
 static inline struct cache_head  *cache_get(struct cache_head *h)
-- 
1.5.3.rc5.19.g0734d

