Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZBIGs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZBIGs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZBIGss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:48:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:9214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZBIGss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:48:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,404,1231142400"; 
   d="scan'208";a="108575055"
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <20090206151832.GL18368@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang>
	 <20090206151832.GL18368@elte.hu>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 14:46:01 +0800
Message-Id: <1234161961.5991.41.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 23:18 +0800, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > On Thu, 2009-02-05 at 13:06 +0100, Ingo Molnar wrote:
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > This should hopefully address all the itimer borkage.
> > > 
> > > Applied to tip:timers/urgent, thanks Peter!
> > > 
> > > Yanmin: could you check hacbench_pth with latest tip/master, do
> > > these fixes resolve that 3% regression you reported?
> >
> > Lin Ming tested it and hackbench_pth/volanoMark regression all disappear. 
> > But oltp has a regression. We think oltp new regression isn't related to 
> > the patch. Ming is investigating it.
> 
> Potential suspects for oltp regression would be:
> 
>  3d39870: sched_rt: don't use first_cpu on cpumask created with cpumask_and
>  a571bbe: sched: fix buddie group latency
>  a9f3e2b: sched: clear buddies more aggressively
>  1596e29: sched: symmetric sync vs avg_overlap
>  d942fb6: sched: fix sync wakeups

I tested the latest tip-master branch.
After reverting "d942fb6: sched: fix sync wakeups", the oltp regression
on the 8cores Stockley machine is mostly fixed.

On another 4*4 cores Tigerton machine, oltp has more than 10% regression
with 2.6.29-rc4 compared with 2.6.29-rc3.

Lin Ming

> 
> 	Ingo

