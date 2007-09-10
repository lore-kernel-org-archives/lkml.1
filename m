Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbXIJK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbXIJK2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXIJK2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:28:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60396 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXIJK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:28:08 -0400
Date: Mon, 10 Sep 2007 19:29:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: hch@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [31/35] changes in
 SYSVFS
Message-Id: <20070910192925.40fe3b5a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handlingi in SYSVFS.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/sysv/dir.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/sysv/dir.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/sysv/dir.c
+++ test-2.6.23-rc4-mm1/fs/sysv/dir.c
@@ -40,7 +40,7 @@ static inline unsigned long dir_pages(st
 
 static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *dir = mapping->host;
 	int err = 0;
 
@@ -221,7 +221,8 @@ got_it:
 	pos = page_offset(page) +
 			(char*)de - (char*)page_address(page);
 	lock_page(page);
-	err = __sysv_write_begin(NULL, page->mapping, pos, SYSV_DIRSIZE,
+	err = __sysv_write_begin(NULL, page_mapping_cache(page),
+				pos, SYSV_DIRSIZE,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
@@ -242,7 +243,7 @@ out_unlock:
 
 int sysv_delete_entry(struct sysv_dir_entry *de, struct page *page)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = (char*)page_address(page);
 	loff_t pos = page_offset(page) + (char *)de - kaddr;
@@ -344,7 +345,7 @@ not_empty:
 void sysv_set_link(struct sysv_dir_entry *de, struct page *page,
 	struct inode *inode)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *dir = mapping->host;
 	loff_t pos = page_offset(page) +
 			(char *)de-(char*)page_address(page);


