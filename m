Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXCUTQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXCUTQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXCUTQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:16:48 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1779 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805AbXCUTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:16:47 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Hansen <hansendc@us.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] lumpy: move to using pfn_valid_within()
References: <exportbomb.1174504472@pinky>
InReply-To: <exportbomb.1174504472@pinky>
Message-ID: <98524116072c1d68263889385212f639@pinky>
Date: Wed, 21 Mar 2007 19:16:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Switch to using pfn_valid_within() in lumpy reclaim.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c3dc544..cf55c57 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -722,11 +722,10 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			/* The target page is in the block, ignore it. */
 			if (unlikely(pfn == page_pfn))
 				continue;
-#ifdef CONFIG_HOLES_IN_ZONE
+
 			/* Avoid holes within the zone. */
-			if (unlikely(!pfn_valid(pfn)))
+			if (unlikely(!pfn_valid_within(pfn)))
 				break;
-#endif
 
 			cursor_page = pfn_to_page(pfn);
 			/* Check that we have not crossed a zone boundary. */
