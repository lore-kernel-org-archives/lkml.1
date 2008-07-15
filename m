Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYGOTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYGOTNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYGOTNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:13:22 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:45620 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824AbYGOTNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:13:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAK2SfEhMRKxB/2dsb2JhbACBWq4l
Date: Tue, 15 Jul 2008 15:08:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 01/15] Kernel Tracepoints
Message-ID: <20080715190816.GB6664@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130593.12595.189.camel@twins> <20080715144628.GD20037@Krystal> <1216134829.12595.207.camel@twins> <487CF206.4010905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <487CF206.4010905@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:02:56 up 40 days, 23:43,  6 users,  load average: 4.26, 2.66,
	1.70
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi,
> 
> Peter Zijlstra wrote:
> > On Tue, 2008-07-15 at 10:46 -0400, Mathieu Desnoyers wrote:
> > 
> >> Talking about headers, I have noticed that placing headers with the code
> >> may not be as clean as I would hope. For instance, the kernel/irq-trace.h
> >> header, when included from kernel/irq/handle.c, has to be included with:
> >>
> >> #include "../irq-trace.h"
> >>
> >> Which is not _that_ bad, but we we want to instrument the irq handler
> >> found in arch/x86/kernel/cpu/mcheck/mce_intel_64.c, including
> >> #include "../../../../../kernel/irq-trace.h" makes me go "yeeeek!"
> >>
> >> How about creating include/trace/irq.h and friends ?
> > 
> > Might as well.. anybody else got opinions?
> 
> I just wonder why DEFINE_TRACE are used in separated headers
> instead of include/linux/irq.h directly.
> 
> anyway, #include <trace/XXX.h> is good to me.
> 

Having these headers all placed nicely together will make it easier for
people who are looking for already existing tracepoints to locate them.

It's also worth noting that I am considering deploying a standard set of
tracepoints for userspace in a relatively short time frame. e.g. having
the ability to add tracepoints to pthread mutexes seems like an
interesting thing to have. And that will definitely require those
headers to sit somewhere around /usr/include/trace/ or something
similar, otherwise trying to locate those tracepoints will be hellish.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
