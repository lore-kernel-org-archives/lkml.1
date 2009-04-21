Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZDUHVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZDUHVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZDUHVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:21:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39209 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZDUHVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:21:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] low order lumpy reclaim also should use PAGEOUT_IO_SYNC.
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090421161219.e13a928d.minchan.kim@barrios-desktop>
References: <20090421142056.F127.A69D9226@jp.fujitsu.com> <20090421161219.e13a928d.minchan.kim@barrios-desktop>
Message-Id: <20090421161829.F139.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 16:21:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Kosaki-san. 
> 
> On Tue, 21 Apr 2009 14:22:27 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Subject: [PATCH] low order lumpy reclaim also should use PAGEOUT_IO_SYNC.
> > 
> > commit 33c120ed2843090e2bd316de1588b8bf8b96cbde (more aggressively use lumpy reclaim)
> > change lumpy reclaim using condition. but it isn't enough change.
> > 
> > lumpy reclaim don't only mean isolate neighber page, but also do pageout as synchronous.
> > this patch does it.
> 
> I agree. 
> 
> Andi added  synchronous lumpy reclaim with c661b078fd62abe06fd11fab4ac5e4eeafe26b6d.
> At that time, lumpy reclaim is not agressive. 
> His intension is just for high-order users.(above PAGE_ALLOC_COSTLY_ORDER). 
> 
> After some time, Rik added aggressive lumpy reclaim with 33c120ed2843090e2bd316de1588b8bf8b96cbde.
> His intension is that do lumpy reclaim when high-order users and trouble getting a small set of contiguous pages. 
> 
> So we also have to add synchronous pageout for small set of contiguous pages. 
> Nice catch!. 
> 
> Reviewed-by: Minchan Kim <Minchan.kim@gmail.com>
> 
> BTW, Do you have any number ? 

No.

Actually, this logic only run when system is strongly memory stavation
or fragment. not normal case.

At that time, another slowdown thing hide synchronous reclaim latency, I think.



