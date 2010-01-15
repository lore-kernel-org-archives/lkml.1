Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0AONiT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136Ab0AONiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:38:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:36132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab0AONiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:38:18 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263561389.4244.410.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>
	 <20100115102645.GA22640@linux.vnet.ibm.com>
	 <1263551607.4244.379.camel@laptop>
	 <20100115130802.GC20658@linux.vnet.ibm.com>
	 <1263561389.4244.410.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 14:38:04 +0100
Message-ID: <1263562684.4244.419.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 14:16 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 18:38 +0530, Srikar Dronamraju wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2010-01-15 11:33:27]:
> > 
> > > 
> > > > Uprobes layer would need to be notified of process life-time events
> > > > like fork/clone/exec/exit. 
> > > 
> > > No so much the process lifetimes as the vma life times are interesting,
> > > placing a hook in the vm code to track that isn't too hard, 
> > > 
> > > > It also needs to know
> > > > 	-  when a breakpoint is hit
> > > > 	-  stop and resume a thread.
> > > 
> > > A simple hook in the trap code is done quickly enough, and no reason to
> > > stop the thread, its not going anywhere when it traps.
> > > 
> > > 
> > 
> > Some of the threads could be executing in the vicinity of the
> > breakpoint when it is getting inserted or deleted. Wont we need to
> > stop/quiesce those threads?
> 
> The easy answer it so use kstopmachine to patch the code, the slightly
> more complex would be using something like:
> 
>   http://lkml.org/lkml/2010/1/12/300

Also, since its userspace, can't you simply play games with the
pagetables? CoW a new private copy of the page and flip the pagetables
around to the new one, then flush the pagetables on all relevant cpus
and bob's your uncle.

(You might have to play some games with making the page RO to trap
intermediate accesses, but that should work I think)

