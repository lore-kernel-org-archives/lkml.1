Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZIHKyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZIHKyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZIHKyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:54:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39371 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbZIHKyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:54:11 -0400
Date: Tue, 8 Sep 2009 11:54:15 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090908105415.GD28127@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com> <200909061028.48442.elendil@planet.nl> <1252226116.11274.10.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1252226116.11274.10.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 11:35:16AM +0300, Pekka Enberg wrote:
> On Sun, 2009-09-06 at 10:28 +0200, Frans Pop wrote:
> > On Sunday 06 September 2009, Pekka Enberg wrote:
> > > On Sun, Sep 6, 2009 at 10:40 AM, Frans Pop<elendil@planet.nl> wrote:
> > > > Got a couple of page allocation failures today while viewing fairly
> > > > large images. System was struggling for a bit to reorganize memory
> > > > and swap, but nothing really serious. Everything recovered fairly
> > > > quickly.
> > > >
> > > > Anything to look into?
> > > >
> > > > System: HP 2510p; 2.6.31-rc7-56-g7c0a57d; Debian stable, KDE desktop
> > > >
> > > > 10:00.0 Network controller [0280]: Intel Corporation PRO/Wireless
> > > > 4965 AG or AGN [Kedron] Network Connection [8086:4229] (rev 61)
> > >
> > > Can you post your .config, please?
> > 
> > Attached. Thanks.
> 
> OK, so SLUB_DEBUG_ON is disabled so it's probably not a SLUB problem.
> Mel, there's quite a few page allocation failure reports recently which
> makes me wonder if we broke something with the page allocator
> optimization patches? Do you think the anti-fragmentation fixlet you did
> for nommu would help here?
> 

No, because that change only affected the case where the system had very
little memory. The last time that there was a sudden major increase in
allocation failures, it was actually was page reclaim was broken -
specifically kswapd was no longer doing the job that was expected of it.
The symptoms where applications stalling because they were entering
direct reclaim. I haven't looked very closely at this bug report yet
(catching up from being offline the last 5 days).

Have there been any reclaim changes that might account for something like this?

My feeling is also that a number of these page allocation failures have
been related to wireless drivers. Is that accurate? If so, have there
been changes made to the wireless stack in this cycle that would have
increased the order of pages allocated?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
