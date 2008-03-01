Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYCAEH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYCAEH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbYCAEGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:47 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34376 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbYCAEGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:23 -0500
Message-Id: <20080301040620.029724488@sgi.com>
References: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:35 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 01/10] Pageflags: Use an enum for the flags
Content-Disposition: inline; filename=pageflags-use-enum
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an enum to ease the maintenance of page flags. This is going to change the
numbering from 0 to 18.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/page-flags.h |   54 ++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-02-29 14:54:22.000000000 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-02-29 15:00:00.000000000 -0800
@@ -67,35 +67,28 @@
  * FLAGS_RESERVED which defines the width of the fields section
  * (see linux/mmzone.h).  New flags must _not_ overlap with this area.
  */
-#define PG_locked	 	 0	/* Page is locked. Don't touch. */
-#define PG_error		 1
-#define PG_referenced		 2
-#define PG_uptodate		 3
-
-#define PG_dirty	 	 4
-#define PG_lru			 5
-#define PG_active		 6
-#define PG_slab			 7	/* slab debug (Suparna wants this) */
-
-#define PG_owner_priv_1		 8	/* Owner use. If pagecache, fs may use*/
-#define PG_arch_1		 9
-#define PG_reserved		10
-#define PG_private		11	/* If pagecache, has fs-private data */
-
-#define PG_writeback		12	/* Page is under writeback */
-#define PG_compound		14	/* Part of a compound page */
-#define PG_swapcache		15	/* Swap page: swp_entry_t in private */
-
-#define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
-#define PG_reclaim		17	/* To be reclaimed asap */
-#define PG_buddy		19	/* Page is free, on buddy lists */
-
-/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
-#define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
-
-/* PG_owner_priv_1 users should have descriptive aliases */
-#define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
-#define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
+enum pageflags {
+	PG_locked,		/* Page is locked. Don't touch. */
+	PG_error,
+	PG_referenced,
+	PG_uptodate,
+	PG_dirty,
+	PG_lru,
+	PG_active,
+	PG_slab,
+	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
+	PG_arch_1,
+	PG_reserved,
+	PG_private,		/* If pagecache, has fs-private data */
+	PG_writeback,		/* Page is under writeback */
+	PG_compound,		/* A compound page */
+	PG_swapcache,		/* Swap page: swp_entry_t in private */
+	PG_mappedtodisk,	/* Has blocks allocated on-disk */
+	PG_reclaim,		/* To be reclaimed asap */
+	/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
+	PG_readahead = PG_reclaim, /* Reminder to do async read-ahead */
+	PG_buddy,		/* Page is free, on buddy lists */
+	NR_PAGEFLAGS,		/* For verification purposes */
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -105,8 +98,9 @@
  * 64 bit  |           FIELDS             | ??????         FLAGS         |
  *         63                            32                              0
  */
-#define PG_uncached		31	/* Page has been mapped as uncached */
+	PG_uncached = 31,		/* Page has been mapped as uncached */
 #endif
+};
 
 /*
  * Manipulation of page state flags

-- 
