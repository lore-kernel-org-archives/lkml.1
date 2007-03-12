Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXCLVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXCLVUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXCLVTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:19:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45691 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXCLVTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:19:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] mm: Remove unused page flags
Date: Mon, 12 Mar 2007 22:20:56 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703122214.02657.rjw@sisk.pl>
In-Reply-To: <200703122214.02657.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122220.56714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the two page flags that were previously used by swsusp and are no longer
needed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 include/linux/page-flags.h |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux-2.6.21-rc3/include/linux/page-flags.h
===================================================================
--- linux-2.6.21-rc3.orig/include/linux/page-flags.h
+++ linux-2.6.21-rc3/include/linux/page-flags.h
@@ -82,13 +82,11 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
-#define PG_nosave		13	/* Used for system suspend/resume */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
-#define PG_nosave_free		18	/* Used for system suspend/resume */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
@@ -214,16 +212,6 @@ static inline void SetPageUptodate(struc
 		ret;							\
 	})
 
-#define PageNosave(page)	test_bit(PG_nosave, &(page)->flags)
-#define SetPageNosave(page)	set_bit(PG_nosave, &(page)->flags)
-#define TestSetPageNosave(page)	test_and_set_bit(PG_nosave, &(page)->flags)
-#define ClearPageNosave(page)		clear_bit(PG_nosave, &(page)->flags)
-#define TestClearPageNosave(page)	test_and_clear_bit(PG_nosave, &(page)->flags)
-
-#define PageNosaveFree(page)	test_bit(PG_nosave_free, &(page)->flags)
-#define SetPageNosaveFree(page)	set_bit(PG_nosave_free, &(page)->flags)
-#define ClearPageNosaveFree(page)		clear_bit(PG_nosave_free, &(page)->flags)
-
 #define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
 #define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
 #define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
