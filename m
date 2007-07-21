Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbXGUD75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbXGUD75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbXGUD66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:58:58 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54632 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755441AbXGUD6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:58:54 -0400
Message-ID: <384990324.22217@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721035850.977231489@mail.ustc.edu.cn>
References: <20070721035733.951838089@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 11:57:34 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/8] compacting file_ra_state
Content-Disposition: inline; filename=short-rasize.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'unsigned int' instead of 'unsigned long' for readahead sizes.

This helps reduce memory consumption on 64bit CPU when
a lot of files are opened.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/fs.h |    8 ++++----
 mm/readahead.c     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.22-git15.orig/include/linux/fs.h
+++ linux-2.6.22-git15/include/linux/fs.h
@@ -697,12 +697,12 @@ struct fown_struct {
  * Track a single file's readahead state
  */
 struct file_ra_state {
-	pgoff_t start;                  /* where readahead started */
-	unsigned long size;             /* # of readahead pages */
-	unsigned long async_size;       /* do asynchronous readahead when
+	pgoff_t start;			/* where readahead started */
+	unsigned int size;		/* # of readahead pages */
+	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
-	unsigned long ra_pages;		/* Maximum readahead window */
+	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 	unsigned long prev_index;	/* Cache last read() position */
--- linux-2.6.22-git15.orig/mm/readahead.c
+++ linux-2.6.22-git15/mm/readahead.c
@@ -350,7 +350,7 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	unsigned long max;	/* max readahead pages */
+	int max;	/* max readahead pages */
 	int sequential;
 
 	max = ra->ra_pages;

--
