Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYIZV00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYIZV00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYIZV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:26:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYIZV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:26:17 -0400
Date: Fri, 26 Sep 2008 17:26:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <48DD50AB.10208@redhat.com>
Message-ID: <alpine.DEB.1.10.0809261724000.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <1222459730.16700.295.camel@lappy.programming.kicks-ass.net> <48DD50AB.10208@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Masami Hiramatsu wrote:

> Peter Zijlstra wrote:
> > On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
> >> +static void
> >> +rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned
> >> nr_pages)
> >> +{
> >> +       struct page *page;
> >> +       struct list_head *p;
> >> +       unsigned i;
> >> +
> >> +       atomic_inc(&cpu_buffer->record_disabled);
> > 
> > You probably want synchronize_sched() here (and similar other places) to
> > ensure any active writer on the corresponding cpu is actually stopped.
> 
> Would it really be done in the buffer layer?
> I think it should be done by each tracer, because buffer layer
> can't ensure truly active writers have stopped.
> 

Actually it can ;-)

Since all writes to the buffer at least disable preemption, by issuing a 
synchronize_sched, we can guarantee that after disabling the record, all 
activity will be done.

-- Steve

