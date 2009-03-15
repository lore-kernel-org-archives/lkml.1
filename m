Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZCOPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZCOPRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZCOPRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:17:13 -0400
Received: from www.tglx.de ([62.245.132.106]:42048 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZCOPRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:17:11 -0400
Date: Sun, 15 Mar 2009 16:16:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate
 reclaim context (__GFP_NOFS), fix SLOB)
In-Reply-To: <200903152104.25683.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0903151614320.29264@localhost.localdomain>
References: <20090128135457.350751756@chello.nl> <200903152006.21160.nickpiggin@yahoo.com.au> <20090315094704.GA21169@elte.hu> <200903152104.25683.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Mar 2009, Nick Piggin wrote:
> On Sunday 15 March 2009 20:47:04 Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:
> > > > > Cc: Nick Piggin <npiggin@suse.de>
> > > > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > LKML-Reference: <20090128135457.350751756@chello.nl>
> > > > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > >
> > > > and with this fixed, and with SLOB now being tested in -tip, the
> > > > new lockdep assert attached below (followed by a real lockup)
> > > > pops up.
> > > >
> > > > Seems like a genuine SLOB bug, probably present upstream as
> > > > well.
> > >
> > > Hmmf. debugobjects calls back into the slab allocator from the
> > > page allocator. The following patch would improve SLOB, but I
> > > think it would be a good idea to avoid a dependency in that
> > > direction. Can debugobjects defer this freeing?
> >
> > dunno - that's a question for Thomas.
> 
> Well I think it could, and it should (just add them to a list and
> kick off a workqueue or something). It is not a good idea for
> fringe debug functionality like this to introduce such a connection
> between core code like this. Unless there is a *really* good reason.
> 
> Apart from the locking issue, I wonder if the recursion is bounded?

Yes. debugobject free does not call back into debugobjects, but you
are right it should defer the free. I have rcu based deferred free in
-rt for the very same reason. I'll whip up a solution for mainline as
well.

Thanks,

	tglx
