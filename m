Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbYGQTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbYGQTRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbYGQTRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:17:41 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:53764 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbYGQTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:17:40 -0400
Message-ID: <487F9ACB.3080109@linux.vnet.ibm.com>
Date: Thu, 17 Jul 2008 14:17:31 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [mmtom][BUGFIX] vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
References: <20080717122751.92525032.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080717122751.92525032.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Under memcg, active anon tend not to go to inactive anon.
> This will cause OOM in memcg easily when tons of anon was used at once.
> This check was lacked in split-lru.
> 
> This patch is a fix agaisnt
> vmscan-second-chance-replacement-for-anonymous-pages.patch
> 
> 
> Changelog: v1 -> v2:
>  - avoid adding "else".
> 
> Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> 
>  mm/vmscan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: mmtom-stamp-2008-07-15-15-39/mm/vmscan.c
> ===================================================================
> --- mmtom-stamp-2008-07-15-15-39.orig/mm/vmscan.c
> +++ mmtom-stamp-2008-07-15-15-39/mm/vmscan.c
> @@ -1351,7 +1351,7 @@ static unsigned long shrink_zone(int pri
>  	 * Even if we did not try to evict anon pages at all, we want to
>  	 * rebalance the anon lru active/inactive ratio.
>  	 */
> -	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
> +	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> 
>  	throttle_vm_writeout(sc->gfp_mask);

I have not seen this, but looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
