Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYIYSQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYIYSQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYIYSQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:16:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYIYSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:16:27 -0400
Date: Thu, 25 Sep 2008 11:14:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809251332540.29802@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809251112580.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> 
 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>  <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> 
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>  <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>  <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251120420.27300@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251010291.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251332540.29802@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Steven Rostedt wrote:
> 
> The one thing that seemed to me most apparent from talking to people
> at LPC, is that they want a simple ring buffer API. If every tracer that
> uses this must come up with its own time keeping management, I don't think
> this will be used at all (except by those that are maintaining tracers
> now).

No, no.

The timestamp code is all in the ring buffer code. That was why I refused 
to have the layering without it.

And hell no, nobody should *ever* read the "tsc_delta" fields etc. Those 
are entirely internal to the buffering. If any user _ever_ reads or writes 
those on its own, it's a bug, plain and simple.

So when you read trace events, you should get the event data and the 
timestamp from the trace buffer routines. Nobody should ever even _see_ 
the internal trace buffer implementation!

			Linus
