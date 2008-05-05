Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbYEEVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbYEEVDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYEEVDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:03:12 -0400
Received: from www.tglx.de ([62.245.132.106]:41453 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbYEEVDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:03:10 -0400
Date: Mon, 5 May 2008 23:01:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210013938.17132.55.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>  <1209753250.25628.34.camel@dd.thebigcorporation.com>  <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>  <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>  <1210003265.17132.6.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>  <1210004376.17132.14.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
  <1210007084.17132.32.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com> <1210013938.17132.55.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Mon, 5 May 2008, Daniel Walker wrote:
> Dropping the architectures is something you will need to do anyway for
> mainline integration. You'll have to do it for re-writes, and you'll
> have to do it for bisection .. Ultimately it a good thing. Additionally
> if you drop the architectures now you force people to test and re-port
> which mean the port are more likely to work. Right now you really have
> no idea of the condition of those ports.

Dropping architectures just for the sake of bisectability does more
harm than good.

We never dropped architecture support due to a rewrite in course of
the whole preempt-rt series. We never dropped architecture support
when we made parts of the code ready for upstream and made it
bisectable.

Keeping the architecture ports even in a maybe disfunctional state in
the queue is important as we move them along and make the obvious
changes to them so anyone interested to bring them up to date has not
to start from scratch again, which is a major PITA (we just did one
from scratch)

> > > > > Bisection is also required for mainline integration ..

Yes, and if you care to look at the code which was merged into
mainline, then you might notice that it was always made
bisectable. Usually it was rewritten pretty much as well.

> > > > Bisection is required for each element, we don't need it for the entire
> > > > tree (atm). If we waste our time making the entire tree fully bisectable,
> > > > then it will be a lot of work to maintain that bisectability when we
> > > > rewrite entire sections.
> > >
> > > Bisection is required for everything, every patch. I am giving you a
> > > bisect tree, there is no time wasted (only mine)..

With half of the functionality dropped, renames along the line so it
can not be verified whether it ends up to be the same code as it was
before. If you really want to make it bisectable then apply the
necessary rename patches to the queue first, make sure that it does
not result in a code change and then refactor the whole thing.

> > > What you guarantee to happen in the future is irrelevant .. We want
> > > bisection _now_ , not months from now..

We have been there before. kernel development does not follow the "we
want _now_" principle at all. Have you ever tried to yell at Linus "we
want XYZ _now_" ? If you decide to try it, please keep me on CC - I
want to enjoy the show.

> > Fine, produce your own tree, I'll produce mine.
> 
> I have my own tree already. Are you obsoleting your tree now?

Sure, we are happy to trade a queue which has major updates of code
close to mainline integration and has preserved the existing
architecture support for some bisectable artifact.

We went through this kind of discussion several times in the past and
you still seem to believe that you can impose your POV on project
maintainers.

Again, that's not the way it works. 

Nobody will object the refactoring of the queue when it is done in a
cooperative way. By creating a fact and trying to enforce it by any
means you'll only reap controversy and attention, not any real
progress.

> > There is some benefits, but one thing you forget about the -rt patch, is
> > that there's lots of variables.  A lot of bugs that I found in -rt is not
> > about a bad patch, but usually because of the way rt works (preemptible
> > spinlocks and interrupts as threads) that cause breakage, and a lot of
> > that breakage is from a change in upstream, not the patch series. Having
> > it bisectable doesn't always help.
> 
> Sure not everything can be bisected, but we don't currently have a
> choice to bisect or not too .. Users are left to report the bug and hope
> the right person sees it.

Exactly, for the majority of problems with preempt-rt, reporting the
bug and waiting for the person who is able to decode it is the only
choice. The hard to decode problems like subtle races are not
decodable by bisection.

Bisectable problems are pretty rare, because most of the problems are
with PREEMPT_RT, which is a disruptive new feature that only gets
activated late in the queue.

Again, we are of course not opposed to a cooperative effort to make
the queue fully bisectable - as long as it has no drawbacks. That
means gradual steps, which is not rocket science.

Thanks,

	tglx
