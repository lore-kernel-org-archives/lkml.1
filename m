Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYJCUOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYJCUOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYJCUOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:14:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:49276 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYJCUOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:14:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,358,1220252400"; 
   d="scan'208";a="54747534"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "rth@twiddle.net" <rth@twiddle.net>,
       "paulus@samba.org" <paulus@samba.org>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>
CC: "colpatch@us.ibm.com" <colpatch@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       "hch@lst.de" <hch@lst.de>, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Fri, 3 Oct 2008 13:14:02 -0700
Subject: RE: [PATCH] topology.h define mess fix
Thread-Topic: [PATCH] topology.h define mess fix
Thread-Index: AckliWpJNaidkE7wSuilsrqY+tCSyQACkYDA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA352D499CB@orsmsx505.amr.corp.intel.com>
References: <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu>
 <20081002093835.GA17699@elte.hu>
 <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
 <20081003045607.GA5940@Krystal>
 <alpine.DEB.1.10.0810030117280.26504@gandalf.stny.rr.com>
 <20081003155605.GC1607@Krystal>
 <alpine.DEB.1.10.0810031223060.26504@gandalf.stny.rr.com>
 <20081003172143.GA7733@Krystal>
 <alpine.DEB.1.10.0810031349210.26504@gandalf.stny.rr.com>
 <20081003185333.GA9626@Krystal>
In-Reply-To: <20081003185333.GA9626@Krystal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Major cross-architecture built test is required.

Some problems on ia64.  With defconfig build (which has
CONFIG_NUMA=y) I see this:

kernel/sched.c: In function 'find_next_best_node':
kernel/sched.c:6920: error: implicit declaration of function 'node_to_cpumask_ptr'
kernel/sched.c:6920: error: '__tmp__' undeclared (first use in this function)
kernel/sched.c:6920: error: (Each undeclared identifier is reported only once
kernel/sched.c:6920: error: for each function it appears in.)
kernel/sched.c: In function 'sched_domain_node_span':
kernel/sched.c:6952: error: 'nodemask' undeclared (first use in this function)
kernel/sched.c:6953: warning: ISO C90 forbids mixed declarations and code
kernel/sched.c:6964: error: implicit declaration of function 'node_to_cpumask_ptr_next'
kernel/sched.c: In function '__build_sched_domains':
kernel/sched.c:7510: error: 'pnodemask' undeclared (first use in this function)

On an "allnoconfig" build (which curiously also has CONFIG_NUMA=y :-) I see

mm/page_alloc.c: In function 'find_next_best_node':
mm/page_alloc.c:2086: error: implicit declaration of function 'node_to_cpumask_ptr'
mm/page_alloc.c:2086: error: 'tmp' undeclared (first use in this function)
mm/page_alloc.c:2086: error: (Each undeclared identifier is reported only once
mm/page_alloc.c:2086: error: for each function it appears in.)
mm/page_alloc.c:2107: error: implicit declaration of function 'node_to_cpumask_ptr_next'

There are most probably more errors ... but this is where the build stopped.

-Tony
