Return-Path: <linux-kernel-owner+w=401wt.eu-S936193AbZDCSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936193AbZDCSFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934992AbZDCSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:05:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42953 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbZDCSFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:05:19 -0400
Date: Fri, 3 Apr 2009 11:05:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090403180516.GC6968@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <20090403162642.GB6968@linux.vnet.ibm.com> <20090403163755.GA3047@elte.hu> <alpine.DEB.2.00.0904031241280.21481@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904031241280.21481@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 12:43:15PM -0400, Steven Rostedt wrote:
> 
> On Fri, 3 Apr 2009, Ingo Molnar wrote:
> > > 
> > > My kneejerk reaction is "why would anyone want to trace the idle 
> > > loop?"
> > 
> > heh :-)
> > 
> > Idle enter/exit events are useful to tune power use for example. The 
> > more events we have there, the more we prevent the CPU from slowly 
> > going into deep sleep mode.

But we could in principle trace idle enter/exit from the scheduler, correct?

That said, it would be possible to allow much of the idle loop to contain
RCU read-side critical sections, but this requires putting rcu_qsctr_inc()
in each and every idle loop, plus catching the cases where idle loops
shut down the CPU.  Note that this applies to synchronize_sched() as
well as synchronize_rcu().

> I can say I use it a lot. I'm still needing a way to set the function pid 
> recorder to 0 since the conversion to the pid structure. There are times 
> I only want to trace the interrupts that happen in the idle loop.

It would be OK to trace the interrupts, just not the idle loop itself.

							Thanx, Paul
