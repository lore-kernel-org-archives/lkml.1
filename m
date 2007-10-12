Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXJLLwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXJLLwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXJLLwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:52:21 -0400
Received: from mx2.go2.pl ([193.17.41.42]:48265 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754817AbXJLLwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:52:20 -0400
Date: Fri, 12 Oct 2007 13:55:10 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012115510.GF1962@ff.dom.local>
References: <20071004052348.GC15131@wotan.suse.de> <20071012082534.GB1962@ff.dom.local> <20071012085733.GA19237@wotan.suse.de> <20071012095505.GD1962@ff.dom.local> <20071012104238.GD19237@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012104238.GD19237@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 12:42:38PM +0200, Nick Piggin wrote:
> On Fri, Oct 12, 2007 at 11:55:05AM +0200, Jarek Poplawski wrote:
> > On Fri, Oct 12, 2007 at 10:57:33AM +0200, Nick Piggin wrote:
> > > 
> > > I don't know quite what you're saying... the CPUs could probably get
> > > performance by having weakly ordered loads, OTOH I think the Intel
> > > ones might already do this speculatively so they appear in order but
> > > essentially have the performance of weak order.
> > 
> > I meant: if there is any reordering possible this should be quite
> > distinctly visible.
> 
> It's not. Not in the cases where it is explicitly allowed and actively
> exploited (loads passing stores), but most definitely not distinctly
> visible in errata cases that have slipped through all the V&V.
> 
> 
> > because why would any vendor enable such nasty
> > things if not for performance. But now I start to doubt: of course
> > there is such a possibility someone makes this reordering for some
> > other reasons which could be so rare it's hard to check.
> 
> Yes: it isn't the explicitly allowed reorderings that we care
> about here (because obviously we're retaining the barriers for those).
> It would be cases of bugs in the CPUs meaning they don't follow the
> standard. But how far do you take your mistrust of a CPU? You could
> ask gcc to insert locked ops between every load and store operation?
> Or keep it switched off to ensure no bugs ;)

I'm not sure of your point, but it seems we don't differ here, and
after all there is quirks code for such things.

> 
> 
> > Anyway, it seems any heavy testing such as yours, should give us the
> > same informations years earlier than any vendors manual and then any
> > gain is multiplied by millions of users. Then only still doubtful
> > cases could be treated with additional caution and some debugging
> > code.
> 
> Firstly, while it can be possible to write a code to show up reordering,
> it is really hard (ie. impossible) to guarantee no reordering happens. For
> example, it may have only showed up on SMT+SMP P4 CPUs with some obscure
> interactions between threads and cores involving more than 2 threads.

I'm not sure how much this all above is consistent wrt. this earlier
opinion:

> [...] If you can actually come up with a test
> case that triggers load/load or store/store reordering, I'm sure
> Intel / AMD would like to see it ;)

It seems, after testing only (plus no official spec against this idea),
you could be almost sure there is no such test possible. And, if it
were done a few years ago, you think it still should be not enough to
make a decision on changing this smp_rmb because of lack of official
specs? Besides, there is probably so much features guessing in arch
and drivers sections, this reorder testing should look as solid as a
math proof wrt. them.

> 
> Secondly, even if we were sure that no current implementations reordered
> loads, we don't want to go outside the bounds of the specification
> because we might break on some future CPUs. This isn't a big performance
> win.

I don't agree with this - IMO we should care only about currently used
CPUs, and test each time the new ones.


> > > All existing processors as far as we know are in-order WRT loads vs
> > > loads and stores vs stores. It was just a matter of getting the docs
> > > clarified, which gives us more confidence that we're correct and a
> > > reasonable guarnatee of forward compatibility.
> > 
> > After reading this Intel's legal information I don't think you should
> > feel so much more forward confident...
> 
> Yes, but that's the same way I feel after reading *any* legal "information" ;)
> 

Strange... I feel exactly opposite. Are you sure you've chosen the
right job (...and the right system)?

Jarek P.
