Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbZFLIUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbZFLIUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZFLIU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbZFLIU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:20:27 -0400
Date: Fri, 12 Jun 2009 10:20:29 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: slab: setup allocators earlier in the boot sequence
Message-ID: <20090612082029.GC24044@wotan.suse.de>
References: <1244779009.7172.52.camel@pasglop> <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop> <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI> <1244792079.7172.74.camel@pasglop> <1244792745.30512.13.camel@penberg-laptop> <20090612075427.GA24044@wotan.suse.de> <1244793592.30512.17.camel@penberg-laptop> <20090612080236.GB24044@wotan.suse.de> <1244793879.30512.19.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244793879.30512.19.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 11:04:39AM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Fri, 2009-06-12 at 10:02 +0200, Nick Piggin wrote:
> > Fair enough, but this can be done right down in the synchronous
> > reclaim path in the page allocator. This will catch more cases
> > of code using the page allocator directly, and should be not
> > as hot as the slab allocator.
> 
> So you want to push the local_irq_enable() to the page allocator too? We

Well it would be nice to expose some page allocator functionality
at a bit lower level, yes. Like another thing is to avoid atomic
refcounting when there is no need for it (eg. in allocations for slab).


> can certainly do that but I think we ought to wait for Andrew to merge
> Mel's patches to mainline first, OK?

Sure.

