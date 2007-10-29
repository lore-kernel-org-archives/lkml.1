Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbXJ2CPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbXJ2CPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXJ2CPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:15:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54306 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbXJ2CPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:15:43 -0400
Date: Mon, 29 Oct 2007 13:15:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] slub: nr_slabs is an atomic_long_t
Message-Id: <20071029131540.13932677.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

so shouldn't be passed to atomic_read.

mm/slub.c: In function 'slab_mem_offline_callback':
mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from incompatible pointer type
mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from incompatible pointer type
mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from incompatible pointer type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Seen on PowerPC allyesconfig build.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

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
-- 
1.5.3.4

