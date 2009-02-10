Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZBJMqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZBJMqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbZBJMpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:45:45 -0500
Received: from viefep16-int.chello.at ([62.179.121.36]:50219 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbZBJMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:45:44 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <20090209214723.GA2664@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang>
	 <20090206151832.GL18368@elte.hu>
	 <1234161961.5991.41.camel@minggr.sh.intel.com>
	 <20090209214723.GA2664@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 13:47:24 +0100
Message-Id: <1234270044.23438.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 22:47 +0100, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > On Fri, 2009-02-06 at 23:18 +0800, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > On Thu, 2009-02-05 at 13:06 +0100, Ingo Molnar wrote:
> > > > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > 
> > > > > > This should hopefully address all the itimer borkage.
> > > > > 
> > > > > Applied to tip:timers/urgent, thanks Peter!
> > > > > 
> > > > > Yanmin: could you check hacbench_pth with latest tip/master, do
> > > > > these fixes resolve that 3% regression you reported?
> > > >
> > > > Lin Ming tested it and hackbench_pth/volanoMark regression all disappear. 
> > > > But oltp has a regression. We think oltp new regression isn't related to 
> > > > the patch. Ming is investigating it.
> > > 
> > > Potential suspects for oltp regression would be:
> > > 
> > >  3d39870: sched_rt: don't use first_cpu on cpumask created with cpumask_and
> > >  a571bbe: sched: fix buddie group latency
> > >  a9f3e2b: sched: clear buddies more aggressively
> > >  1596e29: sched: symmetric sync vs avg_overlap
> > >  d942fb6: sched: fix sync wakeups
> > 
> > I tested the latest tip-master branch.
> > After reverting "d942fb6: sched: fix sync wakeups", the oltp regression
> > on the 8cores Stockley machine is mostly fixed.
> > 
> > On another 4*4 cores Tigerton machine, oltp has more than 10% regression
> > with 2.6.29-rc4 compared with 2.6.29-rc3.
> 
> ok, that commit needs fixed or reverted. Peter, Mike?

Yanmin, is that tigerton regression also due to the sync changes?

That is, if you revert both d942fb6 and 1596e29, does it get back to
-rc3 state, or is the tigerton regression due to something else?

This isn't quite clear to me.

Ingo, if that is the case, I'm fine with reverting those changes for
now, and have another look at them later on -- preferably when someone
ships me a 4*4 machine so I can validate :-)



