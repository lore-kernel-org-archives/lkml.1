Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZADSXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZADSXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbZADSXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:23:12 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36625 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbZADSXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:23:11 -0500
Date: Sun, 4 Jan 2009 23:49:46 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090104181946.GC4301@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu> <20081230180722.GA29060@dirshya.in.ibm.com> <20090102072600.GA13412@dirshya.in.ibm.com> <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net> <20090103101626.GA4301@dirshya.in.ibm.com> <1230981761.27180.10.camel@marge.simson.net> <1231081200.17224.44.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231081200.17224.44.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-04 16:00:00]:

> On Sat, 2009-01-03 at 12:22 +0100, Mike Galbraith wrote:
> > On Sat, 2009-01-03 at 15:46 +0530, Vaidyanathan Srinivasan wrote:
> > > * Mike Galbraith <efault@gmx.de> [2009-01-03 08:29:25]:
> > > 
> > > > On Fri, 2009-01-02 at 23:16 +0100, Ingo Molnar wrote:
> > > > 
> > > > > Mike, would you be interesting in having a look at sched_mc=2 as a 
> > > > > kernel-wide default - and give it your blessing if you find it to be a net 
> > > > > improvement for the various performance and interactivity tests you do?
> > > > 
> > > > Sure.
> > > 
> > > Thanks Mike and Ingo.  I will be glad to help with test and benchmarks
> > > on the platforms that I have access.
> > > 
> > > I am presently working on sysbench.
> > 
> > The testing I can do is rather severely limited since I have only one
> > Q6600.  I butchered mc_capable() to use what I can though, ie see if
> > SD_BALANCE_NEWIDLE still harms tbench and mysql+oltp.  I think that's
> > about all I can do on my wee box.
> 
> I do not see any difference for tbench, results are within jitter.  I do
> for mysql+oltp, and the test results are fairly strange.
> 
> If you take a peek at the attached chart: the 2.6.26.8 data is with
> scalability backports/fixes.  That's where our 29-to-be should be.
> Domain tunings in this kernel are identical to 28/29 stock as well.
> 
> Note that there is no knee at 8 clients.  If I turn SD_BALANCE_NEWIDLE
> on in 26+backports, peak drops a tad, and that knee re-appears, just as
> before we turned the thing off.  Throughput after the knee also drops a
> tad, nearly to the point where tip+sched_mc=2 now _comes up to_, and it
> definitely is SD_BALANCE_NEWIDLE making the difference.  IOW, what used
> to be a loser, and still is a loser in 26+fixes, is now a winner in tip
> after the knee which should not be there.  Seems something else has
> changed, re-introducing the knee, and cutting throughput a tad.
> 
> (The hefty difference at the very end I knew about.  SD_BALANCE_NEWIDLE
> helps considerably when mysql is very thoroughly jammed up on itself)
> 
> When I look at that chart, it looks almost like SD_BALANCE_NEWIDLE is
> partially offsetting some other problem.
> 
> I haven't done any interactivity testing yet.

Hi Mike,

Thanks for the detailed test report.

I am new to sysbench.  I just started few OLTP runs with pgsql. In
your graph you are plotting and comparing read/write-per-sec and not
transactions-per-sec.  Both the parameter vary in a similar manner.
Can you please let me know some background on using the
read/write-per-sec result for comparison.

I assume you have run the above tests on Q6600 box that has single
quad core package that consist of two dual core CPUs.  Can you please
let me know the sched_domain tree that was build by hacking
mc_capable().  The effect of sched_mc={1,2} depends on the
sched groups that was build and their flags.

As you have mentioned in your data, sched_mc=2 helps recover some
performance mainly because of NEWIDLE balance.  

You have mentioned clients in the x-axis of the graph, what is their
relation to the number of threads?  

Please feel free to point me to any previous discussion on sysbench
where the above questions have been discussed.

Thanks,
Vaidy

