Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYLHCth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYLHCth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYLHCt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:49:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51581 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYLHCtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:49:25 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan: improve reclaim throuput to bail out patch take2
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
In-Reply-To: <20081206192806.7bfba95b.akpm@linux-foundation.org>
References: <20081204102729.1D5C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081206192806.7bfba95b.akpm@linux-foundation.org>
Message-Id: <20081208110909.53E4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  8 Dec 2008 11:49:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think my last explain was too poor.


> If this improved the throughput of direct-reclaim callers then one
> would expect it to make larger improvements for kswapd (assuming 
> that all other things are equal for those tasks, which they are not).
> 
> What is your direct-reclaim to kswapd-reclaim ratio for that workload?
> (grep pgscan /proc/vmstat)
> 

because that benchmark is direct reclaim torturess workload.

/proc/vmstat changing was

<before>
pgscan_kswapd_dma 1152
pgscan_kswapd_normal 2400
pgscan_kswapd_movable 0
pgscan_direct_dma 32
pgscan_direct_normal 512
pgscan_direct_movable 0

<after>
pgscan_kswapd_dma 3520
pgscan_kswapd_normal 12160
pgscan_kswapd_movable 0
pgscan_direct_dma 10048
pgscan_direct_normal 31904
pgscan_direct_movable 0

	-> kswapd:direct = 1 : 3.4


Why I test non typical extreame woakload?
I have two reason.

1. nobody want to regression although workload isn't typical.

2. if the patch can scale performance although extreme case,
   of cource it also can works well on light weight workload.


if my patch have any regression, it definityly is valueless.
my patch only solve extreme case.
but I don't think it has.


> Does that patch make any change to the amount of CPU time which kswapd
> consumed?

I don't mesure it yet.
but at least, top coomand didn't find any consumption increasing.


> 
> Or you can not bother doing this work ;) The patch looks sensible
> anyway.  It's just that the numbers look whacky.



