Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYK2Kz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYK2Kz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYK2KzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:55:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35523 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYK2KzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:55:17 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081128231933.8daef193.akpm@linux-foundation.org>
References: <20081128060803.73cd59bd@bree.surriel.com> <20081128231933.8daef193.akpm@linux-foundation.org>
Message-Id: <20081129195357.813D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat, 29 Nov 2008 19:55:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We already tried this, or something very similar in effect, I think...
> 
> 
> commit 26e4931632352e3c95a61edac22d12ebb72038fe
> Author: akpm <akpm>
> Date:   Sun Sep 8 19:21:55 2002 +0000
> 
>     [PATCH] refill the inactive list more quickly
>     
>     Fix a problem noticed by Ed Tomlinson: under shifting workloads the
>     shrink_zone() logic will refill the inactive load too slowly.
>     
>     Bale out of the zone scan when we've reclaimed enough pages.  Fixes a
>     rarely-occurring problem wherein refill_inactive_zone() ends up
>     shuffling 100,000 pages and generally goes silly.
>     
>     This needs to be revisited - we should go on and rebalance the lower
>     zones even if we reclaimed enough pages from highmem.
>     
> 
> 
> Then it was reverted a year or two later:
> 
> 
> commit 265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3
> Author: akpm <akpm>
> Date:   Fri Mar 12 16:23:50 2004 +0000
> 
>     [PATCH] vmscan: zone balancing fix
>     
>     We currently have a problem with the balancing of reclaim between zones: much
>     more reclaim happens against highmem than against lowmem.
>     
>     This patch partially fixes this by changing the direct reclaim path so it
>     does not bale out of the zone walk after having reclaimed sufficient pages
>     from highmem: go on to reclaim from lowmem regardless of how many pages we
>     reclaimed from lowmem.
>     
> 
> My changelog does not adequately explain the reasons.
> 
> But we don't want to rediscover these reasons in early 2010 :(  Some trolling
> of the linux-mm and lkml archives around those dates might help us avoid
> a mistake here.

I hope to digg past discussion archive.
Andrew, plese wait merge this patch awhile.



