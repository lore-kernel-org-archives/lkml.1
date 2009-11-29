Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZK2L23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZK2L23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZK2L22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:28:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:57340 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750958AbZK2L21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:28:27 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX18aORt8P+galRpyVAnH4uxxfqINtDHfEDZVC6MPQd
	S35BfwiLX7yk8g
Date: Mon, 30 Nov 2009 00:28:31 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] reiser4: some changes from reiser4-2.6.31 patch
Message-Id: <20091130002831.4df557ce.buchner.johannes@gmx.at>
In-Reply-To: <1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
References: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
	<1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
	<1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> from
> http://www.kernel.org/pub/linux/kernel/people/edward/reiser4/reiser4-for-2.6/
I'm sorry, I did not see half of this is already covered by
vfs-take-2add-set_page_dirty_notag.patch. With that part removed,
this patch is only cosmetics now.

---
 fs/reiser4/carry.c     |    2 +-
 fs/reiser4/carry_ops.c |    2 +-
 fs/reiser4/znode.h     |    1 -
 mm/filemap.c           |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

Index: linux/fs/reiser4/carry.c
===================================================================
--- linux.orig/fs/reiser4/carry.c
+++ linux/fs/reiser4/carry.c
@@ -1095,7 +1095,7 @@ static void fatal_carry_error(carry_leve
  *
  * This function itself only manages changes in carry structures and delegates
  * all hard work (allocation of znode for new root, changes of parent and
- * sibling pointers to the reiser4_add_tree_root().
+ * sibling pointers) to the reiser4_add_tree_root().
  *
  * Locking: old tree root is locked by carry at this point. Fake znode is also
  * locked.
Index: linux/fs/reiser4/carry_ops.c
===================================================================
--- linux.orig/fs/reiser4/carry_ops.c
+++ linux/fs/reiser4/carry_ops.c
@@ -2015,7 +2015,7 @@ static int carry_estimate_bitmaps(void)
 		int bytes;
 
 		bytes = capped_height() * (0 +	/* bnode should be added, but
-						 * its is private to bitmap.c,
+						 * it is private to bitmap.c,
 						 * skip for now. */
 					   2 * sizeof(jnode));
 						/* working and commit jnodes */
Index: linux/fs/reiser4/znode.h
===================================================================
--- linux.orig/fs/reiser4/znode.h
+++ linux/fs/reiser4/znode.h
@@ -18,7 +18,6 @@
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/semaphore.h>
 #include <linux/pagemap.h>	/* for PAGE_CACHE_SIZE */
 #include <asm/atomic.h>
 
Index: linux/mm/filemap.c
===================================================================
--- linux.orig/mm/filemap.c
+++ linux/mm/filemap.c
@@ -800,7 +802,6 @@ repeat:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL(find_get_pages);
 
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
@@ -970,6 +971,7 @@ static void shrink_readahead_size_eio(st
 {
 	ra->ra_pages /= 4;
 }
+EXPORT_SYMBOL(find_get_pages);
 
 /**
  * do_generic_file_read - generic file read routine
