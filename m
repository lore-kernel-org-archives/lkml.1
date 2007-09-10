Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbXIJJpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbXIJJpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXIJJpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:45:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56892 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXIJJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:45:00 -0400
Date: Mon, 10 Sep 2007 18:46:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: zippel@linux-m68k.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [4/35] changes in AFFS
Message-Id: <20070910184615.56a148e0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use page_inode() in AFFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/affs/file.c    |    4 ++--
 fs/affs/symlink.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/affs/file.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/affs/file.c
+++ test-2.6.23-rc4-mm1/fs/affs/file.c
@@ -485,7 +485,7 @@ affs_getemptyblk_ino(struct inode *inode
 static int
 affs_do_readpage_ofs(struct file *file, struct page *page, unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh;
 	char *data;
@@ -593,7 +593,7 @@ out:
 static int
 affs_readpage_ofs(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	u32 to;
 	int err;
 
Index: test-2.6.23-rc4-mm1/fs/affs/symlink.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/affs/symlink.c
+++ test-2.6.23-rc4-mm1/fs/affs/symlink.c
@@ -13,7 +13,7 @@
 static int affs_symlink_readpage(struct file *file, struct page *page)
 {
 	struct buffer_head *bh;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	char *link = kmap(page);
 	struct slink_front *lf;
 	int err;

