Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbXCPIxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbXCPIxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXCPIvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:41 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34676 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932488AbXCPIvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:33 -0400
Message-ID: <374035060.55839@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085053.155226000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:07 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] readahead: rename state_based_readahead() to clock_based_readahead()
Content-Disposition: inline; filename=readahead-rename-state_based_readahead-to-clock_based_readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename state_based_readahead() to clock_based_readahead().
It better reflects the property of that readahead method.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -66,7 +66,7 @@ int readahead_hit_rate = 1;
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
-	RA_CLASS_STATE,
+	RA_CLASS_CLOCK,
 	RA_CLASS_CONTEXT,
 	RA_CLASS_CONTEXT_AGGRESSIVE,
 	RA_CLASS_BACKWARD,
@@ -101,7 +101,7 @@ enum ra_event {
 
 #ifdef CONFIG_DEBUG_READAHEAD
 static u32 readahead_debug_level = 1;
-static u32 disable_stateful_method;
+static u32 disable_clock_readahead;
 static const char * const ra_class_name[];
 static void ra_account(struct file_ra_state *ra, enum ra_event e, int pages);
 #  define debug_inc(var)		do { var++; } while (0)
@@ -1115,7 +1115,7 @@ static unsigned long compute_thrashing_t
  * Main function for file_ra_state based read-ahead.
  */
 static unsigned long
-state_based_readahead(struct address_space *mapping, struct file *filp,
+clock_based_readahead(struct address_space *mapping, struct file *filp,
 			struct file_ra_state *ra,
 			struct page *page, pgoff_t offset,
 			unsigned long req_size, unsigned long ra_max)
@@ -1157,7 +1157,7 @@ state_based_readahead(struct address_spa
 	if (page && ra_old + ra_old / 8 >= ra_size)
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-	ra_set_class(ra, RA_CLASS_STATE);
+	ra_set_class(ra, RA_CLASS_CLOCK);
 	ra_set_index(ra, offset, ra->readahead_index);
 	ra_set_size(ra, ra_size, la_size);
 
@@ -1687,8 +1687,8 @@ page_cache_readahead_adaptive(struct add
 	 */
 	if (offset == ra->prev_page + 1 &&
 	    offset == ra->lookahead_index &&
-					!debug_option(disable_stateful_method))
-		return state_based_readahead(mapping, filp, ra, page,
+					!debug_option(disable_clock_readahead))
+		return clock_based_readahead(mapping, filp, ra, page,
 						offset, req_size, ra_max);
 
 	/*
@@ -1788,7 +1788,7 @@ void readahead_cache_hit(struct file_ra_
 static const char * const ra_class_name[] = {
 	"total",
 	"initial",
-	"state",
+	"clock",
 	"context",
 	"contexta",
 	"backward",
@@ -1970,8 +1970,8 @@ static int __init readahead_init(void)
 	debugfs_create_file("events", 0644, root, NULL, &ra_events_fops);
 
 	debugfs_create_u32("debug_level", 0644, root, &readahead_debug_level);
-	debugfs_create_bool("disable_stateful_method", 0644, root,
-			    &disable_stateful_method);
+	debugfs_create_bool("disable_clock_readahead", 0644, root,
+			    &disable_clock_readahead);
 
 	return 0;
 }

--
