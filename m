Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZAFPEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZAFPEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZAFPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:04:24 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:38774 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZAFPEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:04:24 -0500
Date: Tue, 6 Jan 2009 20:37:09 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090106150709.GG4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090103101626.GA4301@dirshya.in.ibm.com> <1230981761.27180.10.camel@marge.simson.net> <1231081200.17224.44.camel@marge.simson.net> <20090104181946.GC4301@dirshya.in.ibm.com> <1231098769.5757.43.camel@marge.simson.net> <20090105032029.GE4301@dirshya.in.ibm.com> <1231130416.5479.8.camel@marge.simson.net> <1231137413.10471.23.camel@marge.simson.net> <1231168786.9120.26.camel@marge.simson.net> <1231234297.3806.50.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231234297.3806.50.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-06 10:31:37]:

> On Mon, 2009-01-05 at 16:19 +0100, Mike Galbraith wrote:
> > On Mon, 2009-01-05 at 07:37 +0100, Mike Galbraith wrote:
> > 
> > > I'll rummage around.
> > 
> > Seems to be about the only thing it could be, load balancing inflicting
> > injury on very sensitive mysql+oltp pairs.
> 
> BTW, I verified this.  Reverting all load-balancing changes fully
> restored mysql+oltp peak, and brought mid-range throughput to the same
> level as sched_mc=2 except at the log-jam end.  (haven't looked at
> vmark, though I'd expect it to be hurting a bit too, it's affinity
> sensitive as well)
> 
> I expected sched_mc=2 to help an nfs mount kbuild, and it did, quite a
> bit.  I first tried an nfs4 mount, but after a while, the odd ipv6 80%
> idle problem came back, so I reverted to nfs3.  Full built time there
> went from 4m25s to 4m2s.  A nice improvement.
> 
> I haven't noticed anything on the interactivity front.
> 
> Personally, I'd go for sched_mc=2 as default.  I value the fork/exec
> load much more than sensitive benchmarks, though what hurts mysql+oltp
> will certainly hurt others as well.  We have a bit of conflict between
> keeping CPUs busy and affinity cost.  Something to work on.

Hi Mike,

Thanks for the detailed benchmark reports.  Glad to hear that
sched_mc=2 is helping in most scenarios.  Though we would be tempted to
make it default, I would still like to default to zero in order to
provide base line performance.  I would expect end users to flip the
settings to sched_mc=2 if it helps their workload in terms of
performance and/or power savings.

The fact that sched_mc=2 provide performance and/or power saving
benefits is a good justification to include the new code and tunable.

The benefits from the sched_mc=2 settings vary widely based on
workload and system configuration.  Hence in my opinion, I would not
want to change the default to 2 at this time until more wide spread
use of the tunable under various workloads and system configurations.

--Vaidy

