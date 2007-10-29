Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXJ2EnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXJ2EnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXJ2Em4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:42:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58528 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbXJ2Em4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:42:56 -0400
Date: Mon, 29 Oct 2007 04:42:55 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] missing atomic_read_long() in slub.c
Message-ID: <20071029044255.GA8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nr_slabs is atomic_long_t, not atomic_t

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/mm/slub.c b/mm/slub.c
index aac1dd3..bcdb2c8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2734,7 +2734,7 @@ static void slab_mem_offline_callback(void *arg)
 			 * and offline_pages() function shoudn't call this
 			 * callback. So, we must fail.
 			 */
-			BUG_ON(atomic_read(&n->nr_slabs));
+			BUG_ON(atomic_long_read(&n->nr_slabs));
 
 			s->node[offline_node] = NULL;
 			kmem_cache_free(kmalloc_caches, n);
