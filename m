Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYHUQnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYHUQnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYHUQnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:43:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35021 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYHUQnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:43:45 -0400
Date: Thu, 21 Aug 2008 09:43:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
	released
Message-ID: <20080821164339.GK6690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> <1219316568.8651.107.camel@twins> <20080821114745.GD21089@linux.vnet.ibm.com> <alpine.LFD.1.10.0808210845280.3487@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808210845280.3487@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 08:57:31AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 21 Aug 2008, Paul E. McKenney wrote:
> > 
> > Let's face it, the C standard does not support concurrency, so we are
> > all in a state of sin in any case, forced to rely on combinations of
> > gcc-specific non-standard language extensions and assembly language.
> > 
> > Could be worse!!!
> 
> It _will_ be worse.

And not only that, it will be worse before the new standard is ratified.
Or to give the full version: "Could be worse, and probably soon will be."

> The C standard will eventually support concurrency (they are working on 
> it), and it will almost inevitably be a horrible pile of stinking sh*t, 
> and we'll continue to use the gcc inline asms instead, but then the gcc 
> people will ignore our complaints when they break the compiler, and say 
> that we should use the stinking-pile-of-sh*t ones that are built in.
> 
> No, I haven't seen the drafts, and maybe I'm overly pessimistic, but I'm 
> pretty sure that this is an area where (a) the kernel needs more support 
> than most normal pthread-like models and (b) any design-by-committee thing 
> simply won't be very good, because they'll have to try to make everybody 
> happy.

Let's see...

1.	Yes, the standard is being designed by a committee.

2.	No, it does not simply ratify the Linux kernel's memory-barrier
	API.  Yes, I did propose that.  No, the proposal did not go
	very far, but yes, it did get people's attention.  Yes, there
	were a number of people who asserted that Linux's approach was
	fundamentally broken/buggy/whatever.  Yes, they have changed
	their mind, most of them, anyway.  No, there is still zero
	chance of the standard simply ratifying smp_mb() and friends.

3.	Yes, we are working to get things closer to the Linux kernel's
	memory-barrier API into the spec.  No, they will likely not
	be exact.  Yes, getting some prominent committee members to
	countenance the idea of any sort of raw memory barrier (not
	connected directly to a load, store, or atomic operation)
	was a long-term project that finally made headway last May.
	Again, design by committee.

4.	No, the current Linux kernel memory-barrier API is not perfect.
	Yes, the proposed standard's preferred memory-barrier approach
	will make code easier to read and understand in many cases, and
	could potentially allow the compiler to do better optimizations
	(which, yes, might or might not be a good thing).  No, the
	proposed standard's preferred approach does not apply to all the
	cases in the Linux kernel.  No, I don't know whether or not it
	will be worthwhile to introduce the standard's preferred approach
	to the Linux kernel (though I suspect that it would be, but have
	to wait and see).  Either way, yes, the Linux kernel will likely
	continue to need to resort to non-standard gcc extensions and
	assembly language in at least some cases.  As you say, the kernel
	is not a garden-variety pthreads application.

But even if the Linux kernel never uses this stuff, user applications
will need it.  And there are a number of reasons why gcc extensions and
assembly language are even less welcome in many such applications than
they are in the Linux kernel.

> Oh, well.

Pretty much.  After all, if you wake up some morning and find that you
have absolutely no problems, your first action should be to check to
see if you are under six feet of earth.

							Thanx, Paul
