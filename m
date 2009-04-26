Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZDZQ4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZDZQ4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZDZQ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:56:43 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48585 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZDZQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:56:42 -0400
Date: Sun, 26 Apr 2009 22:26:42 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC PATCH v2 0/2] sched: Nominate a power-efficient ILB
Message-ID: <20090426165642.GA6182@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090414045356.7645.33369.stgit@sofia.in.ibm.com> <1240362322.27006.8548.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1240362322.27006.8548.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2009-04-21 18:05:22]:

> On Mon, 2009-04-13 at 21:55 -0700, Gautham R Shenoy wrote:
> > Now, the other power-savings settings such as the sched_mc/smt_power_savings
> > and the power-aware IRQ balancer try to balance tasks/IRQs by taking
> > the system topology into consideration, with the intention of keeping
> > as many "power-domains" (cores/packages) in the low-power state.
> > 
> > The current idle-load-balancer nomination does not necessarily align towards
> > this policy. For eg, we could be having tasks and interrupts largely running
> > on the first package with the intention of keeping the second package idle.
> > Hence, CPU 0 may be busy. The first_cpu in the nohz.cpu_mask happens to be CPU1,
> > which in-turn becomes nominated as the idle-load balancer. CPU1 being from
> > the 2nd package, would in turn prevent the 2nd package from going into a
> > deeper sleep state.
> > 
> > Instead the role of the idle-load balancer could have been assumed by an
> > idle CPU from the first package, thereby helping the second package go
> > completely idle.
> 
> Can we also do this by default? i.e., even when no power-savings policy
> is selected.
> 
> I don't see anything wrong by enabling this logic for all the cases.

Hi Suresh,

Thanks for the review.  The selection of the idle-load-balancer
depends on the sched domain level with SD_POWERSAVINGS_BALANCE flag
set that indicates the cpu-package boundary.  Hence this scheme
depends on sched_mc_powersavings being non zero so that the sched
domains (cpu level) are build based on cpu-package information.

The logical-cpu to cpu-package grouping information is not readily
available (in the sched domain) when power-saving policies are off.

We may need to look at selection of idle-load-balancer for maximum
performance (bandwidth utilisation) when power save policies are off.

--Vaidy
