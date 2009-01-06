Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZAFJb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZAFJb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZAFJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:31:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:57803 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751164AbZAFJbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:31:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19JIs8n31BJapo5AtTW1iSdb5zhP7v6oUtnFkY+xC
	9ZiLHCYSsYoiL4
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1231168786.9120.26.camel@marge.simson.net>
References: <20081230062139.GA30038@elte.hu>
	 <20081230180722.GA29060@dirshya.in.ibm.com>
	 <20090102072600.GA13412@dirshya.in.ibm.com>
	 <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net>
	 <20090103101626.GA4301@dirshya.in.ibm.com>
	 <1230981761.27180.10.camel@marge.simson.net>
	 <1231081200.17224.44.camel@marge.simson.net>
	 <20090104181946.GC4301@dirshya.in.ibm.com>
	 <1231098769.5757.43.camel@marge.simson.net>
	 <20090105032029.GE4301@dirshya.in.ibm.com>
	 <1231130416.5479.8.camel@marge.simson.net>
	 <1231137413.10471.23.camel@marge.simson.net>
	 <1231168786.9120.26.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 10:31:37 +0100
Message-Id: <1231234297.3806.50.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 16:19 +0100, Mike Galbraith wrote:
> On Mon, 2009-01-05 at 07:37 +0100, Mike Galbraith wrote:
> 
> > I'll rummage around.
> 
> Seems to be about the only thing it could be, load balancing inflicting
> injury on very sensitive mysql+oltp pairs.

BTW, I verified this.  Reverting all load-balancing changes fully
restored mysql+oltp peak, and brought mid-range throughput to the same
level as sched_mc=2 except at the log-jam end.  (haven't looked at
vmark, though I'd expect it to be hurting a bit too, it's affinity
sensitive as well)

I expected sched_mc=2 to help an nfs mount kbuild, and it did, quite a
bit.  I first tried an nfs4 mount, but after a while, the odd ipv6 80%
idle problem came back, so I reverted to nfs3.  Full built time there
went from 4m25s to 4m2s.  A nice improvement.

I haven't noticed anything on the interactivity front.

Personally, I'd go for sched_mc=2 as default.  I value the fork/exec
load much more than sensitive benchmarks, though what hurts mysql+oltp
will certainly hurt others as well.  We have a bit of conflict between
keeping CPUs busy and affinity cost.  Something to work on.

	-Mike

