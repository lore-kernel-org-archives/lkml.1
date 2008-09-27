Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYI0ASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYI0ASZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYI0ASR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:18:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYI0ASR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:18:17 -0400
Date: Fri, 26 Sep 2008 20:18:14 -0400 (EDT)
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
In-Reply-To: <48DD78C6.5030701@sgi.com>
Message-ID: <alpine.DEB.1.10.0809262012160.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <1222456474.16700.289.camel@lappy.programming.kicks-ass.net> <48DD61F4.3000704@sgi.com> <alpine.DEB.1.10.0809261956000.21618@gandalf.stny.rr.com> <48DD78C6.5030701@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Mike Travis wrote:
> Steven Rostedt wrote:
> >> The other thing to consider is using a percpu variable.
> > 
> > This structure is allocated on request.
> > 
> > -- Steve
> 
> 
> Ahh, then it would need the yet to be added cpu_alloc() from Christoph.

We can always change this later.

> 
> Your best bet then is to allocate based on nr_cpu_ids.

Actually in this case I chose num_possible_cpus(). Reason being is that 
later I may add an interface to allow the user to select which CPUs they 
want to trace, and this will only allocate a subset of CPU buffers. 
(not going to implement that in the first release).

But to lay the ground work, I set a buffers->cpumask to be that of all the 
cpus with buffers allocated. For now that mask is set to cpu_possible_map. 
Since num_possible_cpus() is defined as cpus_weight_nr(cpu_possible_map) 
I figured that was the better choice.

-- Steve

