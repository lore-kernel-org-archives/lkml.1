Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZKBPg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZKBPg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbZKBPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:36:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43454 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbZKBPg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:36:28 -0500
Date: Tue, 3 Nov 2009 00:35:30 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCHv2 1/5] vmscan: separate sc.swap_cluster_max and sc.nr_max_reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091102093517.32021780.minchan.kim@barrios-desktop>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com> <20091102093517.32021780.minchan.kim@barrios-desktop>
Message-Id: <20091103001211.8866.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > @@ -1932,6 +1938,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
> >  		.may_unmap = 1,
> >  		.may_swap = 1,
> >  
> 		.swap_cluster_max = SWAP_CLUSTER_MAX,
> Or add comment in here. 
> 
> 'kswapd doesn't want to be bailed out while reclaim.'

OK, reasonable.
How about this?



---
 mm/vmscan.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7fb3435..84e4da0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1930,6 +1930,10 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
 		.may_swap = 1,
+		/*
+		 * kswapd doesn't want to be bailed out while reclaim. because
+		 * we want to put equal scanning pressure on each zone.
+		 */
 		.nr_to_reclaim = ULONG_MAX,
 		.swappiness = vm_swappiness,
 		.order = order,
-- 
1.6.2.5




