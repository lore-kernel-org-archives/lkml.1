Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZBWQk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZBWQk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZBWQku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:40:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52313 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZBWQkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:40:49 -0500
Date: Mon, 23 Feb 2009 16:40:47 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of
	precalculated value
Message-ID: <20090223164047.GO6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902231003090.7298@qirst.com> <200902240241.48575.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0902231042440.7790@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902231042440.7790@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:43:20AM -0500, Christoph Lameter wrote:
> On Tue, 24 Feb 2009, Nick Piggin wrote:
> 
> > > Are you sure that this is a benefit? Jumps are forward and pretty short
> > > and the compiler is optimizing a branch away in the current code.
> >
> > Pretty easy to mispredict there, though, especially as you can tend
> > to get allocations interleaved between kernel and movable (or simply
> > if the branch predictor is cold there are a lot of branches on x86-64).
> >
> > I would be interested to know if there is a measured improvement.

Not in kernbench at least, but that is no surprise. It's a small
percentage of the overall cost. It'll appear in the noise for anything
other than micro-benchmarks.

> > It
> > adds an extra dcache line to the footprint, but OTOH the instructions
> > you quote is more than one icache line, and presumably Mel's code will
> > be a lot shorter.
> 

Yes, it's an index lookup of a shared read-only cache line versus a lot
of code with branches to mispredict. I wasn't happy with the cache line
consumption but it was the first obvious alternative.

> Maybe we can come up with a version of gfp_zone that has no branches and
> no lookup?
> 

Ideally, yes, but I didn't spot any obvious way of figuring it out at
compile time then or now. Suggestions?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
