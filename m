Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYIVSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYIVSwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYIVSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:52:12 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:40404 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbYIVSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:52:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEABOE10hMQWq+/2dsb2JhbACBXbY/gWY
Date: Mon, 22 Sep 2008 14:52:09 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080922185209.GC6349@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com> <20080920135548.GB23215@Krystal> <20080920071232.46908040@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080920071232.46908040@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:46:40 up 109 days, 23:27,  7 users,  load average: 1.06, 0.71,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Sat, 20 Sep 2008 09:55:48 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > How about :
> > 
> >   trace_mark(ftrace_evname, "size %lu binary %pW",
> >     sizeof(mystruct), mystruct);
> >   or
> >   trace_mark(sched_wakeup, "target_pid %ld", task->pid);
> > 
> > Note the namespacing with buffers being "ftrace" and "sched" here.
> > 
> > That would encapsulate the whole
> >   - Event ID registration
> >   - Event type registration
> >   - Sending data out
> >   - Enabling the event source directly at the source
> > 
> > We can then export the markers through a debugfs file and let userland
> > enable them one by one and possibly connect systemtap filters on them
> > (one table of registered filters, one table for the markers, a command
> > file to connect/disconnect filters to/from markers).
> 
> I would like to ask for the following from the start: have a field for
> a longer description of the marker that describes it's usage and
> context. Getting this there from the start is critical, because only
> when adding the marker point do people still really remember why/what
> (and having to type a good description also helps them to realize if
> this is the right point or not). This can then be exposed to the user
> so he has a standing chance of knowing what the marker is about.
> 
> It also has a standing chance of being updated when the code changes
> this way
> 

I agree, and I think it might be required in both markers and
tracepoints.

Given that tracepoints are declared in a global header
(DECLARE_TRACE()), I would add this kind of description here. Tracepoint
uses within the kernel code (statements like :
  trace_sched_switch(prev, next);
added to the scheduler) would therefore be tied to the description
without having to contain it in the core kernel code.

Markers, on the other hand, could become the "event description"
interface which is exported to userspace. Considering that, I guess it's
as important to let a precise description follow the markers.

Mathieu


> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
