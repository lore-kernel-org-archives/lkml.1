Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYKHAzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYKHAzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYKHAza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:55:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54460 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYKHAz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:55:29 -0500
Date: Fri, 7 Nov 2008 19:55:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Howells <dhowells@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-Reply-To: <9473.1226101838@redhat.com>
Message-ID: <alpine.DEB.1.10.0811071922010.26139@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com> <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <9473.1226101838@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, David Howells wrote:

> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
> > > be required so it works also on UP systems safely wrt interrupts).
> > 
> > smp_rmb turns into a compiler barrier on UP and should prevent the below
> > description.
> 
> Note that that does not guarantee that the two reads will be done in the order
> you want.  The compiler barrier _only_ affects the compiler.  It does not stop
> the CPU from doing the reads in any order it wants.  You need something
> stronger than smp_rmb() if you need the reads to be so ordered.

For reading hardware devices that can indeed be correct. But for normal 
memory access on a uniprocessor, if the CPU were to reorder the reads that 
would effect the actual algorithm then that CPU is broken.

 read a
    <---  interrupt  - should see read a here before read b is done.
 read b

Now the fact that one of the reads is a hardware clock, then this 
statement might not be too strong. But the fact that it is a clock, and 
not some memory mapped device register, I still think smp_rmb is 
sufficient.

-- Steve

