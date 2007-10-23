Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXJWJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXJWJ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbXJWJ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:28:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXJWJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:28:42 -0400
Date: Tue, 23 Oct 2007 11:28:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071023092838.GA24536@one.firstfloor.org>
References: <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023003641.GF995458@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:36:41AM +1000, David Chinner wrote:
> > That doesn't mean it is correct.
> 
> Right, but it also points to the fact that it's not causing problems
> from 99.999% of ppl out there.

So you're waiting for someone to take months to debug this again? 

> You mean like vmap() could record the pages passed to it in the area->pages
> array, 

The page tables contain pointers to the pages anyways. vunmap() has to walk 
them.  It would not be very difficult to store them in an array during
the walk.

> 
> If we did this, it would probably be best to pass a page release function
> into the vmap or vunmap call - we'd need page_cache_release() called on
> the page rather than __free_page()....

Possible. Normally vmalloc pages should not be in the LRU except yours
so it would be probably fine to just change it.

> The solution belongs behind the vmap/vunmap interface, not in XFS....

You could also just keep the array from map time around yourself. 
Then you could do it yourself.

-Andi
