Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293Ab0AGQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0AGQj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941Ab0AGQj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:39:58 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60096 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab0AGQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:39:57 -0500
Date: Thu, 7 Jan 2010 08:39:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107163923.GB6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <20100107050248.GA6803@linux.vnet.ibm.com> <1262853136.4049.81.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262853136.4049.81.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 09:32:16AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-06 at 21:02 -0800, Paul E. McKenney wrote:
> > 
> > Beats the heck out of user-mode signal handlers!!!  And it is hard
> > to imagine groveling through runqueues ever being a win, even on very
> > large systems.  The only reasonable optimization I can imagine is to
> > turn this into a no-op for a single-threaded process, but there are
> > other ways to do that optimization.
> > 
> > Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Then imagine someone doing:
> 
>  while (1)
>   sys_membarrier();
> 
> on your multi node machine, see how happy you are then.

I guess in that situation, I would be feeling no pain.  Or anything else
for that matter.  :-/

So, good point!!!  I stand un-Reviewed-By.

I could imagine throttling the requests, as well as batching them.  If
any CPU does a sys_membarrier() after this CPU's sys_membarrier has
entered the kernel, then this CPU can simply return.  A token-bucket
approach could throttle things nicely, but at some point it becomes
better to just do POSIX signals.

							Thanx, Paul
