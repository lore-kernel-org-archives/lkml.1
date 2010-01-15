Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0AOLCk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456Ab0AOLCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:02:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:39929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0AOLCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:02:39 -0500
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
In-Reply-To: <1263553003.4244.385.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop> <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop> <20100115101056.GD26396@in.ibm.com>
	 <1263550412.4244.375.camel@laptop>  <20100115102205.GE26396@in.ibm.com>
	 <1263553003.4244.385.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 12:02:15 +0100
Message-ID: <1263553335.4244.387.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 11:56 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 15:52 +0530, Ananth N Mavinakayanahalli wrote:
> > On Fri, Jan 15, 2010 at 11:13:32AM +0100, Peter Zijlstra wrote:
> > > On Fri, 2010-01-15 at 15:40 +0530, Ananth N Mavinakayanahalli wrote:
> > > 
> > > > Ideas?
> > > 
> > > emulate the one instruction?
> > 
> > In kernel? Generically? Don't think its that easy for userspace --
> > you have the full gamut of instructions to emulate (fp, vector, etc);
> > further,
> 
> Can't you jit a piece of code that wraps the one instruction, save the
> full cpu state, set the userspace segments, have it load pt_regs (except
> for the IP) execute the one ins, save the results, restore the full
> state?

Hmm, normally the problem with FP/Vector state is that we don't
save/restore it going in/out the kernel, so kernel-space can't use it
because it would change the userspace state, but in this case we can
simply execute that one instruction and have it change user state,
because that's exactly what we want to do.

So we don't need to save restore the full cpu state around that JIT'ed
piece of code, but just the regular regs.

