Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbXGUEAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbXGUEAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbXGUD67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:58:59 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54676 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755506AbXGUD6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:58:54 -0400
Message-ID: <384990325.05232@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721035851.638623804@mail.ustc.edu.cn>
References: <20070721035733.951838089@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 11:57:38 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] remove several readahead macros
Content-Disposition: inline; filename=readahead-macros-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove VM_MAX_CACHE_HIT, MAX_RA_PAGES and MIN_RA_PAGES.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/mm.h |    2 --
 mm/readahead.c     |   10 +---------
 2 files changed, 1 insertion(+), 11 deletions(-)

--- linux-2.6.22-git15.orig/include/linux/mm.h
+++ linux-2.6.22-git15/include/linux/mm.h
@@ -1136,8 +1136,6 @@ int write_one_page(struct page *page, in
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
-#define VM_MAX_CACHE_HIT    	256	/* max pages in a row in cache before
-					 * turning readahead off */
 
 int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
--- linux-2.6.22-git15.orig/mm/readahead.c
+++ linux-2.6.22-git15/mm/readahead.c
@@ -21,16 +21,8 @@ void default_unplug_io_fn(struct backing
 }
 EXPORT_SYMBOL(default_unplug_io_fn);
 
-/*
- * Convienent macros for min/max read-ahead pages.
- * Note that MAX_RA_PAGES is rounded down, while MIN_RA_PAGES is rounded up.
- * The latter is necessary for systems with large page size(i.e. 64k).
- */
-#define MAX_RA_PAGES	(VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
-#define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
-
 struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= MAX_RA_PAGES,
+	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,

--
