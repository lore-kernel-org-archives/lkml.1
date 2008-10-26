Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYJZO0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYJZO0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYJZOZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:25:59 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50385 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYJZOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:25:58 -0400
Date: Sun, 26 Oct 2008 07:25:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2][RFC] ftrace: function oprofiler
Message-ID: <20081026142556.GB6419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com> <alpine.DEB.1.10.0810252049020.7650@gandalf.stny.rr.com> <1225017357.27415.5.camel@twins> <alpine.DEB.1.10.0810260951500.20123@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810260951500.20123@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 09:58:01AM -0400, Steven Rostedt wrote:
> 
> On Sun, 26 Oct 2008, Peter Zijlstra wrote:
> 
> > On Sat, 2008-10-25 at 20:55 -0400, Steven Rostedt wrote:
> > 
> > > This is a function profiler to count the number of times a function is hit.
> > 
> > I have to ask, _why_?
> > 
> > It seems like a nice enough gimmick, but is this information actually
> > useful?
> 
> Well, it does let you know for sure which functions are the hottest paths.
> Perhaps you have a "slow path" function. This will show you how slow
> that slow path is. That is, how many times it is hit compared to the
> fast path.

And the ratio between the "hot path" and the "slow path" can be very
helpful in working out what sorts of optimizations can be used.  Is a
give optimization that gains a factor of ten on the hot path and loses
a factor of 50 on the slow path a win?

Of course, you also need some estimate of the cost of the hot paths
and the slow paths.

						Thanx, Paul

> With dynamic ftrace, you can also pick and choose which functions
> are to be counted.
> 
> What is also nice about it (and something that I will use it for), is that
> it will show you the functions that will be hit the most during a trace. 
> If you do not care about those functions, then you can easily filter them 
> out for your trace.
> 
> This patch is also a proof of concept. I'm sure others can think of more 
> useful things to do by adding more stuff to this patch.


