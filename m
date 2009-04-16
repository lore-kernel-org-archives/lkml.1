Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZDPRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZDPRfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZDPRfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:35:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbZDPRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:35:08 -0400
Date: Thu, 16 Apr 2009 13:34:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@lst.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 4/4] tracing/events: add trace-events-sample
In-Reply-To: <20090416165849.GF5933@lst.de>
Message-ID: <alpine.DEB.2.00.0904161331050.20429@gandalf.stny.rr.com>
References: <20090415031511.128139334@goodmis.org> <20090415031605.445499740@goodmis.org> <20090416165849.GF5933@lst.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Christoph Hellwig wrote:

> On Tue, Apr 14, 2009 at 11:15:15PM -0400, Steven Rostedt wrote:
> > +++ b/samples/trace_events/Makefile
> > @@ -0,0 +1,8 @@
> > +# builds the trace events example kernel modules;
> > +# then to use one (as root):  insmod <module_name.ko>
> > +
> > +PWD := $(shell pwd)
> > +
> > +CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
> 
> CFLAGS_trace-events-sample.o += -I$(src)

Is $(src) defined to be where the object is compiled?

> 
> That should better be written as.  But you'd easily get rid of that
> by just including the file using #include "foo.h" instead of <foo.h>,
> no?

That is for the define_trace.h to find the file. The define_trace.h will 
look from where it is located. ie. include/trace


> 
> > --- /dev/null
> > +++ b/samples/trace_events/trace-events-sample.h
> > @@ -0,0 +1,124 @@
> > +/*
> > + * Notice that this file is not protected like a normal header.
> > + * We also must allow for rereading of this file. The
> > + *
> > + *  || defined(TRACE_HEADER_MULTI_READ)
> > + *
> > + * serves this purpose.
> > + */
> > +#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_EVENT_SAMPLE_H
> 
> Why do we need this protection at all?  It only be included by the users
> of the tracepoints, and it seems just fair to take some more than normal
> precaution for more than unusual magic headers.

This was needed for kmem.h because it was causing header recursive hell.
But instead of doing this for just a few headers, having it in all was a 
way to be:

1) safe

2) descriptive

#2 is because people are use to the #ifndef _MY_HEADER_H  and seeing that 
there is also a TRACE_HEADER_MULTI_READ it makes it obvious that this 
header may be included more than once, purposefully.

-- Steve

