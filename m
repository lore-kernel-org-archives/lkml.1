Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXIJJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXIJJrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbXIJJrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:47:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40619 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbXIJJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:47:15 -0400
Date: Mon, 10 Sep 2007 18:49:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [5/35] changes in AFS
Message-Id: <20070910184909.9644ee8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page->mapping interface in AFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/afs/file.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/afs/file.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/afs/file.c
+++ test-2.6.23-rc4-mm1/fs/afs/file.c
@@ -145,7 +145,7 @@ static int afs_readpage(struct file *fil
 	off_t offset;
 	int ret;
 
-	inode = page->mapping->host;
+	inode = page_inode(page);
 
 	ASSERT(file != NULL);
 	key = file->private_data;
@@ -253,8 +253,7 @@ static void afs_invalidatepage(struct pa
 
 			ret = 0;
 			if (!PageWriteback(page))
-				ret = page->mapping->a_ops->releasepage(page,
-									0);
+				ret = page_mapping_cache(page)->a_ops->releasepage(page, 0);
 			/* possibly should BUG_ON(!ret); - neilb */
 		}
 	}
@@ -277,7 +276,7 @@ static int afs_launder_page(struct page 
  */
 static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 {
-	struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
+	struct afs_vnode *vnode = AFS_FS_I(page_inode(page));
 	struct afs_writeback *wb;
 
 	_enter("{{%x:%u}[%lu],%lx},%x",

