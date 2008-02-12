Return-Path: <linux-kernel-owner+w=401wt.eu-S1763963AbYBLSZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763963AbYBLSZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762935AbYBLSYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:24:50 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44524 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762230AbYBLSYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:24:47 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	 <1202838082.3137.54.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 12:24:42 -0600
Message-Id: <1202840682.3137.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 10:00 -0800, Linus Torvalds wrote:
> 
> On Tue, 12 Feb 2008, James Bottomley wrote:
> >
> > On Tue, 2008-02-12 at 09:09 -0800, Linus Torvalds wrote:
> > >  (a) create a base tree with _just_ that fundamental infrastructure change,
> > >      and make sure that base branch is so obviously good that there is no 
> > >      question about merging it.
> > 
> > The problem is how do we use a?  Usually we need to track your -rc tree
> > as our fixes go in ... some of which affect our development trees.
> 
> So?
> 
> > If we stick with (a) as the base, we don't get to pull in the fixes in
> > your tree.  If we use your tree we have to pull in (a) creating n
> > different merge points for the n different upstream trees..
> 
> I don't understand what you mean. This is true whether you pulled (a) or 
> not. If you have any changes what-so-ever in your tree, if you pull in 
> fixes from my tree, you'll get a merge.
> 
> But if you mean that you cannot rebase (a), then yes. That was what I 
> said.

Yes, that's what I meant ... no rebasing of (a) once it becomes the
fixed point we all work from.

>  Rebases *do*not*work* (and fundamentally cannot work) in a 
> distributed environment.

Hm ... I think net is a counter example to this.  Rebases certainly work
for them.  The issue, I thought, was around the policy of rebasing and
how often.

I see the question as being one of who creates the history.  When
something goes into your tree, that's an obvious history point and we
can't rewrite it.  However, when something goes into my trees, I don't
think it's as obviously a history point that has to be preserved, so I
can rebase obviously, rebasing causes disruption, so I don't do it
unless it's necessitated by an actual conflict.

> But why would you merge with my tree in the first place? My tree won't 
> normally have any conflicts or anything like that anyway.

This normally happens when we have bug fixes to a driver that is
simultaneously being worked on for the merge window ... and it actually
happens quite a lot.  Sometimes the conflicts actually don't come via my
tree (usually a -mm docbook update, include file removal or something
else that looked trivial to the submitter).

The worst examples of this are the "run lindent on the driver" type of
patches, but a lot of other changes give trivial conflict too.

> With a "Linux-next" tree, you'll see the conflicts if they occur (since 
> *that* tree would merge!), and in that case you would say  "now I need to 
> merge Linus' tree just to resolve the conflicts!"

Right ... that's exactly why I created the -mc tree ... it warns me that
there's a looming problem I need to fix (and not just in your tree).
For that reason, a -next tree that does exactly the same thing will be
great ... I won't have to maintain the -mc tree.

> But before that, merging my tree (or rebasing on top of it) is simply 
> *wrong*. It has nothing to do with your SCSI development.

Yes ... I don't do that ... Like I said, I only rebase for an actual
conflict.

> > Yes, this is effectively what I did with the post merge SCSI tree.
> > However, if you do this rebasing becomes a fact of life because you need
> > to rebase out all the dependencies you have before you merge (in fact,
> > it's a good way of checking whether your dependencies have been merged
> > yet or not, seeing what survives a rebase).
> 
> I don't see the logic. You shouldn't need to rebase at all. I don't see 
> why you claim that this makes rebasing more of a fact. It doesn't. It has 
> no impact at all, except making rebasing _less_ possible!

Well, it came at me because Jens was rebasing the block tree as he
worked through issues in the two branches I was based on.  If the block
tree hadn't rebased, I wouldn't have rebased that often.  However, we
did come across other things that had to move from my tree to Jens' as
we developed this, mainly bug fixes moving closer to the source to
preserve bisectability, and in that case rebases were really necessary.

James


