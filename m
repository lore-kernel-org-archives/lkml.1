Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYCAEIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYCAEIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbYCAEGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34398 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679AbYCAEGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:24 -0500
Message-Id: <20080301040622.040635380@sgi.com>
References: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:43 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 09/10] Get rid of __ZONE_COUNT
Content-Disposition: inline; filename=max_zones_get_rid_of___zone_count
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was used to compensate because MAX_NR_ZONES was not available
to the #ifdefs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mmzone.h |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2008-02-29 19:34:28.000000000 -0800
+++ linux-2.6/include/linux/mmzone.h	2008-02-29 19:35:32.000000000 -0800
@@ -189,28 +189,15 @@ enum zone_type {
  * match the requested limits. See gfp_zone() in include/linux/gfp.h
  */
 
-/*
- * Count the active zones.  Note that the use of defined(X) outside
- * #if and family is not necessarily defined so ensure we cannot use
- * it later.  Use __ZONE_COUNT to work out how many shift bits we need.
- */
-#define __ZONE_COUNT (			\
-	  defined(CONFIG_ZONE_DMA)	\
-	+ defined(CONFIG_ZONE_DMA32)	\
-	+ 1				\
-	+ defined(CONFIG_HIGHMEM)	\
-	+ 1				\
-)
-#if __ZONE_COUNT < 2
+#if MAX_NR_ZONES < 2
 #define ZONES_SHIFT 0
-#elif __ZONE_COUNT <= 2
+#elif MAX_NR_ZONES <= 2
 #define ZONES_SHIFT 1
-#elif __ZONE_COUNT <= 4
+#elif MAX_NR_ZONES <= 4
 #define ZONES_SHIFT 2
 #else
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
-#undef __ZONE_COUNT
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */

-- 
