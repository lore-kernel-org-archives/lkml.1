Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbXINTvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbXINTvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXINTvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:51:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38764 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbXINTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:51:36 -0400
Date: Fri, 14 Sep 2007 12:51:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew.R.wilcox@intel.com
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <20070914191511.GC6078@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0709141242200.17369@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
 <200709110117.57387.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
 <20070913060432.GB6078@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0709131055430.8859@schroedinger.engr.sgi.com>
 <20070914191511.GC6078@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Siddha, Suresh B wrote:

> Numbers I posted in the previous e-mail is the only story we have so far.

It would be interesting to know more about how the allocator is used 
there.

> Sorry, These systems are huge and limited. We are raising the priority
> with the performance team to do the latest slub patch testing.

Ok. Thanks.

> > Its too late for 2.6.23. But we can certainly do things for .24. Could you 
> > please test the patches queued up in Andrew's tree? In particular the page 
> > allocator pass through and the per cpu structures optimizations?
> 
> We are trying to get the latest data with 2.6.23-rc4-mm1 with and without
> slub. Is this good enough?

Good enough. If you are concerned about the page allocator pass through 
then you may want to test the page allocator pass through patchset 
separately. The fastpath of the page allocator is currently not 
competitive if you always free and allocate a single page. If contiguous 
pages are allocated then the pass through is superior.

> > The work of Matheiu also has implications for the page allocator. We may 
> > be able to significantly speed up the fastpath there as well.
> 
> Ok. Atleast till all the regressions addressed and all these patches well
> tested, we shouldn't do away with slab from mainline anytime soon.

Ok. We will hold off. It was so silent about this issue though and from 
the talk with Corey I may have wrongly concluded that this was because the 
issues were resolved.

> Other than us, who else are you banking on for analysing slub? Do
> you have any numbers that you can share, which show where slub
> is good or bad...

http://lwn.net/Articles/246927/ contains some cycle measurements for the 
per cpu patchset and also for the page allocator pass through.

If there is a problem with certain sizes for page allocator pass through 
then we may want to increase the boundary so that the page allocator is 
only called for objects larger than page size.
