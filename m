Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883Ab0ACM1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0ACM1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 07:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829Ab0ACM1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 07:27:40 -0500
Received: from mail2.asahi-net.or.jp ([202.224.39.198]:60800 "EHLO
	mail2.asahi-net.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0ACM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 07:27:39 -0500
X-Greylist: delayed 1343 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2010 07:27:39 EST
Date: Sun, 3 Jan 2010 21:04:35 +0900
From: Kazuhisa Ichikawa <ki@epsilou.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: fix the range check for backward merging
Message-ID: <20100103120435.GA3576@epsilou.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kazuhisa Ichikawa <ki@epsilou.com>

The current check for 'backward merging' within add_active_range()
does not seem correct.  start_pfn must be compared against
early_node_map[i].start_pfn (and NOT against .end_pfn) to find out
whether the new region is backward-mergeable with the existing range.

Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
---
 (This patch applies to linux-2.6.33-rc2)

--- a/mm/page_alloc.c	2009-12-25 06:09:41.000000000 +0900
+++ b/mm/page_alloc.c	2010-01-03 19:20:36.000000000 +0900
@@ -3998,7 +3998,7 @@ void __init add_active_range(unsigned in
 		}
 
 		/* Merge backward if suitable */
-		if (start_pfn < early_node_map[i].end_pfn &&
+		if (start_pfn < early_node_map[i].start_pfn &&
 				end_pfn >= early_node_map[i].start_pfn) {
 			early_node_map[i].start_pfn = start_pfn;
 			return;
