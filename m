Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXIJKau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXIJKau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXIJKal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:30:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36243 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbXIJKak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:30:40 -0400
Date: Mon, 10 Sep 2007 19:32:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: bfennema@falcon.csc.calpoly.edu, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [32/35] changes in
 UDFFS
Message-Id: <20070910193204.952dc9d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in UDFFS

Signed-off-by: KAMEZAWA hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/udf/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/udf/file.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/udf/file.c
+++ test-2.6.23-rc4-mm1/fs/udf/file.c
@@ -43,7 +43,7 @@
 
 static int udf_adinicb_readpage(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	char *kaddr;
 
 	BUG_ON(!PageLocked(page));
@@ -61,7 +61,7 @@ static int udf_adinicb_readpage(struct f
 
 static int udf_adinicb_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	char *kaddr;
 
 	BUG_ON(!PageLocked(page));
Index: test-2.6.23-rc4-mm1/fs/udf/symlink.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/udf/symlink.c
+++ test-2.6.23-rc4-mm1/fs/udf/symlink.c
@@ -73,7 +73,7 @@ static void udf_pc_to_char(struct super_
 
 static int udf_symlink_filler(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	struct buffer_head *bh = NULL;
 	char *symlink;
 	int err = -EIO;

