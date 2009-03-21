Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZCUVCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZCUVCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZCUVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:01:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56878 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbZCUVB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:01:58 -0400
Date: Sat, 21 Mar 2009 14:01:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321210154.GD7148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com> <20090321190746.GC7148@linux.vnet.ibm.com> <20090321200919.GA23992@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321200919.GA23992@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 09:09:19PM +0100, Ingo Molnar wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, Mar 21, 2009 at 01:25:23PM -0400, Steven Rostedt wrote:
> > > On Sat, 21 Mar 2009, Ingo Molnar wrote:
> > > > * Ingo Molnar <mingo@elte.hu> wrote:

[ . . . ]

> > > > CONFIG_CLASSIC_RCU=y
> > > 
> > > All the crashes you reported only happen with classic RCU.
> > > 
> > > Paul,
> > > 
> > > Did anything change recently that could cause this lockup?
> > 
> > Arjan van de Ven is seeing a problem where a single 
> > synchronize_rcu() during bootup is taking a full second, which is 
> > currently thought to be due to some drivers spinning in the kernel 
> > (Arjan is working on a bootgraph that will hopefully pinpoint the 
> > problem: http://lkml.org/lkml/2009/3/21/7).  If the drivers were 
> > also instrumented with ftrace, they might (or might not)slow down 
> > even further, depending on exactly why they are spinning.
> 
> for one of the hung boxes in the past i waited 24 hours but it never 
> unwedged itself. The box that hung today is still hanging and the 
> RCU stall detector is still busy printing out those backtraces.

And on the last trace you emailed, the first and the last stall warning
are identical according to "diff".  In fact, they are all identical.
That is a bit unusual, one would normally expect to see slight differences
in the stack based on the scheduling clock interrupt hitting the "longer
than average loop" in different places each time.

That would indicate either a very tight loop or a loop that has
interrupts enabled only in one spot.

							Thanx, Paul
