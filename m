Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXFVNSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXFVNSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXFVNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:17:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXFVNR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:17:57 -0400
Date: Fri, 22 Jun 2007 15:12:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622131250.GA18729@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622070948.GA21291@infradead.org> <1182515542.5493.20.camel@localhost.localdomain> <20070622123805.GA9770@elte.hu> <1182517124.5493.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182517124.5493.38.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > that's where it belongs - but it first needs the cleanups suggested 
> > by Christoph.
> 
> I had the impression that he didn't want it in, but instead wanted 
> each driver to be changed separately.

that can be done too in a later stage. We cannot deprecate an API from 
one day to another. But wrapping it sanely via an existing framework 
makes complete sense.

> > > and perhaps even turn on the tasklets-as-workqueues as default.
> > 
> > that is a hack that shouldnt be in the patch. People can 
> > unapply/apply a patch just as well as they can flip a .config 
> > switch.
> 
> So should the patch be then to not even have the tasklet_softirq there 
> at all?  Have the patch simply replace the tasklets with workqueues, 
> and if someone doesn't like that, then they can simply remove the 
> patch?

yes, the softirq based tasklet implementation with workqueue based 
implementation, but the tasklet API itself should still stay.

ok, enough idle talking, lets see the next round of patches? :)

please remove all the pr_debug() lines as well - they are handy for 
development but are quite unnecessary for something headed 
upstream-wards. And please replace all the BUG_ON()s with WARN_ON_ONCE() 
...

	Ingo
