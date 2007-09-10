Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXIJJ6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXIJJ6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXIJJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:57:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57865 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXIJJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:57:51 -0400
Date: Mon, 10 Sep 2007 18:59:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [12/35] changes in
 EXT3
Message-Id: <20070910185907.36ac6079.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change page->mapping handling in EXT3

Signed-off-by:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/ext3/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/ext3/inode.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/ext3/inode.c
+++ test-2.6.23-rc4-mm1/fs/ext3/inode.c
@@ -1484,7 +1484,7 @@ static int journal_dirty_data_fn(handle_
 static int ext3_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	struct buffer_head *page_bufs;
 	handle_t *handle = NULL;
 	int ret = 0;
@@ -1550,7 +1550,7 @@ out_fail:
 static int ext3_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
@@ -1583,7 +1583,7 @@ out_fail:
 static int ext3_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
@@ -1653,7 +1653,7 @@ ext3_readpages(struct file *file, struct
 
 static void ext3_invalidatepage(struct page *page, unsigned long offset)
 {
-	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
+	journal_t *journal = EXT3_JOURNAL(page_inode(page));
 
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
@@ -1666,7 +1666,7 @@ static void ext3_invalidatepage(struct p
 
 static int ext3_releasepage(struct page *page, gfp_t wait)
 {
-	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
+	journal_t *journal = EXT3_JOURNAL(page_inode(page));
 
 	WARN_ON(PageChecked(page));
 	if (!page_has_buffers(page))

