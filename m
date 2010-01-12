Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787Ab0ALXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0ALXkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054Ab0ALXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:40:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52022 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0ALXki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:40:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] check high watermark after shrink zone
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100112150152.78604b78.akpm@linux-foundation.org>
References: <20100108141235.ef56b567.minchan.kim@barrios-desktop> <20100112150152.78604b78.akpm@linux-foundation.org>
Message-Id: <20100113083339.B3C5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Jan 2010 08:40:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  mm/vmscan.c |   21 +++++++++++----------
> >  1 files changed, 11 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 885207a..b81adf8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2057,9 +2057,6 @@ loop_again:
> >  					priority != DEF_PRIORITY)
> >  				continue;
> >  
> > -			if (!zone_watermark_ok(zone, order,
> > -					high_wmark_pages(zone), end_zone, 0))
> > -				all_zones_ok = 0;
> 
> This will make kswapd stop doing reclaim if all zones have
> zone_is_all_unreclaimable():
> 
> 			if (zone_is_all_unreclaimable(zone))
> 				continue;
> 
> This seems bad.

No. That's intentional, I think. All zones of small asymmetric numa
node are always unreclaimable typically. stopping kswapd prevent to
waste 100% cpu time such situation.

In the other hand, This logic doesn't cause disaster to symmetric numa.
it merely cause direct reclaim and re-wakeup kswapd.



