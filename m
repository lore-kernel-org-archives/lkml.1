Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbXFYVKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbXFYVKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbXFYVJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:09:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXFYVJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:09:56 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <1182803464.5493.213.camel@localhost.localdomain>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <1182797325.1689.14.camel@hinata.boston.redhat.com>
	 <1182798678.5493.179.camel@localhost.localdomain>
	 <1182802021.1689.50.camel@hinata.boston.redhat.com>
	 <1182803464.5493.213.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Mon, 25 Jun 2007 17:08:15 -0400
Message-Id: <1182805695.1689.69.camel@hinata.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 16:31 -0400, Steven Rostedt wrote:
> On Mon, 2007-06-25 at 16:07 -0400, Kristian Høgsberg wrote:
> 
> > > Maybe we should be looking at something like GENERIC_SOFTIRQ to run
> > > functions that a driver could add. But they would run only on the CPU
> > > that scheduled them, and do not guarantee non-reentrant as tasklets do
> > > today.
> > 
> > Sounds like this will fill the gap.  Of course, this won't reduce the
> > number of delayed-execution mechanisms available...
> 
> I disagree. Adding a generic softirq is not really adding another
> delayed-execution, it's just extending the sofitrq.  It would not have
> any different semantics as a normal softirq, except that it would be
> dynamic for modules to use.  A tasklet has different concepts than
> softirq. It adds non-reentrancy and that the tasklet function can run
> where it wasn't scheduled.

Hmm, yeah, true.  Ok, sounds useful, let me know when you have a patch.
I'll try porting the firewire stack and let you know how it works.

Just to make sure I got this right: softirqs will always be scheduled on
the irq handling CPU and if an interrupt schedules multiple softirqs
from one handler invocation, the softirqs will be executed in the order
they are scheduled?  And the reentrancy that softirqs does not protect
against (as opposed to tasklets) is the case where different CPUs handle
the interrupt and each schedule the same softirq for execution?

Kristian


