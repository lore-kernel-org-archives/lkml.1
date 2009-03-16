Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbZCPTXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbZCPTXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZCPTXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:23:21 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:34584 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbZCPTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:23:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsEAPc/vklMQW1W/2dsb2JhbACBTtN7g38G
Date: Mon, 16 Mar 2009 15:23:05 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090316192305.GB11878@Krystal>
References: <20090312183603.GC3352@redhat.com> <20090314025701.GC22526@Krystal> <alpine.DEB.2.00.0903160934010.26431@gandalf.stny.rr.com> <20090316183739.GA10292@Krystal> <alpine.DEB.2.00.0903161441210.27978@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903161441210.27978@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:21:35 up 16 days, 15:47,  3 users,  load average: 0.96, 0.69,
	0.67
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 16 Mar 2009, Mathieu Desnoyers wrote:
> > > > 
> > > > The softirq tracepoints are a good idea indeed (I have similar ones in
> > > > the LTTng tree). My main concern is about the fact that you output the
> > > > softirq name in plain text to the trace buffers. I would rather prefer
> > > > to save only the softirq (h-vec) into the trace and dump the mapping
> > > > (h-vec) to name only once, so we can save precious trace bytes.
> > > 
> > > The TP_FMT is only used by those tracers that want to use it. Any tracer 
> > > can still hook directly to the trace point and do what every they want.
> > > 
> > > -- Steve
> > > 
> > 
> > By doing so, you are removing the ability to use the TP_FMT information
> > to perform high-speed system-wide tracing. I thought the goal was to
> > create a unified buffering, but sadly I don't see the high-speed
> > requirements being part of that plan.
> 
> TP_FMT has nothing to do with the unified buffering. The unified buffer 
> does not even know about it. But if you want high-speed event tracing, 
> that is what the TRACE_EVENT was created for.
> 
> The TRACE_FORMAT was made for things that will be recording string 
> information anyway, and recording a string into the buffer via memcpy or a 
> sprintf format (binary printk) doesn't make much difference.
> 

Are you saying that dynamically parsing a format string in a binary
printk has the same performance impact as a memcpy ? I would be very
interested to see your benchmarks.

Mathieu

> Then trace points for entry and exit does not fall into that category, and 
> should be represented by a TRACE_EVENT instead.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
