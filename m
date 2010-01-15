Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0AONIK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810Ab0AONIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:08:09 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56121 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0AONIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:08:06 -0500
Date: Fri, 15 Jan 2010 18:38:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100115130802.GC20658@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
 <1263467394.4244.291.camel@laptop>
 <1263509380.4875.35.camel@localhost.localdomain>
 <1263546632.4244.352.camel@laptop>
 <20100115102645.GA22640@linux.vnet.ibm.com>
 <1263551607.4244.379.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1263551607.4244.379.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-01-15 11:33:27]:

> 
> > Uprobes layer would need to be notified of process life-time events
> > like fork/clone/exec/exit. 
> 
> No so much the process lifetimes as the vma life times are interesting,
> placing a hook in the vm code to track that isn't too hard, 
> 
> > It also needs to know
> > 	-  when a breakpoint is hit
> > 	-  stop and resume a thread.
> 
> A simple hook in the trap code is done quickly enough, and no reason to
> stop the thread, its not going anywhere when it traps.
> 
> 

Some of the threads could be executing in the vicinity of the
breakpoint when it is getting inserted or deleted. Wont we need to
stop/quiesce those threads?
