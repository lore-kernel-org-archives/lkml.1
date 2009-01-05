Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZAEDXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZAEDXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZAEDWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:22:50 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37113 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZAEDWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:22:47 -0500
Date: Mon, 5 Jan 2009 08:50:29 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090105032029.GE4301@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081230062139.GA30038@elte.hu> <20081230180722.GA29060@dirshya.in.ibm.com> <20090102072600.GA13412@dirshya.in.ibm.com> <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net> <20090103101626.GA4301@dirshya.in.ibm.com> <1230981761.27180.10.camel@marge.simson.net> <1231081200.17224.44.camel@marge.simson.net> <20090104181946.GC4301@dirshya.in.ibm.com> <1231098769.5757.43.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231098769.5757.43.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-04 20:52:49]:

> On Sun, 2009-01-04 at 23:49 +0530, Vaidyanathan Srinivasan wrote:
> 
> > I am new to sysbench.  I just started few OLTP runs with pgsql. In
> > your graph you are plotting and comparing read/write-per-sec and not
> > transactions-per-sec.  Both the parameter vary in a similar manner.
> > Can you please let me know some background on using the
> > read/write-per-sec result for comparison.
> 
> It means nothing.  One result is the same as any other.  I prefer low
> level read/write but someone else may prefer higher level transactions.
> 
> > I assume you have run the above tests on Q6600 box that has single
> > quad core package that consist of two dual core CPUs.
> 
> Yes.  I can go down from there, but not up.  Oh darn.
> 
> >   Can you please
> > let me know the sched_domain tree that was build by hacking
> > mc_capable().  The effect of sched_mc={1,2} depends on the
> > sched groups that was build and their flags.
> 
> Hm.  I don't know what you're asking.  I hacked mc_capable only so I
> could have the tweakable handy in case there was something I didn't know
> about yet (having _just_ jumped in with both feet;)

When CONFIG_SCHED_DEBUG is enabled, the sched domain tree is dumped
(dmesg)

CPU0 attaching sched-domain:
 domain 0: span 0,2-4 level MC
  groups: 0 2 3 4
  domain 1: span 0-7 level CPU
   groups: 0,2-4 1,5-7
CPU1 attaching sched-domain:
 domain 0: span 1,5-7 level MC
  groups: 1 5 6 7
  domain 1: span 0-7 level CPU
   groups: 1,5-7 0,2-4

This tree clearly depicts what the scheduler thinks of the system.
Correct sched domain and groups setup is critical for performance and
powersavings. When you hack mc_capable, domain at MC level should have
one group with two core (sharing the L2 cache) and CPU level shall
have two groups each with two cpus representing two dual core CPUs.

The above example is from my dual socket quad core system.

> > As you have mentioned in your data, sched_mc=2 helps recover some
> > performance mainly because of NEWIDLE balance.
> 
> Yes, odd.
> 
> > You have mentioned clients in the x-axis of the graph, what is their
> > relation to the number of threads?
> 
> I have 4 cores, and 2 caches.  Any relationship is all about cache.

I was actually asking about software threads specified in the sysbench
benchmark.  Your have run almost 256 clients on a 4 core box, does
that mean sysbench had 256 worker threads?

Thanks for the clarifications.

--Vaidy


