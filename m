Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbZBXRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbZBXRxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZBXRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:53:05 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44305 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067AbZBXRxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:53:04 -0500
Date: Tue, 24 Feb 2009 17:53:00 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/19] Calculate the preferred zone for allocation only
	once
Message-ID: <20090224175300.GC5333@csn.ul.ie>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235477835-14500-11-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902241229450.32227@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902241229450.32227@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 12:31:41PM -0500, Christoph Lameter wrote:
> On Tue, 24 Feb 2009, Mel Gorman wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 6f26944..074f9a6 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1399,24 +1399,19 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
> >   */
> >  static struct page *
> >  get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
> > -		struct zonelist *zonelist, int high_zoneidx, int alloc_flags)
> > +		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
> > +		struct zone *preferred_zone)
> >  {
> 
> This gets into a quite a number of parameters now. Pass a structure like in
> vmscan.c?

I considered it, but thought that multiple offsets into structures might
exceed the cost of pushing the parameters onto the stack. I never
actually looked at the generated assembly though to make a proper
assessment.

> Or simplify things to be able to run get_page_from_freelist with
> less parameters? The number of parameters seem to be too high for a
> fastpath function.
> 

Which is why I ended up inlining get_page_from_freelist() in V1. It's a rock
and a hard place basically. Passing parameters is expensive, but calculating
the information multiple times is too.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
