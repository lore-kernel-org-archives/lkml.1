Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYGNITg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYGNITg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 04:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYGNIT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 04:19:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44210 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbYGNIT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 04:19:27 -0400
Date: Mon, 14 Jul 2008 17:18:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH][resend] split-lru-memcg page reclaim active anon fix v2
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "riel@redhat.com" <riel@redhat.com>
In-Reply-To: <20080714170359.31198aef.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080714170359.31198aef.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080714171731.F6D6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6.26-rc8-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.26-rc8-mm1.orig/mm/vmscan.c
> +++ linux-2.6.26-rc8-mm1/mm/vmscan.c
> @@ -1499,7 +1499,7 @@ static unsigned long shrink_zone(int pri
>  	 * Even if we did not try to evict anon pages at all, we want to
>  	 * rebalance the anon lru active/inactive ratio.
>  	 */
> -	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
> +	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>  
>  	throttle_vm_writeout(sc->gfp_mask);

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



