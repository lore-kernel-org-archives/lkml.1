Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYIZX5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYIZX5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYIZX5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:57:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYIZX5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:57:14 -0400
Date: Fri, 26 Sep 2008 19:56:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Travis <travis@sgi.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <48DD61F4.3000704@sgi.com>
Message-ID: <alpine.DEB.1.10.0809261956000.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <1222456474.16700.289.camel@lappy.programming.kicks-ass.net> <48DD61F4.3000704@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Mike Travis wrote:

> Peter Zijlstra wrote:
> > On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
> >> +struct ring_buffer {
> >> +       unsigned long           size;
> >> +       unsigned                pages;
> >> +       unsigned                flags;
> >> +       int                     cpus;
> >> +       atomic_t                record_disabled;
> >> +
> >> +       struct mutex            mutex;
> >> +
> >> +       /* FIXME: this should be online CPUS */
> >> +       struct ring_buffer_per_cpu *buffers[NR_CPUS];
> > 
> > actually nr_possible makes sense, and you might consider always
> > allocating buffers (and keeping them for offlined cpus) to avoid massive
> > allocations/frees cpu-hotplug events.
> > 
> > Mike Travis has been going over the kernel removing constructs like
> > this, and replacing them with dynamically allocated arrays of
> > nr_possible.
> > 
> >> +};
> 
> The other thing to consider is using a percpu variable.

This structure is allocated on request.

-- Steve

