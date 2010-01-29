Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365Ab0A2Reo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0A2Reo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071Ab0A2Reo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:34:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40344 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0A2Ren (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:34:43 -0500
Date: Fri, 29 Jan 2010 17:34:30 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mark Lord <kernel@teksavvy.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
Message-ID: <20100129173430.GK7139@csn.ul.ie>
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com> <201001281152.20352.rjw@sisk.pl> <4B61964F.6060307@teksavvy.com> <4B619C6D.9030205@teksavvy.com> <20100128142437.GA7139@csn.ul.ie> <4B62E904.9020401@teksavvy.com> <20100129154653.GJ7139@csn.ul.ie> <alpine.LSU.2.00.1001291716520.10968@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1001291716520.10968@sister.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 05:27:56PM +0000, Hugh Dickins wrote:
> On Fri, 29 Jan 2010, Mel Gorman wrote:
> > On Fri, Jan 29, 2010 at 08:56:20AM -0500, Mark Lord wrote:
> > 
> > > I'll leave it running for another day or so, and then perhaps revert
> > > the one patch to see which of the two things (new kernel, or patch)
> > > is responsible for the difference.
> > >
> > 
> > Thanks, I'd appreciate it. While I'm reasonably confident the problem is
> > with MIGRATE_RESERVE not being free as intended and that the patch fixes
> > it, I'd like more proof.
> 
> You're more confident about that than I am!  It will be very satisfying
> if my patch turns out to make the difference, but still surprising to me.
> 

My confidence/delusion is in part due to the reasons MIGRATE_RESERVE
exists in the first place. Specifically, certain wireless network drivers
were doing GFP_ATOMIC order-2 allocation a lot and failing miserably when
anti-fragmentation was first introduced. The problem came down to a property
of the buddy allocator implementation that kept min_free_kbytes worth of pages
free at the lower addresses of the zone and this is where order-2 allocations
were being made from and quickly freed meaning the area was generally available
for a lot of time.  MIGRATE_RESERVE was introduced to preserve that property
of the buddy allocator and the allocation failure problems went away.

Mark's problem feels very similar to the wireless network drivers problem.

Maybe I'm deluding myself.

> Thank you for taking the time on this, Mark: I too would appreciate it
> if you could later determine whether it's new kernel or patch solving it.
> 
> > 
> > Hugh, can I get a signed-off-by on that patch please? I can improve the
> > changelog if you like and send it to Andrew for merging if you like.
> 
> I was adjusting the changelog and about to send direct to Linus Cc stable
> in a few minutes, since I'm guessing there might be a 33-rc6 today, which
> would be a pity to miss.
> 

Great.

> Whatever my reluctance to assume it's the fix to Mark's problem (which I'm
> not mentioning in the changelog), we are both sure it's a valid bugfix.
> 

Indeed. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
