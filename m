Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZJFJQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZJFJQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbZJFJQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:16:50 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35204 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbZJFJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:16:48 -0400
Date: Tue, 6 Oct 2009 14:46:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       a.p.zijlstra@chello.nl, shaohua.li@intel.com, svaidy@linux.vnet.ibm.com
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for
 2.6.32-rc1
Message-ID: <20091006091606.GA6818@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
 <20091005033256.GA26592@balbir.in.ibm.com>
 <200910052159.24920.rjw@sisk.pl>
 <20091005140415.57f1db5e.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0910051818130.32307@localhost.localdomain>
 <20091005154021.129a8f9f.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0910051614510.3432@localhost.localdomain>
 <alpine.LFD.2.00.0910052054540.309@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910052054540.309@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2009-10-05 21:28:18]:

> > ...  we probably never want to even try 
> > to solve it in the scheduler, because why the hell should we care and add 
> > complex logic for something like that?
> 
> Today we take cores down to 100% idle, one at a time.
> This is useful, but isn't the best we can do.
> 
> For we get zero "uncore" power savings.
> As long as at least one core is active anywhere in the system,
> all the uncores in all the packages in the system must remain active.
> 
> What a scheduler-based solution could do is
> instead of taking, say, 1 of 64 cores down for 100%
> of the period, it could take all 64 cores down
> for 64th of the same period.  This could get the hardware
> into the deeper "package C-states", for a measurable
> net power savings.
> 
> At the same time, this system-wide throttling may mitigate
> some of the fairness/availability issues raised regarding
> taking cores 100% off-line.
> 
> But doing this optimally will not be trivial.
> The hardware must stay in the deep-sleep-states long enough
> to make it worth the energy to enter and exit those states.
> The hardware will flush the caches, having a performance
> impact on all the cores.  Device interrupts would prevent
> the cores from sleeping, so they'd need to be somehow delayed
> if we are to sleep long enough to make sleeping worth it etc.
>

My concern is the side-effects of an approach like this. In the case
that was pointed out earlier about hotplug breaking CPUSets, this
solution can lead to starvation (single CPU in a cpuset). Most distros
will enable this feature right? So most end users will see this thread
running when ACPI 4.0 firmware decides to do thermal throttling.

-- 
	Balbir
