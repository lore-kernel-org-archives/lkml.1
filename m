Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYIYUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYIYUrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYIYUrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:47:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46665 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYIYUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:47:24 -0400
Date: Thu, 25 Sep 2008 16:47:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251644260.32742@gandalf.stny.rr.com>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
 <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
 <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Linus Torvalds wrote:

> 
> CFLAGS_REMOVE_lockdep.o = -pg
> CFLAGS_REMOVE_lockdep_proc.o = -pg
> CFLAGS_REMOVE_mutex-debug.o = -pg
> CFLAGS_REMOVE_rtmutex-debug.o = -pg
> CFLAGS_REMOVE_cgroup-debug.o = -pg

The above I added because they just made the function tracer output
quite ugly and bloated.  The lockdep got messing when it was debugging
the locks used in the tracer that was tracing lockdep. The above had
nothing to do with what kind of clock we used.  We added recursion
protection, but it was still producing ugly output.

-- Steve


> CFLAGS_REMOVE_sched_clock.o = -pg
> CFLAGS_REMOVE_sched.o = -mno-spe -pg
> 
> all ovr the place, which was part of my argument against this crap in the 
> first place.
> 
