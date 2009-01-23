Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZAWN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZAWN6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZAWN6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:58:01 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59317 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbZAWN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:58:00 -0500
Date: Fri, 23 Jan 2009 13:57:00 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <20090123035503.GD20098@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0901231335080.9011@blonde.anvils>
References: <20090121143008.GV24891@wotan.suse.de> <Pine.LNX.4.64.0901211705570.7020@blonde.anvils>
 <20090123035503.GD20098@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nick Piggin wrote:
> On Wed, Jan 21, 2009 at 06:10:12PM +0000, Hugh Dickins wrote:
> > 
> > That's been making SLUB behave pretty badly (e.g. elapsed time 30%
> > more than SLAB) with swapping loads on most of my machines.  Though
> > oddly one seems immune, and another takes four times as long: guess
> > it depends on how close to thrashing, but probably more to investigate
> > there.  I think my original SLUB versus SLAB comparisons were done on
> > the immune one: as I remember, SLUB and SLAB were equivalent on those
> > loads when SLUB came in, but even with boot option slub_max_order=1,
> > SLUB is still slower than SLAB on such tests (e.g. 2% slower).
> > FWIW - swapping loads are not what anybody should tune for.
> 
> Yeah, that's to be expected with higher order allocations I think. Does
> your immune machine simply have fewer CPUs and thus doesn't use such
> high order allocations?

No, it's just one of the quads.  Whereas the worst affected (laptop)
is a duo.  I should probably be worrying more about that one: it may
be that I'm thrashing it and its results are meaningless, though still
curious that slab and slqb and slob all do so markedly better on it.

It's behaving much better with slub_max_order=1 slub_min_objects=4,
but to get competitive I've had to switch off most of the debugging
options I usually have on that one - and I've not yet tried slab,
slqb and slob with those off too.  Hmm, it looks like its getting
progressively slower.

I'll continue to investigate at leisure,
but can't give it too much attention.

Hugh
