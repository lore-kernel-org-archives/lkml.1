Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYI0Aw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYI0Aw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYI0AwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:52:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58066 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYI0AwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:52:20 -0400
Date: Fri, 26 Sep 2008 20:52:18 -0400 (EDT)
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
In-Reply-To: <48DD8263.8020205@sgi.com>
Message-ID: <alpine.DEB.1.10.0809262051300.29360@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <1222456474.16700.289.camel@lappy.programming.kicks-ass.net> <48DD61F4.3000704@sgi.com> <alpine.DEB.1.10.0809261956000.21618@gandalf.stny.rr.com> <48DD78C6.5030701@sgi.com>
 <alpine.DEB.1.10.0809262012160.21618@gandalf.stny.rr.com> <48DD8263.8020205@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Mike Travis wrote:
> Steven Rostedt wrote:
> > 
> > But to lay the ground work, I set a buffers->cpumask to be that of all the 
> > cpus with buffers allocated. For now that mask is set to cpu_possible_map. 
> > Since num_possible_cpus() is defined as cpus_weight_nr(cpu_possible_map) 
> > I figured that was the better choice.
> > 
> > -- Steve
> 
> One problem though, it's *theoretically* possible for num_possible to be
> less than nr_cpu_ids and a cpu index may extend past the end of your
> allocated array.  This would happen if  the cpu indices are allocated
> some other way than as each cpu is discovered.  For example, a system
> might want a group of cpus in one section (say by node, or socket) and
> then a hole in the cpu_possible_map until the next group.  nr_cpu_ids
> is guaranteed to be the highest possible cpu + 1.

Thanks for the explanation. I'll change buffer->cpus to be set to 
nr_cpu_ids.

-- Steve

