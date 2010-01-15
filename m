Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0AOK0z (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910Ab0AOK0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:26:54 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58815 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0AOK0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:26:53 -0500
Date: Fri, 15 Jan 2010 15:56:45 +0530
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
Message-ID: <20100115102645.GA22640@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
 <1263467394.4244.291.camel@laptop>
 <1263509380.4875.35.camel@localhost.localdomain>
 <1263546632.4244.352.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1263546632.4244.352.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, 

> > > 
> > 
> > My reply in
> > http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/02483.html
> > addresses this.
> 
> Right, so all that need be done is add the multiple probe stuff to UBP
> and its a sane interface to use on its own, at which point I'd be
> inclined to call that uprobes (UBP really is an crap name).

I am fine with renaming ubp to a suggested name. The reason for splitting
uprobes to two layers was to allow others (currently none) to reuse the
current ubp layer. It was felt that there could be multiple clients for
ubp who could co-exist. 

However ubp alone is not enough to provide the userspace tracing.
Currently it wouldn't understand synchronization between different
threads of a process, process life time issues, context in which the
handler has to be run. 

As pointed out by Jim earlier, we have segregrated that layer which
takes care of the above issues into the uprobes layer.

For example, while inserting a breakpoint, one of the threads of a
process could be running at the same place where we are trying to place
a breakpoint. Or there could be two threads that could be racing to
insert/delete a breakpoint. These synchronization issues are all handled
by the Uprobes layer.

Uprobes layer would need to be notified of process life-time events
like fork/clone/exec/exit. 
It also needs to know
	-  when a breakpoint is hit
	-  stop and resume a thread.

Uprobes layer uses utrace to be notified of the process life time events
and the signal handling part.

--
Thanks and Regards
Srikar

> 
> Then we can ditch the whole utrace muck as I see no reason to want to
> use that, whereas the ubp (given a sane name) looks interesting.
> 



