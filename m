Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbYEEWM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbYEEWM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYEEWMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:12:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28154 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYEEWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:12:15 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
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
	 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>
	 <1210013938.17132.55.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Mon, 05 May 2008 15:12:12 -0700
Message-Id: <1210025532.17132.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 23:01 +0200, Thomas Gleixner wrote:
> Dan
> Dropping architectures just for the sake of bisectability does more
> harm than good.
> 
> We never dropped architecture support due to a rewrite in course of
> the whole preempt-rt series. We never dropped architecture support
> when we made parts of the code ready for upstream and made it
> bisectable.
> 
> Keeping the architecture ports even in a maybe disfunctional state in
> the queue is important as we move them along and make the obvious
> changes to them so anyone interested to bring them up to date has not
> to start from scratch again, which is a major PITA (we just did one
> from scratch)

In open source code never dies. So I'm not sure where this "From
scratch" stuff is coming from .. 

I've done ports from scratch and it's not that bad.. Not sure what your
porting too.. It would also be a lot easier to do an arch port piece by
piece under a bisectable tree.

I think dropping ports (temporarily) is perfectly reasonable. There is
no reason to hamper forward development just to keep old architecture
ports in the tree.

> With half of the functionality dropped, renames along the line so it
> can not be verified whether it ends up to be the same code as it was
> before. If you really want to make it bisectable then apply the
> necessary rename patches to the queue first, make sure that it does
> not result in a code change and then refactor the whole thing.

I just review code and boot it in various ways. I don't think binary
compatibility is needed for this. For most code that exists, and most
cases in open source it's not needed either.

> We have been there before. kernel development does not follow the "we
> want _now_" principle at all. Have you ever tried to yell at Linus "we
> want XYZ _now_" ? If you decide to try it, please keep me on CC - I
> want to enjoy the show.

Kernel development is "What is available now?" not what is avaiable in
the future.

If you want to reject code you better have a reason other than "We're
going to make some new code for that (some time in the future) sorry."

I'd like to hear Linus come out and say, "Sorry Thomas we can't include
your HRT cause we're getting a newer HRT in three years, so sorry about
that."

I'm not the one that suffers if Steven doesn't include some sort of
bisect change, the users suffer, development suffers.

> Sure, we are happy to trade a queue which has major updates of code
> close to mainline integration and has preserved the existing
> architecture support for some bisectable artifact.
> 
> We went through this kind of discussion several times in the past and
> you still seem to believe that you can impose your POV on project
> maintainers.
> 
> Again, that's not the way it works. 

Sure it is.. When a maintainer makes a mistake I better speak up, or
they're gonna make a mess of things .. That's a huge chunk of the
process.

> Exactly, for the majority of problems with preempt-rt, reporting the
> bug and waiting for the person who is able to decode it is the only
> choice. The hard to decode problems like subtle races are not
> decodable by bisection.
> 
> Bisectable problems are pretty rare, because most of the problems are
> with PREEMPT_RT, which is a disruptive new feature that only gets
> activated late in the queue.

I don't agree with that .. We don't have bisection you can't even back
up the claim .. Had bisection been an option I'm sure it would have been
used.

Daniel

