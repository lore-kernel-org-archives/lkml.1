Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYIJJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYIJJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYIJJ7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:59:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYIJJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:59:50 -0400
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's
 mmap_sem...
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel J Blueman <daniel.blueman@gmail.com>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200809101950.27669.nickpiggin@yahoo.com.au>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com>
	 <200809101803.20758.nickpiggin@yahoo.com.au>
	 <20080910083749.GH15255@elte.hu>
	 <200809101950.27669.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 11:59:31 +0200
Message-Id: <1221040771.2442.120.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 19:50 +1000, Nick Piggin wrote:
> On Wednesday 10 September 2008 18:37, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Wednesday 10 September 2008 17:57, Peter Zijlstra wrote:
> 
> > > > Sure, how about the below - untested - uncompiled, might eat kittens,
> > > > etc..
> > > >
> > > > Just sprinkle something like:
> > > >
> > > >   might_lock_read(&mm->mmap_sem);
> > > >
> > > > in the right places.
> > >
> > > Ahh, very nice, thanks! I'll give that a try...
> >
> > cool! Please send in an RFC patch once you have something that boots -
> > we can stick it into tip/core/locking and see whether there's any new
> > messages on a wide range of systems and workloads. (and we'd also check
> > whether the number of kittens is an invariant.)
> 
> Well I have verified it boots, and have used the annotation in some of
> x86-64's user copy routines (luckily no flood of bugs I was scared of,
> phew!)
> 
> So I would like to request you merge Peter's patch, and we'll hopefully
> start seeing the annotations being used. 

Will you send your x86_64 patch to be the first?

> FWIW, I don't suppose lockdep
> can determine that it is a sleeping lock, and do the appropriate
> might_sleep checks at this point as well?

Humm, no - we don't actually have that information there - I guess one
could add it to lockdep_map and set it from the various init routines,
but I'm not sure its worth it - just add might_sleep() along with
might_lock() :-)

