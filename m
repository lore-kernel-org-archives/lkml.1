Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZGJJ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZGJJ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGJJ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:29:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZGJJ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:29:22 -0400
Date: Fri, 10 Jul 2009 11:29:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090710092921.GF14666@wotan.suse.de>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247217263.771.8.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 12:14:23PM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Fri, 2009-07-10 at 11:03 +0200, Nick Piggin wrote:
> > > And whether SQLB will replace SLUB remains to be seen.
> > > We're still fixing minor issues here and there in SLUB so I have no
> > > reason to expect SLQB stabilization to happen overnight which means
> > > we're going to have SLUB in the tree for a while anyway.
> > 
> > I think it's pretty good now. It was the right thing not to merge
> > it in this window (seeing as I'd forgotten to make it the default
> > in -next). And that flushed out a bug or two. The core logic I
> > think is pretty solid now though.
> 
> The long-standing PowerPC issue is still open, isnt't it? But anyway, my

Yes.


> main point is that we've already seen from the SLAB to SLUB transition
> that while most of the bugs are fixed early on, there's a "fat tail" of
> problems ranging from performance regressions to slab corruption which
> take a long time to be discovered and fixed up.

True.

 
> And I'm not trying to spread FUD on SLQB here, I'm simply stating the
> facts from the previous "slab rewrite" and I have no reason to expect
> this one to go any smoother. OTOH, SLQB has already had exposure in
> linux-next which hopefully makes merging to mainline less painful
> because 95% of the problems are ironed out. But I don't think there's
> much we can do about the remaining 5% that only trigger on weird
> architectures, workloads, or hardware configurations.

Well hopefully most of the correctness problems are sorted out,
but I think (like SLUB) most of the hard problems will be
performance related and trickle in after merge. So I'm not sure
what point we could *remove* other allocators, but for merging
SLQB I think next window should be OK.

What I would like to see is we eventualy make the hard decision
and cull 2 of them. If SLQB is not clearly better (or, if it is
clearly worse) than the other allocators and it can't be improved,
then it has failed my goals for it and I would prefer to remove it
from the tree.

I guess the hard part is how to judge this, and how long to wait
:(

