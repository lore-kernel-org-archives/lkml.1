Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZDVBGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZDVBGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 21:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZDVBGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 21:06:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:49453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbZDVBGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 21:06:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,227,1239001200"; 
   d="scan'208";a="134210469"
Subject: Re: [RFC PATCH v2 0/2] sched: Nominate a power-efficient ILB
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
References: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 21 Apr 2009 18:05:22 -0700
Message-Id: <1240362322.27006.8548.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 21:55 -0700, Gautham R Shenoy wrote:
> Now, the other power-savings settings such as the sched_mc/smt_power_savings
> and the power-aware IRQ balancer try to balance tasks/IRQs by taking
> the system topology into consideration, with the intention of keeping
> as many "power-domains" (cores/packages) in the low-power state.
> 
> The current idle-load-balancer nomination does not necessarily align towards
> this policy. For eg, we could be having tasks and interrupts largely running
> on the first package with the intention of keeping the second package idle.
> Hence, CPU 0 may be busy. The first_cpu in the nohz.cpu_mask happens to be CPU1,
> which in-turn becomes nominated as the idle-load balancer. CPU1 being from
> the 2nd package, would in turn prevent the 2nd package from going into a
> deeper sleep state.
> 
> Instead the role of the idle-load balancer could have been assumed by an
> idle CPU from the first package, thereby helping the second package go
> completely idle.

Can we also do this by default? i.e., even when no power-savings policy
is selected.

I don't see anything wrong by enabling this logic for all the cases.

thanks,
suresh

