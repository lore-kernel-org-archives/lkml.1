Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZFKTRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZFKTRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZFKTQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:16:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56662 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZFKTQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:16:54 -0400
Date: Thu, 11 Jun 2009 20:16:54 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the
	minimum page order
Message-ID: <20090611191653.GK7302@csn.ul.ie>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110941520.29827@gentwo.org> <1244728824.17483.51.camel@penberg-laptop> <alpine.DEB.1.10.0906111021340.29827@gentwo.org> <1244733119.17483.56.camel@penberg-laptop> <alpine.DEB.1.10.0906111118350.14020@gentwo.org> <1244734086.17483.59.camel@penberg-laptop> <alpine.DEB.1.10.0906111140080.24376@gentwo.org> <20090611180422.GJ7302@csn.ul.ie> <alpine.DEB.1.10.0906111422360.11973@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906111422360.11973@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 02:26:02PM -0400, Christoph Lameter wrote:
> On Thu, 11 Jun 2009, Mel Gorman wrote:
> 
> > "With SLUB_DEBUG, enable debug on all caches unless the increased meta-data
> > would force the minimum order up on order due to object sizes being near or
> > equal the PAGE_SIZE. If SLUB_DEBUG must be enabled, specify slub_debug=A for
> > 'All caches enable debug regardless'"
> 
> Hmmm... No SLUB_DEBUG just compiles the code in for debugging. Does not
> enable anything.
> 
> But we could make SLUB_DEBUG_ON enable debugging except on those slabs
> where the order increases (for which it does a printk saying that the
> debugging was disabled) and then have a slub_debug=A option that
> overrides the order check.

Sorry, this is what I meant and I failed to explain myself properly.

> Generally if you know that you have memory
> corruption you would want to boot with slub_debug=A. If you just want
> continuous checks then SLUB_DEBUG_ON would do the trick.
> 

That's the general idea.  It would catch a number of bugs that SLUB_DEBUG_ON
catches without creating a different class of bug report such as this
atomic-order-1 problem.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
