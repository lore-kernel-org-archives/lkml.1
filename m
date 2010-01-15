Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0AOK5D (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884Ab0AOK5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:57:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab0AOK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:56:59 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100115102205.GE26396@in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop> <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop> <20100115101056.GD26396@in.ibm.com>
	 <1263550412.4244.375.camel@laptop>  <20100115102205.GE26396@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 11:56:43 +0100
Message-ID: <1263553003.4244.385.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 15:52 +0530, Ananth N Mavinakayanahalli wrote:
> On Fri, Jan 15, 2010 at 11:13:32AM +0100, Peter Zijlstra wrote:
> > On Fri, 2010-01-15 at 15:40 +0530, Ananth N Mavinakayanahalli wrote:
> > 
> > > Ideas?
> > 
> > emulate the one instruction?
> 
> In kernel? Generically? Don't think its that easy for userspace --
> you have the full gamut of instructions to emulate (fp, vector, etc);
> further,

Can't you jit a piece of code that wraps the one instruction, save the
full cpu state, set the userspace segments, have it load pt_regs (except
for the IP) execute the one ins, save the results, restore the full
state?

Then replace pt_regs with the saved result and advance the stored IP by
the length of that one instruction and return to userspace?

All you need to take care of are the priv insns, but doesn't something
like kvm already have code to deal with that?

>  the instruction could itself cause a page fault and the like.

Faults aren't a problem, we take faults from kernel space all the time.

