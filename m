Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYHZNaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYHZNaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYHZNaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:30:08 -0400
Received: from server03.ke-net.com ([84.19.168.8]:38032 "EHLO
	server03.ke-net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYHZNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:30:07 -0400
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Stefani Seibold <stefani@seibold.net>
To: Theodore Tso <tytso@mit.edu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080826125057.GC8720@mit.edu>
References: <20080819103301.787700742@chello.nl>
	 <200808261954.47987.nickpiggin@yahoo.com.au>
	 <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
	 <200808262127.26803.nickpiggin@yahoo.com.au>
	 <20080826125057.GC8720@mit.edu>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 15:31:27 +0200
Message-Id: <1219757487.31371.19.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am Dienstag, den 26.08.2008, 08:50 -0400 schrieb Theodore Tso:
> On Tue, Aug 26, 2008 at 09:27:26PM +1000, Nick Piggin wrote:
> > 
> > Oh with this much handwaving from you old timers I feel much better
> > about it ;) I bet before the bug report and change to 10s, any
> > application that hogged the CPU for more than 0.9 seconds was just
> > broken too, right? But 10s is more than enough for everybody?
> > 

Sorry, the world of embedded programming is sometime stranger than in
theory. Normally it would not happen that a real-time process locks the
CPU for more than 1 sec. But in some circumstances, especially FPGA
initialisation and long term measurements it is possible that the
real-time process locks the cpu for more than a, sometime for more than
10 sec. If the embedded program has designed it in that way, this
behaviour is desired.


> Actually, any real-time application which hogs the CPU at a high
> real-time priority for more than one second is probably doing
> something broken.  The whole point of high real-time priorities is to
> do something really fast, get in and get out.  Usually such routines
> are measured in milliseconds or microseconds.


> Think about it *this* way --- what would you think of some device
> driver which hogged an interrupt for a full second, never mind 10
> seconds.  You'd say it was broken, right?  Now consider that a high
> real-time priority thread might be running at a higher priority than
> interrupt handlers, and in fact could preempt interrupt handlers....
> 
> > > Simply because we use common sense instead of following every single
> > > POSIX brainfart by the letter.
> > 
> > How is that a brainfart? It is simple, relatively unambiguous, and not
> > arbitrary. You really say the POSIX specified behaviour is "a brainfart",
> > but adding an arbitrary 10s throttle "but the process might be preempted
> > and lose the CPU to a lower priority task if it uses 10s of consecutive
> > CPU time" would eliminate that brainfart? I have to laugh.
> 
> We've not followed POSIX before when it hasn't made sense.  For
> example, "df" and "du" report its output in kilobytes, instead of 512
> byte sectors, per POSIX's demands.
> 

This has nothing to do with POSIX. It is standard real time behaviour.
RT Programming is a job like writing device drivers. U must know what
you do. 

Modify the scheduler in that way that a realtime process will give away
the CPU after a given time will certain break some embedded application.

Don't think only in desktop or enterprise LINUX boxes, there a much more
LINUX embedded devices on this planet and not less of them rely on the
old scheduler behaviour.
 
The LINUX base guideline is simple in that way, that the kernel will
never break userland applications.

> > root is allowed to shoot themselves in the foot. root is the safeguard.
> 
> We've done things before to make things harder for root; for example
> we've restricted what /dev/mem can do.  And root can always lift the
> ulimit.
> 
> 						- Ted

What coming at next? A device driver manager, which kills any driver
which use to much CPU resource? Or throttle/kicks off the responsible
driver if the hardware generates to many interrupts?

Kernel and embedded real time programmer should know what there do.

Stefani


