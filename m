Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbXJLKmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbXJLKmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbXJLKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:42:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:49746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXJLKmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:42:40 -0400
Date: Fri, 12 Oct 2007 12:42:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012104238.GD19237@wotan.suse.de>
References: <20071004052348.GC15131@wotan.suse.de> <20071012082534.GB1962@ff.dom.local> <20071012085733.GA19237@wotan.suse.de> <20071012095505.GD1962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012095505.GD1962@ff.dom.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 11:55:05AM +0200, Jarek Poplawski wrote:
> On Fri, Oct 12, 2007 at 10:57:33AM +0200, Nick Piggin wrote:
> > 
> > I don't know quite what you're saying... the CPUs could probably get
> > performance by having weakly ordered loads, OTOH I think the Intel
> > ones might already do this speculatively so they appear in order but
> > essentially have the performance of weak order.
> 
> I meant: if there is any reordering possible this should be quite
> distinctly visible.

It's not. Not in the cases where it is explicitly allowed and actively
exploited (loads passing stores), but most definitely not distinctly
visible in errata cases that have slipped through all the V&V.


> because why would any vendor enable such nasty
> things if not for performance. But now I start to doubt: of course
> there is such a possibility someone makes this reordering for some
> other reasons which could be so rare it's hard to check.

Yes: it isn't the explicitly allowed reorderings that we care
about here (because obviously we're retaining the barriers for those).
It would be cases of bugs in the CPUs meaning they don't follow the
standard. But how far do you take your mistrust of a CPU? You could
ask gcc to insert locked ops between every load and store operation?
Or keep it switched off to ensure no bugs ;)


> Anyway, it seems any heavy testing such as yours, should give us the
> same informations years earlier than any vendors manual and then any
> gain is multiplied by millions of users. Then only still doubtful
> cases could be treated with additional caution and some debugging
> code.

Firstly, while it can be possible to write a code to show up reordering,
it is really hard (ie. impossible) to guarantee no reordering happens. For
example, it may have only showed up on SMT+SMP P4 CPUs with some obscure
interactions between threads and cores involving more than 2 threads.

Secondly, even if we were sure that no current implementations reordered
loads, we don't want to go outside the bounds of the specification
because we might break on some future CPUs. This isn't a big performance
win.


> > All existing processors as far as we know are in-order WRT loads vs
> > loads and stores vs stores. It was just a matter of getting the docs
> > clarified, which gives us more confidence that we're correct and a
> > reasonable guarnatee of forward compatibility.
> 
> After reading this Intel's legal information I don't think you should
> feel so much more forward confident...

Yes, but that's the same way I feel after reading *any* legal "information" ;)

