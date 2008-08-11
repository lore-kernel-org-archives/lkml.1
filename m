Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbYHKMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbYHKMdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHKMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:33:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYHKMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:33:13 -0400
Date: Mon, 11 Aug 2008 08:33:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <200808111241.23686.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0808110829490.15650@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <200808111241.23686.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 Aug 2008, Rusty Russell wrote:

> On Saturday 09 August 2008 04:41:06 Steven Rostedt wrote:
> > On Fri, 8 Aug 2008, Mathieu Desnoyers wrote:
> > > kstop_machine does not guarantee that you won't have _any_ thread
> > > preempted with IP pointing exactly in the middle of your instructions
> > > _before_ the modification scheduled back in _after_ the modification and
> > > thus causing an illegal instruction.
> > >
> > > Still buggy. :/
> >
> > Hmm, good point. Unless...
> 
> You can walk the task list and fix them up, if you have to.  Of course, this 
> could be extremely slow with a million threads.  Maybe just walking the 
> runqueues would be sufficient?

True, we could do the run queues too. But we are only looping once 
through the tasks and checking a single pointer on it, which would only be 
set if the task was preempted while in the kernel.

As for being slow, this only happens when we enable the function tracer, 
which is slow anyway. It does not need to happen on disabling the tracer.

Note, this is enabling the calls to the tracer function. The tracer itself 
can enable and disable quickly by turning on or off a variable. This is 
just the "setup" part. Not something that happens often.

-- Steve

