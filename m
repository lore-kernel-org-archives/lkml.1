Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab0AOXLo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355Ab0AOXLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:11:43 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46186 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0AOXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:11:42 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Jim Keniston <jkenisto@us.ibm.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <20100115142007.GA1628@linux.vnet.ibm.com>
References: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	 <1263548124.4244.358.camel@laptop>	<20100115131037.GP4822@redhat.com>
	 <1263561930.4244.417.camel@laptop>	<20100115133825.GQ4822@redhat.com>
	 <1263563276.4244.426.camel@laptop>
	 <20100115142007.GA1628@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 15:11:25 -0800
Message-Id: <1263597085.5007.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-01-15 at 19:50 +0530, Srikar Dronamraju wrote:
> > 
> > > > Furthermore it requires stopping and resuming tasks and nonsense like
> > > > that, that's unwanted in many cases, just run stuff from the trap site
> > > > and you're done.
> > > 
> > > I don't know what you mean exactly.  A trap already stopped task.
> > > utrace merely allows various clients to inspect/manipulate the state
> > > of the task at that moment.  It does not add any context switches or
> > > spurious stop/resumue operations.
> > 
> > Srikar seemed to suggest it needed stop/resume.
> > 
> 
> If process traps, We dont need to stop/resume other threads.
> uprobes needs threads to quiesce when inserting/deleting the breakpoint.
> 

Years ago, we had pre-utrace versions of uprobes where the uprobes
breakpoint-handler code was dispatched from the die_notifier, before the
int3 turned into a SIGTRAP.  I believe that's what Peter is
recommending.  On my old Pentium M...
- a pre-utrace uprobe hit cost about 1 usec;
- a utrace-based uprobe hit cost about 3 usec;
- and an unboosted kprobe hit cost 0.57 usec.

So yeah, learning about the int3 via utrace after the SIGTRAP gets
created adds some overhead to uprobes.  But as previously discussed in
this thread -- e.g.,
http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/02969.html --
there are ways to avoid the 2nd (single-step) trap, which should cut
overhead in half.

Jim

