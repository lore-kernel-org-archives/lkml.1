Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbXGEX1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbXGEX1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762961AbXGEXX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:23:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52156 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763215AbXGEXXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:23:24 -0400
Date: Fri, 6 Jul 2007 01:23:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/migrate.c: cleanups
Message-ID: <20070705232353.GI3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- every file should include the headers containing the prototypes for
  its global functions
- make the needlessly global putback_lru_pages() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/migrate.h |    2 --
 mm/migrate.c            |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc6-mm1/include/linux/migrate.h.old	2007-07-05 17:10:01.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/migrate.h	2007-07-05 17:10:10.000000000 +0200
@@ -26,7 +26,6 @@
 }
 
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
-extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x, unsigned long);
@@ -44,7 +43,6 @@
 
 static inline int isolate_lru_page(struct page *p, struct list_head *list)
 					{ return -ENOSYS; }
-static inline int putback_lru_pages(struct list_head *l) { return 0; }
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private) { return -ENOSYS; }
 
--- linux-2.6.22-rc6-mm1/mm/migrate.c.old	2007-07-05 17:10:16.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/migrate.c	2007-07-05 17:11:43.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/mempolicy.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/syscalls.h>
 
 #include "internal.h"
 
@@ -101,7 +102,7 @@
  *
  * returns the number of pages put back.
  */
-int putback_lru_pages(struct list_head *l)
+static int putback_lru_pages(struct list_head *l)
 {
 	struct page *page;
 	struct page *page2;

