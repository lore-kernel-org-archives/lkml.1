Return-Path: <linux-kernel-owner+w=401wt.eu-S1764307AbXGPUvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764307AbXGPUvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764169AbXGPUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:50:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086AbXGPUu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:50:28 -0400
Date: Mon, 16 Jul 2007 22:48:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/8] Convert the RCU tasklet into a softirq
Message-ID: <20070716204831.GA13539@elte.hu>
References: <20070627193633.025544061@goodmis.org> <20070627194327.241131609@goodmis.org> <20070716201251.GB12458@linux.vnet.ibm.com> <alpine.LFD.0.999.0707161322440.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707161322440.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 16 Jul 2007, Paul E. McKenney wrote:
> >
> > On Wed, Jun 27, 2007 at 03:36:34PM -0400, Steven Rostedt wrote:
> > > I believe this was originally done by Dipankar Sarma. I pulled these
> > > changes from the -rt kernel.
> > > 
> > > For better preformance, RCU should use a softirq instead of a
> > > tasklet.
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Tested with both kernbench and rcutorture on i386, x86_64, and ppc64.
> 
> Btw, are there any numbers on this? Is this whole thing actually 
> noticeable?

i doubt it's noticeable, because the RCU tasklet was not a "true" global 
tasklet, it was an array of tasklets put into a PER_CPU array. (which 
kind of defeats the purpose of tasklets)

So there should be no/little scalability disadvantage from this type of 
use of tasklets, and the tasklet use was at most a wart and a small, 
constant micro-cost that is likely masked by other costs. (and rcu never 
used any of the fancier tasklet ops like tasklet_disable() either)

	Ingo
