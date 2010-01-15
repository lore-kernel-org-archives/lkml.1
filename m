Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0AOKdx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910Ab0AOKdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:33:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:43613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0AOKdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:33:51 -0500
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
In-Reply-To: <20100115102645.GA22640@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>
	 <20100115102645.GA22640@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 11:33:27 +0100
Message-ID: <1263551607.4244.379.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 15:56 +0530, Srikar Dronamraju wrote:
> Hi Peter, 
> 
> Or there could be two threads that could be racing to
> insert/delete a breakpoint. These synchronization issues are all handled
> by the Uprobes layer.

Shouldn't be hard to put that in the ubp layer, right?

> Uprobes layer would need to be notified of process life-time events
> like fork/clone/exec/exit. 

No so much the process lifetimes as the vma life times are interesting,
placing a hook in the vm code to track that isn't too hard, 

> It also needs to know
> 	-  when a breakpoint is hit
> 	-  stop and resume a thread.

A simple hook in the trap code is done quickly enough, and no reason to
stop the thread, its not going anywhere when it traps.


