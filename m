Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902Ab0AMFbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab0AMFbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191Ab0AMFba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:31:30 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33635 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0AMFb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:31:29 -0500
Date: Tue, 12 Jan 2010 21:31:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113053126.GC6781@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100113013757.GA29314@Krystal> <1263358823.3874.10.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263358823.3874.10.camel@entropy>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:00:23PM -0800, Nicholas Miell wrote:
> On Tue, 2010-01-12 at 20:37 -0500, Mathieu Desnoyers wrote:
> > + * sys_membarrier - issue memory barrier on current process running threads
> > + * @expedited: (0) Lowest overhead. Few milliseconds latency.
> > + *             (1) Few microseconds latency.
> > + *
> 
> Alternate ABI proposal, keeping the possibility of future expansion in
> mind:
> 
> /*
> Mandatory flags to the membarrier system call that the kernel must
> understand are in the high 16 bits.
> */
> #define MEMBARRIER_MANDATORY_MASK 0xFFFF0000
> 
> /*
> Optional hints that the kernel can ignore are in the low 16 bits.
> */
> #define MEMBARRIER_OPTIONAL_MASK 0x0000FFFF
> 
> #define MEMBARRIER_EXPEDITED 1
> 
> extern int membarrier(unsigned int flags);
> 
> And then add to the system call itself:
> 
> if ((flags & MEMBARRIER_MANDATORY_MASK) != 0)
> 	return -EINVAL;

Why is it OK to ignore the developer's request for an expedited
membarrer()?  The guy who expected the syscall to complete in a few
microseconds might not be so happy to have it take many milliseconds.
By the same token, the guy who specified non-expedited so as to minimally
disturb other threads in the system might not be so happy to see them
all be IPIed for no good reason.  ;-)

							Thanx, Paul
