Return-Path: <linux-kernel-owner+w=401wt.eu-S1763639AbYEESpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763639AbYEESpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761988AbYEEScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:32:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761979AbYEEScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:32:09 -0400
Date: Mon, 5 May 2008 14:32:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210007084.17132.32.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com> 
 <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com> 
 <1210003265.17132.6.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com> 
 <1210004376.17132.14.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
 <1210007084.17132.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 May 2008, Daniel Walker wrote:

>
> That's really the point, you should have started with my version. I
> released my changes long before the 2.6.25 release.

Sorry Daniel but you never proved to me that your version didn't break
anything.  I'm not about to start with something that throws out all the
archs, espically when Thomas has a port of another arch ready for me.


>
> > >
> > > Bisection is also required for mainline integration ..
> >
> > Bisection is required for each element, we don't need it for the entire
> > tree (atm). If we waste our time making the entire tree fully bisectable,
> > then it will be a lot of work to maintain that bisectability when we
> > rewrite entire sections.
>
> Bisection is required for everything, every patch. I am giving you a
> bisect tree, there is no time wasted (only mine)..

But you still need to show that it didn't brake anything, which you have
not.

>
> I'm not following your logic Steven .. You want bisection , that means
> you should want to maintain it, and write code in the future which also
> bisects.

I'll admit I would like a bisectable tree, and patches that are submitted
are bisectable. But the patches are also moved around a bit to get
the queue ready for mainline. That moving itself can break the
bisectability of later patches.

>
> If someone submits code which doesn't bisect you kick it the same way
> it's kicked from mainline. That means future patches in -rt are ready
> for mainline which helps further the goal of mainline integration.

Patches that come in now are usually simple fixes. Major developments are
bisectable.

>
> > I am making it boot with certain parts intergrated. But my goal is not to
> > have every single patch compile and boot. We'll worry about that when we
> > need to push a part of the code in. But reality, what is there now, I can
> > guarantee will not be the code that is pushed when it is ready.
>
> What you guarantee to happen in the future is irrelevant .. We want
> bisection _now_ , not months from now..

Fine, produce your own tree, I'll produce mine.

>
> Bisection has lots of benefits, it's not just that one stupid
> requirement mainline has and no one really cares about.

There is some benefits, but one thing you forget about the -rt patch, is
that there's lots of variables.  A lot of bugs that I found in -rt is not
about a bad patch, but usually because of the way rt works (preemptible
spinlocks and interrupts as threads) that cause breakage, and a lot of
that breakage is from a change in upstream, not the patch series. Having
it bisectable doesn't always help.

-- Steve

