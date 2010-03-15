Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936019Ab0COJgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:36:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50782 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935701Ab0COJgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:36:52 -0400
Date: Mon, 15 Mar 2010 09:36:34 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Markus Rechberger <mrechberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
Message-ID: <20100315093634.GF18274@csn.ul.ie>
References: <20100310155519.GO4883@csn.ul.ie> <Pine.LNX.4.44L0.1003111155030.1367-100000@iolanthe.rowland.org> <20100314193114.619a2616.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100314193114.619a2616.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 07:31:14PM -0400, Andrew Morton wrote:
> On Thu, 11 Mar 2010 11:56:22 -0500 (EST) Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Wed, 10 Mar 2010, Mel Gorman wrote:
> > 
> > > > > Is there any means for the driver to take the large request, break it up
> > > > > into multiple smaller requests and submit them one at a time?
> > > > 
> > > > In theory almost anything is possible.  But it would be a big effort
> > > > and not consistent with the way the rest of the driver works.
> > > > 
> > > 
> > > Then about the only other suggestion would be a mempool containing a small
> > > number of largest-possible buffers that is enabled if there is no swap
> > > available.
> > 
> > Considering that this is the first report I have heard about this sort 
> > of problem, and that adding swap space would probably fix it, I'm not 
> > inclined to make any changes.
> 
> Adding swap space is unlikely to help here.  For an order-6 allocation
> the page allocator will go into wtf-youre-kidding-me mode and won't
> even bother trying.
> 

It will try and make the allocation and probably enter direct reclaim
and do a lumpy reclaim for contiguous blocks. What it won't do is retry
as many times as an allocation order <= PAGE_ALLOC_COSTLY_ORDER.

> Asking the allocator for 2^6 physically contiguous pages is terribly
> unreliable and shouldn't be done by any kernel code which wants to be
> useful.
> 

This remains true. With swap, the high-order allocation attempt might succeed
many of the times but there will still be situations where it fails.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
