Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbYGOSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbYGOSWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbYGOSWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:22:14 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:61473 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461AbYGOSWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:22:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAI+BfEhMRKxB/2dsb2JhbACBWq4K
Date: Tue, 15 Jul 2008 14:22:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 01/15] Kernel Tracepoints
Message-ID: <20080715182210.GA4334@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130593.12595.189.camel@twins> <20080715144628.GD20037@Krystal> <1216134829.12595.207.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216134829.12595.207.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:20:16 up 40 days, 23:01,  5 users,  load average: 3.17, 2.00,
	1.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 10:46 -0400, Mathieu Desnoyers wrote:
> 
> > Talking about headers, I have noticed that placing headers with the code
> > may not be as clean as I would hope. For instance, the kernel/irq-trace.h
> > header, when included from kernel/irq/handle.c, has to be included with:
> > 
> > #include "../irq-trace.h"
> > 
> > Which is not _that_ bad, but we we want to instrument the irq handler
> > found in arch/x86/kernel/cpu/mcheck/mce_intel_64.c, including
> > #include "../../../../../kernel/irq-trace.h" makes me go "yeeeek!"
> > 
> > How about creating include/trace/irq.h and friends ?
> 
> Might as well.. anybody else got opinions?
> 

I'm also wondering if it's better to have :

filemap.h
fs.h
hugetlb.h
ipc.h
ipv4.h
ipv6.h
irq.h
kernel.h
memory.h
net.h
page.h
sched.h
swap.h
timer.h

all in include/trace/ or to create subdirectories first, like :

include/trace/net/
include/trace/mm/
...

or to go the other way around and re-use the existing subdirectories :

include/net/trace/
include/mm/trace/
...

?

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
