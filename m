Return-Path: <linux-kernel-owner+w=401wt.eu-S933019AbXIJKTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbXIJKTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXIJKTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:19:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43475 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbXIJKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:19:15 -0400
Date: Mon, 10 Sep 2007 19:17:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: shaggy@austin.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [23/35] changes in JFS
Message-Id: <20070910191756.08ae2b94.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in JFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/jfs/jfs_metapage.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/jfs/jfs_metapage.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/jfs/jfs_metapage.c
+++ test-2.6.23-rc4-mm1/fs/jfs/jfs_metapage.c
@@ -113,7 +113,7 @@ static inline int insert_metapage(struct
 	}
 
 	if (mp) {
-		l2mp_blocks = L2PSIZE - page->mapping->host->i_blkbits;
+		l2mp_blocks = L2PSIZE - page_inode(page)->i_blkbits;
 		index = (mp->index >> l2mp_blocks) & (MPS_PER_PAGE - 1);
 		a->mp_count++;
 		a->mp[index] = mp;
@@ -125,7 +125,7 @@ static inline int insert_metapage(struct
 static inline void remove_metapage(struct page *page, struct metapage *mp)
 {
 	struct meta_anchor *a = mp_anchor(page);
-	int l2mp_blocks = L2PSIZE - page->mapping->host->i_blkbits;
+	int l2mp_blocks = L2PSIZE - page_inode(page)->i_blkbits;
 	int index;
 
 	index = (mp->index >> l2mp_blocks) & (MPS_PER_PAGE - 1);
@@ -364,7 +364,7 @@ static int metapage_writepage(struct pag
 {
 	struct bio *bio = NULL;
 	unsigned int block_offset;	/* block offset of mp within page */
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	unsigned int blocks_per_mp = JFS_SBI(inode->i_sb)->nbperpage;
 	unsigned int len;
 	unsigned int xlen;
@@ -484,7 +484,7 @@ skip:
 
 static int metapage_readpage(struct file *fp, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	struct bio *bio = NULL;
 	unsigned int block_offset;
 	unsigned int blocks_per_page = PAGE_CACHE_SIZE >> inode->i_blkbits;

