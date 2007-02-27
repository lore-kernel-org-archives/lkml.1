Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXB0Tga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXB0Tga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933081AbXB0Tga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:36:30 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41101 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbXB0Tg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:36:29 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 5/5] lumpy: only check for valid pages when holes are present
References: <exportbomb.1172604830@kernel>
InReply-To: <exportbomb.1172604830@kernel>
Message-ID: <297d400448043264b3e5afe21291485e@kernel>
Date: Tue, 27 Feb 2007 11:36:24 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We only need to check that each page is valid with pfn_valid when
we are on an architecture which had holes within zones.  Make this
check conditional.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bef7e92..f249ad7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -725,9 +725,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			/* The target page is in the block, ignore it. */
 			if (unlikely(pfn == page_pfn))
 				continue;
+#ifdef CONFIG_HOLES_IN_ZONE
 			/* Avoid holes within the zone. */
 			if (unlikely(!pfn_valid(pfn)))
 				break;
+#endif
 
 			cursor_page = pfn_to_page(pfn);
 			/* Check that we have not crossed a zone boundary. */
