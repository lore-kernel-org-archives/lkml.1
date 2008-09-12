Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYILUiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYILUiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYILUhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:37:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56184 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623AbYILUhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:37:54 -0400
Date: Fri, 12 Sep 2008 21:37:52 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH] Mark the correct zone as full when scanning zonelists
Message-ID: <20080912203752.GB30869@csn.ul.ie>
References: <20080911212550.GA18087@csn.ul.ie> <20080911144155.c70ef145.akpm@linux-foundation.org> <20080912101007.ed56780f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080912101007.ed56780f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/09/08 10:10), KAMEZAWA Hiroyuki didst pronounce:
> On Thu, 11 Sep 2008 14:41:55 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 11 Sep 2008 22:25:51 +0100
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > The for_each_zone_zonelist() uses a struct zoneref *z cursor when scanning
> > > zonelists to keep track of where in the zonelist it is. The zoneref that
> > > is returned corresponds to the the next zone that is to be scanned, not
> > > the current one as it originally thought of as an opaque list.
> > > 
> > > When the page allocator is scanning a zonelist, it marks zones that it
> > > temporarily full zones to eliminate near-future scanning attempts.
> > 
> > That sentence needs help.
> > 
> Hmm, should we rename
> 
>  next_zone_zonelist() => get_appropriate_zone_from_list()
> 
> or some better name ?
> 

Maybe as a separate patch, but to be honest the name still makes sense
to me but I'm biased.

> > > It uses
> > > the zoneref for the marking and consequently the incorrect zone gets marked
> > > full. This leads to a suitable zone being skipped in the mistaken belief
> > > it is full. This patch corrects the problem by changing zoneref to be the
> > > current zone being scanned instead of the next one.
> > 
> > Applicable to 2.6.26 as well, yes?
> > 
> Maybe yes. But it's better to show where this patch really fixes.
> Is this a fix for misunderstanding usage of zoneref in
> mm/page_alloc.c::get_page_from_freelist() ?
> 
> == here ?==
>   if (NUMA_BUILD)
> 	zlc_mark_zone_full(zonelist, z);
> 

I spelled this out a bit better hopefully in the updated changelog.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
