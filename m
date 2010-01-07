Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741Ab0AGTRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0AGTRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692Ab0AGTRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:17:05 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53674 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0AGTRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:17:01 -0500
Date: Thu, 7 Jan 2010 11:16:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107191657.GN6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com> <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262890782.28171.3738.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 01:59:42PM -0500, Steven Rostedt wrote:
> On Thu, 2010-01-07 at 10:39 -0800, Paul E. McKenney wrote:
> 
> > > sys_membarrier() should "insert" mb() on behalf of B "instead"
> > > of barrier(), right? But, if we send IPI, B enters kernel mode
> > > and returns to user-mode. Should this imply mb() in any case?
> > 
> > Hello, Oleg,
> > 
> > The issue is with some suggested optimizations that would avoid sending
> > the IPI to CPUs that are not running threads in the same process as the
> > thread executing the sys_membarrier().  Some forms of these optimizations
> > sample ->mm without locking, and the question is whether this is safe.
> 
> Note, we are not suggesting optimizations. It has nothing to do with
> performance of the syscall. We just can't allow one process to be DoSing
> another process on another cpu by it sending out millions of IPIs.
> Mathieu already showed that you could cause a 2x slowdown to the
> unrelated tasks.

I would have said that we are trying to optimize our way out of a DoS
situation, but point taken.  Whatever we choose to call it, the discussion
is on the suggested modifications, not strictly on the original patch.  ;-)

						Thanx, Paul
