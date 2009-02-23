Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZBWQYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZBWQYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZBWQYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:24:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36220 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZBWQYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:24:34 -0500
Date: Mon, 23 Feb 2009 16:24:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 03/20] Do not check NUMA node ID when the caller knows
	the node is valid
Message-ID: <20090223162431.GM6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-4-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902230958440.7298@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902230958440.7298@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:01:35AM -0500, Christoph Lameter wrote:
> On Sun, 22 Feb 2009, Mel Gorman wrote:
> 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 75f49d3..6566c9e 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -1318,11 +1318,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  	for (i = 0; i < area->nr_pages; i++) {
> >  		struct page *page;
> >
> > -		if (node < 0)
> > -			page = alloc_page(gfp_mask);
> > -		else
> > -			page = alloc_pages_node(node, gfp_mask, 0);
> > -
> > +		page = alloc_pages_node(node, gfp_mask, 0);
> >  		if (unlikely(!page)) {
> >  			/* Successfully allocated i pages, free them in __vunmap() */
> >  			area->nr_pages = i;
> >
> 
> That wont work. alloc_pages() obeys memory policies. alloc_pages_node()
> does not.
> 

Correct, I failed to take policies into account. The same comment
applied for the slub modification. I've reverted this part. Good spot.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
