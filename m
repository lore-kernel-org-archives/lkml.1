Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYJIXNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYJIXNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYJIXM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:12:56 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:46387 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbYJIXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:12:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAK8s7khMQWq+/2dsb2JhbACBcr4XgWo
Date: Thu, 9 Oct 2008 19:12:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Building a tracing userspace tool in the kernel tree
Message-ID: <20081009231253.GA7788@Krystal>
References: <20081009191626.GA29344@Krystal> <1223590513.7382.45.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1223590513.7382.45.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:07:01 up 127 days,  3:47,  7 users,  load average: 0.23, 0.48,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Thu, 2008-10-09 at 15:16 -0400, Mathieu Desnoyers wrote:
> > Hi Sam,
> > 
> > At the kernel summit, people seemed to be interested to have the basic
> > userspace tools required to extract and pretty-print a trace available
> > within the kernel tree. Therefore, what I am trying to do is something
> > along the lines of
> > 
> > ltt/usr/
> > ltt/usr/tracectl/    (control tracing)
> > ltt/usr/tracesplice/ (splice buffers to disk)
> > ltt/usr/tracecat/    (merge sort and format the binary buffers into
> >                       human-readable text)
> 
> I'd rather have you provide that interface from the kernel much like
> ftrace does. So we can do:
> 
> # cat /debug/tracing/lttng/trace
> 

Hi Peter,

Following our earlier design discussions, the "tracectl" program will
be easily replaceable by a debugfs interface. For now, I plan to ship my
current netlink-based tracer control version given this single kernel
module is trivially replaceable by the debugfs interface in a near
future.

On the other hand, cat won't give the sufficient performance expected
for tracing. This will be provided by "tracesplice" and "tracecat" which
will take care of exporting the binary buffer data to disk and to decode
it in a later stage (ideally off-line, after tracing has been done).

One of the next things on my todo list is to also provide an in-kernel
pretty printer which would extract the kernel buffers in text format.
But I don't expect this to be the high-speed tracer, but more a helper
facility to look at the content of "flight recorder" buffers.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
