Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZETKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZETKlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZETKlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:41:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:59738 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZETKlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=lZ7X/ySn7MijUPPJPfMQ5YbQPKtc2MI6jk8nX9vVMclo/pHFt9FbtALwgE2vc/Cf+O
         OV7cU0o8bKUYrtdcRmb/zDT5wNTi1EbYfjjHxPWFMQJrwTOyUTSb2kIIK9uj98lKfPcx
         5EVZf30IzvNm3Vas53CPOIEQzrumPDLqPZrFQ=
Date: Wed, 20 May 2009 19:41:21 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/3] add inactive ratio calculation function of each
 zone
Message-Id: <20090520194121.535e8acc.minchan.kim@barrios-desktop>
In-Reply-To: <20090520103055.GB12433@csn.ul.ie>
References: <20090520161936.c86a0e38.minchan.kim@barrios-desktop>
	<20090520103055.GB12433@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 11:30:56 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, May 20, 2009 at 04:19:36PM +0900, Minchan Kim wrote:
> > This patch divides setup_per_zone_inactive_ratio with
> > per zone inactive ratio calculaton.
> > 
> 
> Why? I'm guessing it's required by the next patch but a note here
> explaining why you need it would be nice.

OK. 

> The new function calculates the inactive ratio for one zone, not all zones,
> so a a more appropriate name would have been calculate_zone_inactive_ratio().

Indeed. I will modify function name with that. 

> Is the indenting for calculate_per_zone_inactive_ratio() in too far? It
> looks from the patch that it will be indented one tab too many.

Hmm. I can't understand your point due to my poor english. 
Could you explain more easily, please ?

> 
> > CC: Rik van Riel <riel@redhat.com>
> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  include/linux/mm.h |    1 +
> >  mm/page_alloc.c    |   14 +++++++++-----
> >  2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1b2cb16..cede957 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1059,6 +1059,7 @@ extern void set_dma_reserve(unsigned long new_dma_reserve);
> >  extern void memmap_init_zone(unsigned long, int, unsigned long,
> >  				unsigned long, enum memmap_context);
> >  extern void setup_per_zone_wmark_min(void);
> > +extern void calculate_per_zone_inactive_ratio(struct zone* zone);
> >  extern void mem_init(void);
> >  extern void __init mmap_init(void);
> >  extern void show_mem(void);
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 273526b..4601ba0 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4552,11 +4552,8 @@ void setup_per_zone_wmark_min(void)
> >   *    1TB     101        10GB
> >   *   10TB     320        32GB
> >   */
> > -static void __init setup_per_zone_inactive_ratio(void)
> > +void calculate_per_zone_inactive_ratio(struct zone* zone)
> >  {
> > -	struct zone *zone;
> > -
> > -	for_each_zone(zone) {
> >  		unsigned int gb, ratio;
> >  
> >  		/* Zone size in gigabytes */
> > @@ -4567,7 +4564,14 @@ static void __init setup_per_zone_inactive_ratio(void)
> >  			ratio = 1;
> >  
> >  		zone->inactive_ratio = ratio;
> > -	}
> > +}
> > +
> > +static void __init setup_per_zone_inactive_ratio(void)
> > +{
> > +	struct zone *zone;
> > +
> > +	for_each_zone(zone) 
> > +		calculate_per_zone_inactive_ratio(zone);
> >  }
> >  
> >  /*
> > -- 
> > 1.5.4.3
> > 
> > 
> > 
> > -- 
> > Kinds Regards
> > Minchan Kim
> > 
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab


-- 
Kinds Regards
Minchan Kim
