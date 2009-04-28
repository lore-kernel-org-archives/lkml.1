Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbZD1Qvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbZD1Qvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762931AbZD1Qvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:51:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42698 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762992AbZD1Qvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:51:32 -0400
Date: Tue, 28 Apr 2009 17:51:29 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] Properly account for freed pages in free_pages_bulk()
	and when allocating high-order pages in buffered_rmqueue()
Message-ID: <20090428165129.GA18893@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240819119.2567.884.camel@ymzhang> <20090427143845.GC912@csn.ul.ie> <1240883957.2567.886.camel@ymzhang> <20090428103159.GB23540@csn.ul.ie> <alpine.DEB.1.10.0904281236350.21913@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904281236350.21913@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:37:22PM -0400, Christoph Lameter wrote:
> On Tue, 28 Apr 2009, Mel Gorman wrote:
> 
> > @@ -1151,6 +1151,7 @@ again:
> >  	} else {
> >  		spin_lock_irqsave(&zone->lock, flags);
> >  		page = __rmqueue(zone, order, migratetype);
> > +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
> >  		spin_unlock(&zone->lock);
> >  		if (!page)
> >  			goto failed;
> 
> __mod_zone_page_state takes an signed integer argument. Not sure what is
> won by the UL suffix here.
> 

Matches other call sites such as in __offline_isolated_pages(), habit when
using shifts like this and matches other locations, paranoia, doesn't hurt.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
