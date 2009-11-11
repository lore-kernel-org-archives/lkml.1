Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZKKCCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZKKCCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZKKCCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:02:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50008 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZKKCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:02:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] vmscan: zone_reclaim() don't use insane swap_cluster_max
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
References: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
Message-Id: <20091111110125.FD44.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 11:02:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In old days, we didn't have sc.nr_to_reclaim and it brought
sc.swap_cluster_max misuse.

huge sc.swap_cluster_max might makes unnecessary OOM risk and
no performance benefit.

Now, we can stop its insane thing.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eebd260..d0422a8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2458,8 +2458,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
-		.swap_cluster_max = max_t(unsigned long, nr_pages,
-				       SWAP_CLUSTER_MAX),
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
-- 
1.6.2.5



