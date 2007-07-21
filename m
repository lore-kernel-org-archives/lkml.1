Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbXGUECT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbXGUECT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXGUD7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:59:03 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54668 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756278AbXGUD6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:58:54 -0400
Message-ID: <384990324.78365@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721035851.461364420@mail.ustc.edu.cn>
References: <20070721035733.951838089@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 11:57:37 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] trivial filemap.c cleanups
Content-Disposition: inline; filename=cleanup-filemap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- remove unused local next_index in do_generic_mapping_read()
- convert some 'unsigned long' to pgoff_t
- wrap a long line

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- linux-2.6.22-git15.orig/mm/filemap.c
+++ linux-2.6.22-git15/mm/filemap.c
@@ -866,11 +866,10 @@ void do_generic_mapping_read(struct addr
 			     read_actor_t actor)
 {
 	struct inode *inode = mapping->host;
-	unsigned long index;
-	unsigned long offset;
-	unsigned long last_index;
-	unsigned long next_index;
-	unsigned long prev_index;
+	pgoff_t index;
+	pgoff_t offset;
+	pgoff_t last_index;
+	pgoff_t prev_index;
 	unsigned int prev_offset;
 	struct page *cached_page;
 	int error;
@@ -878,7 +877,6 @@ void do_generic_mapping_read(struct addr
 
 	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
-	next_index = index;
 	prev_index = ra.prev_pos >> PAGE_CACHE_SHIFT;
 	prev_offset = ra.prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
@@ -1219,7 +1217,8 @@ out:
 }
 EXPORT_SYMBOL(generic_file_aio_read);
 
-int file_send_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size)
+int file_send_actor(read_descriptor_t * desc, struct page *page,
+			unsigned long offset, unsigned long size)
 {
 	ssize_t written;
 	unsigned long count = desc->count;
@@ -1272,7 +1271,6 @@ asmlinkage ssize_t sys_readahead(int fd,
 }
 
 #ifdef CONFIG_MMU
-static int FASTCALL(page_cache_read(struct file * file, unsigned long offset));
 /**
  * page_cache_read - adds requested page to the page cache if not already there
  * @file:	file to read
@@ -1281,7 +1279,7 @@ static int FASTCALL(page_cache_read(stru
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
  */
-static int fastcall page_cache_read(struct file * file, unsigned long offset)
+static int fastcall page_cache_read(struct file * file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *page; 

--
