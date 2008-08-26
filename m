Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYHZMvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYHZMvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYHZMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:51:11 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48875 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754577AbYHZMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:51:10 -0400
Date: Tue, 26 Aug 2008 08:50:57 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080826125057.GC8720@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
	Dario Faggioli <raistlin@linux.it>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de> <200808262127.26803.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808262127.26803.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:27:26PM +1000, Nick Piggin wrote:
> 
> Oh with this much handwaving from you old timers I feel much better
> about it ;) I bet before the bug report and change to 10s, any
> application that hogged the CPU for more than 0.9 seconds was just
> broken too, right? But 10s is more than enough for everybody?
> 

Actually, any real-time application which hogs the CPU at a high
real-time priority for more than one second is probably doing
something broken.  The whole point of high real-time priorities is to
do something really fast, get in and get out.  Usually such routines
are measured in milliseconds or microseconds.

Think about it *this* way --- what would you think of some device
driver which hogged an interrupt for a full second, never mind 10
seconds.  You'd say it was broken, right?  Now consider that a high
real-time priority thread might be running at a higher priority than
interrupt handlers, and in fact could preempt interrupt handlers....

> > Simply because we use common sense instead of following every single
> > POSIX brainfart by the letter.
> 
> How is that a brainfart? It is simple, relatively unambiguous, and not
> arbitrary. You really say the POSIX specified behaviour is "a brainfart",
> but adding an arbitrary 10s throttle "but the process might be preempted
> and lose the CPU to a lower priority task if it uses 10s of consecutive
> CPU time" would eliminate that brainfart? I have to laugh.

We've not followed POSIX before when it hasn't made sense.  For
example, "df" and "du" report its output in kilobytes, instead of 512
byte sectors, per POSIX's demands.

> root is allowed to shoot themselves in the foot. root is the safeguard.

We've done things before to make things harder for root; for example
we've restricted what /dev/mem can do.  And root can always lift the
ulimit.

						- Ted
