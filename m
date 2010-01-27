Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122Ab0A0KXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0A0KXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831Ab0A0KXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:23:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52425 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0A0KXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:23:32 -0500
Date: Wed, 27 Jan 2010 11:23:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100127102311.GA973@elte.hu>
References: <1263852957.2266.38.camel@localhost.localdomain>
 <4B556855.6040800@redhat.com>
 <1263923265.4998.28.camel@localhost.localdomain>
 <4B56D027.3010808@redhat.com>
 <1263981472.4283.843.camel@laptop>
 <4B56F588.2060109@redhat.com>
 <20100127082440.GA16640@elte.hu>
 <4B5FFADB.5090209@redhat.com>
 <20100127090824.GA23570@elte.hu>
 <4B60067B.4060708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B60067B.4060708@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > If so then you ignore the obvious solution to _that_ problem: dont use 
> > INT3 at all, but rebuild (or re-JIT) your program with explicit callbacks. 
> > It's _MUCH_ faster than _any_ breakpoint based solution - literally just 
> > the cost of a function call (or not even that - i've written very fast 
> > inlined tracers - they do rock when it comes to performance). Problem 
> > solved and none of the INT3 details matters at all.
> 
> However did I not think of that?  Yes, and let's rip off kprobes tracing 
> from the kernel, we can always rebuild it.
> 
> Well, I'm observing an issue in a production system now.  I may not want to 
> take it down, or if I take it down I may not be able to observe it again as 
> the problem takes a couple of days to show up, or I may not have the full 
> source, or it takes 10 minutes to build and so an iterative edit/build/run 
> cycle can stretch for hours.

You have somewhat misconstrued my argument. What i said above is that _if_ you 
need extreme levels of performance you always have the option to go even 
faster via specialized tracing solutions. I did not promote it as a 
replacement solution. Specialization obviously brings in a new set of 
problems: infexibility and non-transparency, an example of what you gave 
above.

Your proposed solution brings in precisely such kinds of issues, on a 
different level, just to improve performance at the cost of transparency and 
at the cost of features and robustness.

It's btw rather ironic as your arguments are somewhat similar to the Xen vs. 
KVM argument just turned around: KVM started out slower by relying on hardware 
implementation for virtualization while Xen relied on a clever but limiting 
hack. With each CPU generation the hardware got faster, while the various 
design limitations of Xen are hurting it and KVM is winning that race.

A (partially) similar situation exists here: INT3 into ring 0 and handling it 
there in a protected environment might be more expensive, but _if_ it matters 
to performance it sure could be made faster in hardware (and in fact it will 
become faster with every new generation of hardware).

Both Peter and me are telling you that we are considering your solution too 
specialized, at the cost of flexibility, features and robustness.

Thanks,

	Ingo
