Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYGDTRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYGDTRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 15:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYGDTRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 15:17:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYGDTRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 15:17:14 -0400
Date: Fri, 4 Jul 2008 15:16:56 -0400
From: Rik van Riel <riel@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memcg: lru scan fix (Was: 2.6.26-rc8-mm1
Message-ID: <20080704151656.7745bfab@bree.surriel.com>
In-Reply-To: <20080704180226.46436432.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<20080704180226.46436432.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 18:02:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Index: test-2.6.26-rc8-mm1/mm/vmscan.c
> ===================================================================
> --- test-2.6.26-rc8-mm1.orig/mm/vmscan.c
> +++ test-2.6.26-rc8-mm1/mm/vmscan.c
> @@ -1501,6 +1501,8 @@ static unsigned long shrink_zone(int pri
>  	 */
>  	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> +	else if (!scan_global_lru(sc))
> +		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);

Makes sense.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
