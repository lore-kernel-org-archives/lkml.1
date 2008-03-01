Return-Path: <linux-kernel-owner+w=401wt.eu-S1761871AbYCAEJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871AbYCAEJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbYCAEGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:58168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882AbYCAEGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:24 -0500
Message-Id: <20080301040621.791429355@sgi.com>
References: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:42 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 08/10] Export NR_MAX_ZONES to the preprocessor
Content-Disposition: inline; filename=bounds_nr_max_zones
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/bounds.h |    1 +
 include/linux/mmzone.h |    3 ++-
 kernel/bounds.c        |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2008-02-29 18:18:19.000000000 -0800
+++ linux-2.6/include/linux/mmzone.h	2008-02-29 18:20:30.000000000 -0800
@@ -17,6 +17,7 @@
 #include <linux/pageblock-flags.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
+#include <linux/bounds.h>
 
 /* Free memory management - zoned buddy allocator.  */
 #ifndef CONFIG_FORCE_MAX_ZONEORDER
@@ -177,7 +178,7 @@ enum zone_type {
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	MAX_NR_ZONES
+	__MAX_NR_ZONES
 };
 
 /*
Index: linux-2.6/kernel/bounds.c
===================================================================
--- linux-2.6.orig/kernel/bounds.c	2008-02-29 18:18:19.000000000 -0800
+++ linux-2.6/kernel/bounds.c	2008-02-29 18:18:53.000000000 -0800
@@ -14,4 +14,5 @@
 void foo(void)
 {
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
+	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 }
Index: linux-2.6/include/linux/bounds.h
===================================================================
--- linux-2.6.orig/include/linux/bounds.h	2008-02-29 18:18:19.000000000 -0800
+++ linux-2.6/include/linux/bounds.h	2008-02-29 18:20:32.000000000 -0800
@@ -8,5 +8,6 @@
  */
 
 #define NR_PAGEFLAGS 32 /* __NR_PAGEFLAGS	# */
+#define MAX_NR_ZONES 4 /* __MAX_NR_ZONES	# */
 
 #endif

-- 
