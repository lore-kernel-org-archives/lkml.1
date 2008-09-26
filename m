Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYIZB2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYIZB2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYIZB2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:28:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYIZB2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:28:34 -0400
Date: Thu, 25 Sep 2008 21:27:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <48DC382A.8000407@goop.org>
Message-ID: <alpine.DEB.1.10.0809252123580.8454@gandalf.stny.rr.com>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
 <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org>
 <48DC1338.6050107@goop.org> <20080925225558.GA5768@elte.hu> <48DC382A.8000407@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:
> 
> No, as I said:  "You just need to emit the current
> tsc+frequency+wallclock time before you emit any more delta records
> after the frequency change."
> 
> When an event which affects the tsc occurs, like a frequency change or
> pause, set a flag.  When you're next about to emit a delta, check the
> flag and emit new timing parameters (or instead).

This is where I get confused.  When do we add this to the trace buffer?
Every record (currently) records the delta time from the last event.
If a frequency changes, do we need to record the tuple at that moment?

If so, we have an issue. We can be in the middle of tracing the GTOD
and we can not recurse back into the GTOD for fear of deadlocking on
the GTOD spinlocks.

Do we add this data to the buffers when it happens?  This means every
allocated ring buffer (and yes you can have more than one), will need to
register a call back so that it can record this information into the
buffer.

Or am I just not getting it?

-- Steve

