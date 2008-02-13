Return-Path: <linux-kernel-owner+w=401wt.eu-S1765096AbYBMEVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765096AbYBMEVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYBMEVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:21:04 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:25629 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753635AbYBMEVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:21:01 -0500
Date: Wed, 13 Feb 2008 13:19:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213041921.GA9639@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, jeff@garzik.org,
	arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org> <20080212.172051.58554658.davem@davemloft.net> <1202869550.3137.182.camel@localhost.localdomain> <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org> <1202871616.3137.197.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202871616.3137.197.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:00:16PM -0600, James Bottomley wrote:
> On Tue, 2008-02-12 at 18:35 -0800, Linus Torvalds wrote:
> > 
> > On Tue, 12 Feb 2008, James Bottomley wrote:
> > > 
> > > Yes, this is exactly the feature I'm looking for.  It would allow the
> > > downstream users of a rebased tree to rebase themselves correctly.
> > > 
> > > All the information about the rebase is in the reflog ... it can't be
> > > too difficult to pass it through on a pull and allow the downstream tree
> > > to do the right thing.
> > 
> > Guys, you simply have no idea what you're talking about.
> > 
> > Those downstream trees can have done things themselves. They *depended* on 
> > the state you gave them.
> > 
> > You can't just say "oops, I lied, this is the state you should have used, 
> > now it's _your_ mess to sort out".
> > 
> > OF COURSE it's what you'd like to use - it absolves you of any and all 
> > actual responsibility. But dammit, that's not what anybody else wants than 
> > the irresponsible person who cannot be bothered to stand up for his work!
> > 
> > If you're not confident enough about your work, don't push it out! It's 
> > that simple. Pushing out to a public branch is a small "release".
> > 
> > Have the f*cking back-bone to be able to stand behind what you did!
> 
> Erm, I would like this feature as a downstream user.
> 
> I'm not asking for this to be the default or even easily available.
> However, when you know you've based a downstream tree on what you know
> to be a volatile base, it would be very useful information to have.
> 
> Right at the moment, I maintain a <branch> and a <branch>-base and
> simply cherry pick the commits between the two to do the right thing
> when I know my volatile base has changed.  It would be very helpful to
> have a version of rebase that new my base had been rebased.
> 
> Basing on a tree I know to be volatile is sometimes a development
> decision I make as a downstream user ... I'm just wishing the tools
> could help me handle the problems better.
> 
There's also a difference between a downstream user and a downstream
developer. While rebasing does cause trouble for folks doing downstream
development off of the tree in question, there's no reason why this
should be the case for users that are simply trying to follow the tree.

I push changes out to my tree so people have a chance to poke through it
and to see what's going on, though I do not generally encourage people to
fork off of it given that I end up rebasing periodically. At the moment
the options seem to be down to the following:

	1 - Push changes out without rebasing
	2 - Push changes out periodically rebased
	3 - Hide the tree away in my home directory on hera
	4 - Force people to get at the current tree through -mm

4) generally isn't very realistic, given that -mm releases have far too
many other changes and the releases are quite spread out. 3) is doable,
but I publish the tree as a convenience to the folks wanting to see
what's going on in the tree, and I would rather continue doing so.

This leaves 2) my current workflow, and 1) which ends up creating a
lot of extra metadata. The common cases thelre are patches + reversions
and merge points. Holding on to a patch for some period of time before
pushing it out to ensure that there won't be a reversion later rarely
tends to work in practice. Most of the time I end up having to revert
something it's because someone else found a problem with a given change
_after_ the it was pushed out, and which was not caught with my local
tree or testing.

On the other hand, perhaps it's also useful to see the reversions in the
history, particularly to see what the rationale for the change not
working out was (which could be helpful for people working on the same
stuff later on).

This then leaves merge points. During merge window time people are
pulling on a pretty frequent basis, which also breaks down to a few
fairly common cases:

	1 - Bringing in new stuff to be supported (ie, system calls).
	2 - Infrastructure support bits that have gone in through a
	    subsystem tree, when you have local patches blocked until the
	    subsystem tree has merge.
	3 - Catching and resolving conflicts before bisect gets broken.
	4 - Trying to make sure that it all merges cleanly.

I've generally worked around 2) by doing multiple merges during the merge
window, but it's also appealing to just rebase and throw in the rest of
the outstanding bits before sending out the initial merge request.

1) and 3) often tend to have dependencies on each other, and tend to be
the area where the most troubles arise. 3) and 4) are really the places
where rebasing appeals the most, and is also where we see the highest
concentration of merge points.

If there's a nice way to resolve this without a rebase that would be
nice. For users in general, I suspect most people are just interested in
a pull that can traverse a rebase without having them wipe the tree. Most
users that are tracking a tree of interest seem to understand that a
development tree is highly volatile during merge window time, and that
they track the tree knowing that they will occasionally have to toss it
and start over when it's rebased. Having a way to simplify this that
doesn't create an additional maintenance burden would be ideal. I suspect
that if people are never rebasing in publicly visible trees, we will
simply see a shift to unpublished trees instead, which doesn't seem to be
what anyone wants either.
