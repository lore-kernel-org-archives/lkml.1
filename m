Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYKGXwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYKGXwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYKGXvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:51:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbYKGXvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:51:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com> <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: dhowells@redhat.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 23:50:38 +0000
Message-ID: <9473.1226101838@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:

> > I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
> > be required so it works also on UP systems safely wrt interrupts).
> 
> smp_rmb turns into a compiler barrier on UP and should prevent the below
> description.

Note that that does not guarantee that the two reads will be done in the order
you want.  The compiler barrier _only_ affects the compiler.  It does not stop
the CPU from doing the reads in any order it wants.  You need something
stronger than smp_rmb() if you need the reads to be so ordered.

David
