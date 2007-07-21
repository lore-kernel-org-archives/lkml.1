Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXGUEob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXGUEob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXGUEnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:43:51 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49808 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750864AbXGUEnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:43:49 -0400
Message-ID: <384993020.10920@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721044347.008643456@mail.ustc.edu.cn>
References: <20070721044300.909424569@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 12:43:04 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] readahead: remove several readahead macros
Content-Disposition: inline; filename=readahead-macros-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove VM_MAX_CACHE_HIT, MAX_RA_PAGES and MIN_RA_PAGES.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/mm.h |    2 --
 mm/readahead.c     |   10 +---------
 2 files changed, 1 insertion(+), 11 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/mm.h
+++ linux-2.6.22-rc6-mm1/include/linux/mm.h
@@ -1148,8 +1148,6 @@ int write_one_page(struct page *page, in
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
-#define VM_MAX_CACHE_HIT    	256	/* max pages in a row in cache before
-					 * turning readahead off */
 
 int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
--- linux-2.6.22-rc6-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc6-mm1/mm/readahead.c
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
