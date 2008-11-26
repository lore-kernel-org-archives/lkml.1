Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYKZCZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYKZCZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYKZCY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:24:57 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56170 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYKZCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:24:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, akpm@linux-foundation.org
In-Reply-To: <20081124145057.4211bd46@bree.surriel.com>
References: <20081124145057.4211bd46@bree.surriel.com>
Message-Id: <20081126112329.3CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 26 Nov 2008 11:24:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		/*
> +		 * On large memory systems, scan >> priority can become
> +		 * really large. This is fine for the starting priority;
> +		 * we want to put equal scanning pressure on each zone.
> +		 * However, if the VM has a harder time of freeing pages,
> +		 * with multiple processes reclaiming pages, the total
> +		 * freeing target can get unreasonably large.
> +		 */
> +		if (sc->nr_reclaimed > sc->swap_cluster_max &&
> +			sc->priority < DEF_PRIORITY && !current_is_kswapd())
> +			break;

typo.
this patch can't compile.

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1469,7 +1469,7 @@ static void shrink_zone(int priority, st
 		 * freeing target can get unreasonably large.
 		 */
 		if (sc->nr_reclaimed > sc->swap_cluster_max &&
-		    sc->priority < DEF_PRIORITY && !current_is_kswapd())
+		    priority < DEF_PRIORITY && !current_is_kswapd())
 			break;
 	}
 


