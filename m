Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbYCAEJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbYCAEJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYCAEGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:52 -0500
Received: from relay2.sgi.com ([192.48.171.30]:58165 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751927AbYCAEGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:24 -0500
Message-Id: <20080301040620.758159078@sgi.com>
References: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:38 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 04/10] Pageflags: Eliminate PG_readahead
Content-Disposition: inline; filename=pageflags-elimiate_pg_readahead
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PG_readahead is an alias of PG_reclaim. We can easily drop that now and
alias by specifying PG_reclaim in the macro that generates the functions
for PageReadahead().

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/page-flags.h |    4 +---
 mm/page_alloc.c            |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2008-02-29 19:13:56.000000000 -0800
+++ linux-2.6/mm/page_alloc.c	2008-02-29 19:20:11.000000000 -0800
@@ -623,7 +623,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
+	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-02-29 19:20:03.000000000 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-02-29 19:20:11.000000000 -0800
@@ -85,8 +85,6 @@ enum pageflags {
 	PG_swapcache,		/* Swap page: swp_entry_t in private */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
-	/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
-	PG_readahead = PG_reclaim, /* Reminder to do async read-ahead */
 	PG_buddy,		/* Page is free, on buddy lists */
 	NR_PAGEFLAGS,		/* For verification purposes */
 
@@ -168,7 +166,7 @@ PAGEFLAG(MappedToDisk, mappedtodisk)
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 PAGEFLAG(Reclaim, reclaim) TESTCLEARFLAG(Reclaim, reclaim)
-PAGEFLAG(Readahead, readahead)		/* Reminder to do async read-ahead */
+PAGEFLAG(Readahead, reclaim)		/* Reminder to do async read-ahead */
 
 #ifdef CONFIG_HIGHMEM
 #define PageHighMem(page)	is_highmem(page_zone(page))

-- 
