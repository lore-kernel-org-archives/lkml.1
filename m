Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYJBW2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYJBW2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYJBW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:28:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYJBW2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:28:40 -0400
Date: Thu, 2 Oct 2008 18:28:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <1222983008.2995.205.camel@laptop-eth>
Message-ID: <alpine.DEB.1.10.0810021749230.24442@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>  <1222912413.2995.80.camel@laptop-eth.lan>  <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>  <1222962525.2995.100.camel@laptop-eth>  <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
  <1222974254.2995.144.camel@laptop-eth>  <20081002192827.GA2950@elte.hu>  <1222978145.2995.172.camel@laptop-eth>  <alpine.DEB.1.10.0810021612280.2919@gandalf.stny.rr.com>  <1222980485.2995.186.camel@laptop-eth>  <alpine.DEB.1.10.0810021652370.24442@gandalf.stny.rr.com>
 <1222983008.2995.205.camel@laptop-eth>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Oct 2008, Daniel Walker wrote:

> On Thu, 2008-10-02 at 17:05 -0400, Steven Rostedt wrote:
> 
> > Why are you bringing up real time in this thread?? The thread has
> > absolutely nothing to do with real time. This thread is about a better
> > way to handle interrupt handlers.
> 
> I'm concerned about the connection between the two, which is what I'm
> commenting on.

Well, please take that up separately. Do you see these patches going
into the -rt tree?  No, they are going in mainline. We will deal with
them for -rt when the time comes.

> 
> > > 
> > > I also don't see a clear connection between these changes and ultimately
> > > removing spinlock level latency in the kernel. I realize you don't
> > > address that in your comments, but this is part of the initiative to
> > > remove spinlock level latency..
> > 
> > Again, this thread has nothing to do with removing spinlock level latency.
> > The reason Thomas did not address this is because it is OFF TOPIC!!!!
> 
> If they are connected (which I think we established) , then it's not out
> of line for me to discuss the direction of these changes as related to
> other components of real time.

You are bringing up concerns about mainline changes with something that
is maintained outside the mainline tree.  Changes to mainline have never
been influenced by changes maintained outside of mainline.

> 
> > > 
> > > So with this set of changes and in terms of real time, I'm wonder your
> > > going with this ?
> > 
> > You brought in this relationship with real time, just because real time 
> > uses threaded interrupts. This thread has nothing to do with real time. 
> > That is what Ingo, Thomas and myself are trying to ge through to you.
> 
> You know Steven, often times you start a conversation and you have no
> idea where it will end up.. You can't always control which direction it
> will go..

Yes Daniel, I know. But this is not a conversation. This is a email thread
that is talking about changes to mainline. The mainline kernel developers
really don't care about any issues that these changes will do to the
real time project. The real time project is a niche, and is currently
outside the mainline tree. Hence, lets stop bothering mainline 
developers with our issues.

> 
> > The strong reaction from Thomas is that you just brought up something that 
> > is completely off topic.
> 
> We already debated this fact Steven. real time and this type of
> threading are connected. It's not off topic to discuss connected
> components.

No Daniel, it is off topic.  The thread is not about real time issues.
This thread is about mainline. If you have an issue that these changes
will make to the current mainline tree, then please, by all means, bring
them up. But do not bring up issues that only affect outside of mainline.

> 
> If the intent here is to totally disconnect these threading patches from
> any type of real time in the future, then that's a good answer to my
> original question .. That these changes have no future what so ever in
> regards to real time.

No the intent here is to handle mainline issues. The real time issues you
consistantly bring up are not important to most kernel developers. If
you have real time issues with this change, bring that up on a real 
time forum. Not in this thread.  The changes in this thread are dealing
with mainline interrupt handlers. There have been several kernel device 
driver writers who asked us to get interrupt threads in mainline. This was 
not about real time, this was about helping out mainline kernel 
developers.

> 
> If they will be used in the future for real time then we should discuss
> it. I don't think that's off topic at all.
> 
> > Basically, drop the real time topic from this thread. It's not related. 
> > Yes real time addresses threaded interrupts, but just because we are 
> > talking about threaded interrupts does not mean we are talking about real 
> > time.
> 
> I don't see why you are so concerned with this.. Real time is taboo now?

Not at all, Daniel, but this thread is not the appropriate place to 
discuss your real time concerns. You are asking about what this patch has 
to do with the future real time direction. Who on this thread cares?
(besides you)

The topic for mainline patch threads needs to stay focused on mainline. 
Not on out of tree branches. When the rest of real time is in mainline, 
then sure, you can discuss those concerns then. But until that happens, 
keep to the topic of the thread. Which for now is not real time.

-- Steve

