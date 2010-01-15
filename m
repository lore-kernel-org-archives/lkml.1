Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0AOLSc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128Ab0AOLSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:18:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:42833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab0AOLSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:18:31 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: maneesh@in.ibm.com
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263553955.4244.393.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>
	 <20100115102645.GA22640@linux.vnet.ibm.com>
	 <1263551607.4244.379.camel@laptop>  <20100115110547.GB3660@in.ibm.com>
	 <1263553955.4244.393.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 12:18:04 +0100
Message-ID: <1263554284.4244.396.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 12:12 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 16:35 +0530, Maneesh Soni wrote:
> > On Fri, Jan 15, 2010 at 11:33:27AM +0100, Peter Zijlstra wrote:
> > > On Fri, 2010-01-15 at 15:56 +0530, Srikar Dronamraju wrote:
> > > > Hi Peter, 
> > > > 
> > > > Or there could be two threads that could be racing to
> > > > insert/delete a breakpoint. These synchronization issues are all handled
> > > > by the Uprobes layer.
> > > 
> > > Shouldn't be hard to put that in the ubp layer, right?
> > > 
> > > > Uprobes layer would need to be notified of process life-time events
> > > > like fork/clone/exec/exit. 
> > > 
> > > No so much the process lifetimes as the vma life times are interesting,
> > > placing a hook in the vm code to track that isn't too hard, 
> > > 
> > 
> > I think similar hooks were given thumbs down in the previous incarnation
> > of uprobes (which was implemented without utrace).  
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0603.2/1254.html
> 
> I wasn't at all proposing to mess with a_ops, nor do you really need to,
> I was more thinking of adding a callback like perf_event_mmap() and a
> corresponding unmap(), that way you can track mapping life-times and
> add/remove probes accordingly.
> 
> Adding the probe uses the fact that (most) executable mappings are
> MAP_PRIVATE and CoWs a private copy of the page with the modified ins,
> right?

Does it clean up the CoW'ed page on removing the probe? Does that
account for userspace having made other changes in between installing
and removing the probe (for PROT_WRITE mappings obviously)?

