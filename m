Return-Path: <linux-kernel-owner+w=401wt.eu-S2992469AbXDTIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992469AbXDTIKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXDTIKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:10:08 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49908 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992648AbXDTIKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:10:05 -0400
Date: Fri, 20 Apr 2007 10:07:44 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] fix undefined symbol if CONFIG_PAGE_GROUP_BY_MOBILITY
 not set
Message-Id: <20070420100744.cd287042.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/04/2007 10:12:42,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/04/2007 10:12:43,
	Serialize complete at 20/04/2007 10:12:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a fix against the patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch (include in -mm
tree):
The error "page_group_by_mobility_disabled undefinied" occured if
CONFIG_PAGE_GROUP_BY_MOBILITY is not set.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2297,6 +2297,7 @@ void __meminit build_all_zonelists(void)
 	}
 	vm_total_pages = nr_free_pagecache_pages();
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 	/*
 	 * Disable grouping by mobility if the number of pages in the
 	 * system is too low to allow the mechanism to work. It would be
@@ -2313,6 +2314,10 @@ void __meminit build_all_zonelists(void)
 			num_online_nodes(),
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
+#else
+	printk("Built %i zonelists.  Total pages: %ld\n",
+	       num_online_nodes(), vm_total_pages);
+#endif
 }
 
 /*


-- 
Pierre
