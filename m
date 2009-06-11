Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZFKSEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZFKSEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZFKSEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:04:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49623 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758AbZFKSEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:04:23 -0400
Date: Thu, 11 Jun 2009 19:04:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the
	minimum page order
Message-ID: <20090611180422.GJ7302@csn.ul.ie>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110941520.29827@gentwo.org> <1244728824.17483.51.camel@penberg-laptop> <alpine.DEB.1.10.0906111021340.29827@gentwo.org> <1244733119.17483.56.camel@penberg-laptop> <alpine.DEB.1.10.0906111118350.14020@gentwo.org> <1244734086.17483.59.camel@penberg-laptop> <alpine.DEB.1.10.0906111140080.24376@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906111140080.24376@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:49:19AM -0400, Christoph Lameter wrote:
> On Thu, 11 Jun 2009, Pekka Enberg wrote:
> 
> > My main point is that a lot of _testers_ will probably enable all SLUB
> > debugging by default because we encourage them to and it's pretty bad
> > that we end up causing order 1 allocations and oom conditions.
> 
> Other test methods (like PAGE_ALLOC debugging) also have significant side
> effects.
> 

True, but they come with huge big warnings and I agree that we don't want
to make the SL*B debug warning too drastic, particularly because SL*B
debugging is often so valuable and relatively lightweight in comparison
to some debug options.


> > So I still think we need to fix _at minimum_ the kmalloc-4096 case
> > (assuming Larry won't hit the same problem still). I see you're not
> > happy with my patch so any suggestions how to handle that?
> 
> Add a warning to Kconfig that the higher order page allocations may
> increase with debugging on for caches with object sizes near or equal to
> PAGE_SIZE?
> 

Possibly clueless suggestion here. How possible would it be to implement
something like

"With SLUB_DEBUG, enable debug on all caches unless the increased meta-data
would force the minimum order up on order due to object sizes being near or
equal the PAGE_SIZE. If SLUB_DEBUG must be enabled, specify slub_debug=A for
'All caches enable debug regardless'"

?

> Its good to run with full debugging on for even the 4k sized caches.
> Otherwise we wont be catching overruns there. But the debugging can cause
> some side effects.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
