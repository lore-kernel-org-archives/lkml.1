Return-Path: <linux-kernel-owner+w=401wt.eu-S935187AbZFOVUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187AbZFOVUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935145AbZFOVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:20:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935141AbZFOVUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:20:31 -0400
Date: Mon, 15 Jun 2009 14:19:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
       cl@linux-foundation.org, fengguang.wu@intel.com, linuxram@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Count the number of times zone_reclaim() scans and
 fails
Message-Id: <20090615141912.878168ca.akpm@linux-foundation.org>
In-Reply-To: <1244717273-15176-4-git-send-email-mel@csn.ul.ie>
References: <1244717273-15176-1-git-send-email-mel@csn.ul.ie>
	<1244717273-15176-4-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 11:47:53 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> +		PGSCAN_ZONERECLAIM_FAILED,
> @@ -2492,6 +2492,9 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> +	"zreclaim_failed",

So we have "zonereclaim", "zone_reclaim" and "zreclaim", which isn't
terribly developer-friendly.


This?

--- a/include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
+++ a/include/linux/vmstat.h
@@ -37,7 +37,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 #ifdef CONFIG_NUMA
-		PGSCAN_ZONERECLAIM_FAILED,
+		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
diff -puN mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
+++ a/mm/vmscan.c
@@ -2520,7 +2520,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
 	if (!ret)
-		count_vm_event(PGSCAN_ZONERECLAIM_FAILED);
+		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
 
 	return ret;
 }
diff -puN mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix mm/vmstat.c
--- a/mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
+++ a/mm/vmstat.c
@@ -674,7 +674,7 @@ static const char * const vmstat_text[] 
 	TEXTS_FOR_ZONES("pgscan_direct")
 
 #ifdef CONFIG_NUMA
-	"zreclaim_failed",
+	"zone_reclaim_failed",
 #endif
 	"pginodesteal",
 	"slabs_scanned",
_

