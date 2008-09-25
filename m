Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYIYQyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYIYQyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYIYQx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:53:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYIYQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:53:58 -0400
Date: Thu, 25 Sep 2008 12:53:49 -0400 (EDT)
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
In-Reply-To: <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Linus Torvalds wrote:
> 
> Not only that, but have you forgotten about FTRACE and -pg? Which means 
> that every single C function calls into tracing code, and that can 
> basically only be disabled on a per-file basis? 

Slight correction. You can annotate the function with "notrace" and 
that function will not be traced. So the "only be disabled on a per-file
basis" statement is false.

> 
> Yeah, it would probably cause some code duplication, but the low-leel 
> trace infrastructure really is special. It can't afford to call other 
> subsystems helper functions, because people want to trace _those_.

Currently my code calls "ring_buffer_time_stamp" to get the time stamp, 
whatever it will be.  Currently it is using sched_clock, but since I have 
it as a wrapper, it shouldn't be too hard to modify later.

I'll also add a "ring_buffer_time_stamp_normalize(ts)" function to be 
called on reading of the trace. This will normalize whatever time stamp 
that we use back to ns for the users. For now it will just return "ts" 
since sched_clock is already normalize.

IOW, for my current work, I don't care what timing we use. Others do, and 
I will try to make the tracing infrastructure let it be easy to change 
what is used. For now, I'm concentrating on the infrastructure itself.

-- Steve

