Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYHVOtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYHVOtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYHVOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:49:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56544 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYHVOto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:49:44 -0400
Date: Fri, 22 Aug 2008 15:49:41 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, hsweeten@visionengravers.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Skip memory holes in FLATMEM when reading /proc/pagetypeinfo (resend)
Message-ID: <20080822144940.GA2245@csn.ul.ie>
References: <20080821132804.GA6206@csn.ul.ie> <20080821093400.fe02a76f.akpm@linux-foundation.org> <20080821165648.GF22837@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080821165648.GF22837@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (21/08/08 17:56), Russell King - ARM Linux didst pronounce:
> On Thu, Aug 21, 2008 at 09:34:00AM -0700, Andrew Morton wrote:
> > On Thu, 21 Aug 2008 14:28:05 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> > > This patch lets architectures say when FLATMEM can have holes in the
> > > memmap. Rather than an expensive check for valid memory, /proc/pagetypeinfo
> > > will confirm that the page linkages are still valid by checking page->zone
> > > is still the expected zone. The lookup of page_zone is safe as there is a
> > > limited range of memory that is accessed when calling page_zone.  Even if
> > > page_zone happens to return the correct zone, the impact is that the counters
> > > in /proc/pagetypeinfo are slightly off but fragmentation monitoring is
> > > unlikely to be relevant on an embedded system.
> > 
> > Sounds like this might fix an oops.  Does it?
> > 

Yes, it does. Sorry for not being clear on that.

> > The patch applies to 2.6.25 and to 2.6.26.  Should it be backported?
> 

It wouldn't hurt. It's not a critical functionality failure and only affects
ARM but being able to generate oops from userspace is a bit of a loss.

> The only concern there is with this patch is that we're still walking
> over the memory, which could contain anything.  We could be unlucky
> and end up with page_zone(page) == zone.
> 

If you do, the impact is that the counters are slightly off which is not
that big of a deal. To avoid doing it, information would have to be kept
around that might end up being larger than the memmap freed.

> It'll do as a stop gap, but I think the real solution is to switch over
> to using sparsemem, and get rid of ARMs private version (which even
> pre-dates discontigmem.)  That first assumes that we have sparsemem
> working on ARM - however folk seem to prefer discontigmem over
> sparsemem so I don't know what state sparsemem on ARM is in. :(
> 

No idea. I know that SPARSEMEM would be preferred as a memory model as
it is a lot less arch-specific than DISCONTIG is.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
