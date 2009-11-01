Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZKAPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZKAPMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZKAPMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:12:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56482 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZKAPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:12:16 -0500
Date: Mon, 2 Nov 2009 00:11:02 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 3/5] vmscan: Stop zone_reclaim()'s wrong swap_cluster_max usage
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20091101234614.F401.A69D9226@jp.fujitsu.com>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
Message-Id: <20091102000951.F407.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In old days, we didn't have sc.nr_to_reclaim and it brought
sc.swap_cluster_max misuse.

huge sc.swap_cluster_max might makes unnecessary OOM and
no performance benefit.

Now, we can remove above dangerous one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9862c04..e463d48 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2455,8 +2455,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
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



