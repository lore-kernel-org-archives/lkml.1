Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYI0RiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYI0RiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYI0RiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:38:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYI0RiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:38:17 -0400
Date: Sat, 27 Sep 2008 13:38:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080927171640.GA1990@elte.hu>
Message-ID: <alpine.DEB.1.10.0809271335001.10534@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
 <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu> <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org> <20080925221441.GA29060@elte.hu> <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org>
 <20080927171640.GA1990@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Sep 2008, Ingo Molnar wrote:
> 
> If all you do is to trace high-freq events on all CPUs and you are _not_ 
> interested in the precise interactions, the overhead of global 
> synchronization can hurt a lot.
> 
> In any case, SMP coherency of trace events is an independent property of 
> the tracer, and preferably something that can be turned on/off.

Just a note.  The current ring buffering system that I'm proposing keeps 
its own time stamp counter (currently sched_clock) that will most likely 
be updated later. I'm trying to keep this ring buffer system as dumb as 
possible. It does not even implement the merge sort. That's up to the 
tracer to handle. There's nothing stopping the trace from adding some 
atomic counter to each event to help it sort.

So yes, the tracer can implement anything it wants on top of the ring 
buffer ;-)

-- Steve

