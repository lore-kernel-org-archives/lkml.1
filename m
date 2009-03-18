Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZCRPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZCRPHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZCRPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:07:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47112 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZCRPH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:07:27 -0400
Date: Wed, 18 Mar 2009 15:07:24 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/35] Cleanup and optimise the page allocator V3
Message-ID: <20090318150724.GB4629@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <20090316104054.GA23046@wotan.suse.de> <20090316111906.GA6382@csn.ul.ie> <20090316113358.GA30802@wotan.suse.de> <20090316120216.GB6382@csn.ul.ie> <20090316122505.GD30802@wotan.suse.de> <20090316133232.GA24293@csn.ul.ie> <20090316155342.GH30802@wotan.suse.de> <20090316165628.GP24293@csn.ul.ie> <20090316170551.GI30802@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090316170551.GI30802@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 06:05:51PM +0100, Nick Piggin wrote:
> On Mon, Mar 16, 2009 at 04:56:28PM +0000, Mel Gorman wrote:
> > On Mon, Mar 16, 2009 at 04:53:42PM +0100, Nick Piggin wrote:
> > > So yes definitely I think there should be a very real impact on
> > > higher order coalescing no matter what you do.
> > > 
> > 
> > Because this is not straight-forward at all, I'll put lazy buddy onto
> > the back-burner and exhaust all other possibilities before revisiting it
> > again.
> 
> If it is such a big improvement, I expect *most* people will want
> it and we probably should do it.

I'll be reinvestigating it in isolation. It's possible that high-order and
compound pages on the PCP lists is enough of a delayed buddy merging that
the benefit from lazy buddy is marginal.

> But just that it will not play
> nicely with fragmentation and so you'd need to look into it and
> devise some way those users can tune it to be nicer.
> 

Which is why I'm going to postpone it for now.

> > > unmovable zone fragmentation is more important point because it
> > > eventually can destroy the movable zone.
> > > 
> > 
> > Which is why rmqueue_fallback() also merges up all buddies before making
> > any decisions but I accept your points.
> 
> Right, that merge of buddies will only be able to look at what is
> currently free. Wheras non-lazy buddy can pull out higher orders
> before reallocating them.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
