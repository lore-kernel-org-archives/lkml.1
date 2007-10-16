Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbXJPI5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbXJPI5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbXJPI5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:57:06 -0400
Received: from mx2.go2.pl ([193.17.41.42]:36610 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759109AbXJPI5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:57:04 -0400
Date: Tue, 16 Oct 2007 11:00:05 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071016090005.GC1000@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org> <20071015074405.GA1875@ff.dom.local> <20071015080924.GA32562@wotan.suse.de> <20071015090959.GB1875@ff.dom.local> <20071016005033.GB5851@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016005033.GB5851@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 02:50:33AM +0200, Nick Piggin wrote:
> On Mon, Oct 15, 2007 at 11:10:00AM +0200, Jarek Poplawski wrote:
...
> > I'm not performance-words at all, so I can't help you, sorry. But, I
> > understand people who care about this, and think there is a popular
> > conviction barriers and locked instructions are costly, so I'm
> > surprised there is any "problem" now with finding these gains...
> 
> It's more expensive than nothing, sure. However in real code, algorithmic
> complexity, cache misses and cacheline bouncing tend to be much bigger
> issues.
> 
> I can't think of a place in the kernel where smp_rmb matters _that_ much.
> seqlocks maybe (timers, dcache lookup), vmscan... Obviously removing the
> lfence is not going to hurt. Maybe we even gain 0.01% performance in
> someone's workload.
> 
> Also, remember: if loads are already in-order, then lfence is a noop,
> right? (in practice it seems to have to do a _little_ bit of work, but
> it's like a dozen cycles).

You are right: considering current CPUs there could be no performance
problem at all. Removing LOCKs for older ones should probably matter
more, but as a matter of fact, now I wouldn't bet even on this - it
could be mostly noop as well.

> > As a matter of fact it's not natural for me at all. I expected the
> > other direction, and I still doubt programmers' intentions could be
> > "automatically" predicted good enough, so IMHO, it's not for long.
> 
> Really? Consider the consequences if, instead of releasing this latest
> document tightening consistency, Intel found that out of order loads
> were worth 5% more performance and implemented them in their next chip.
> The chip could be completely backwards compatible, but all your old code
> would break, because it was broken to begin with (because it was outside
> the spec).

I've different opinion on this: I expect any spec to describe current
implementation. Before issuing new models any changes of
implementation should be made public with proper margin of time. Then
system could be optimally adjusted to a real hardware, instead of
planned only, but possibly never realized (plus doing such not used
things with old means is usually more costly: lock vs. lfence). There
is still problem of specs' completness: there are probably often some
things unspecified which could brake on a new model, so never 100%
guarantee anyway.

> IMO Intel did exactly the right thing from an engineering perspective,
> and so did Linux to always follow the spec.

But, if you follow the spec - you don't follow the spec! Why do you
ignore so much this part of Intel's spec:

 "This document contains information which Intel may change at any
  time without notice. Do not finalize a design with this information."

Maybe it's a real Intel intention and not for lawyers only? (Btw, it
seems we have an example.)

Regards,
Jarek P.
