Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYIYUhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYIYUhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYIYUhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:37:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYIYUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:37:00 -0400
Date: Thu, 25 Sep 2008 13:29:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
 <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
 <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Linus Torvalds wrote:
> 
> You also ignore the early trace issues, and have apparently not used it 
> for FTRACE. You also ignore the fact that without TSC, it goes into the 
> same "crap mode" that is appropriate for the scheduler, but totally 
> useless for tracing.

Oh, and I didn't notice (because Steven pointed out "notrace" and I didn't 
see any of them), that in order to get things to work you had just added

CFLAGS_REMOVE_lockdep.o = -pg
CFLAGS_REMOVE_lockdep_proc.o = -pg
CFLAGS_REMOVE_mutex-debug.o = -pg
CFLAGS_REMOVE_rtmutex-debug.o = -pg
CFLAGS_REMOVE_cgroup-debug.o = -pg
CFLAGS_REMOVE_sched_clock.o = -pg
CFLAGS_REMOVE_sched.o = -mno-spe -pg

all ovr the place, which was part of my argument against this crap in the 
first place.

Yes, by using all that common infrastructure, you can share some code, but 
you will always hit that case that now you have serious issues with 
actually marking it. Now the tracer has to have recursion detection if you 
ever want to trace any function that might be used for the clock - and 
quite frankly, especially with virtualization, it's not AT ALL obvious 
what those are all the time..

That is exactly one of the examples I gave for _not_ doing this. Go back 
and read my previous emails. Rather than talking about how I call your 
arguments BS without saying why.

			Linus
