Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZAGLYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZAGLYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZAGLXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:23:55 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56558 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZAGLXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:23:54 -0500
Date: Wed, 7 Jan 2009 16:56:39 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090107112639.GI4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1231098769.5757.43.camel@marge.simson.net> <20090105032029.GE4301@dirshya.in.ibm.com> <1231130416.5479.8.camel@marge.simson.net> <1231137413.10471.23.camel@marge.simson.net> <1231168786.9120.26.camel@marge.simson.net> <1231234297.3806.50.camel@marge.simson.net> <20090106150709.GG4574@dirshya.in.ibm.com> <1231264117.5254.23.camel@marge.simson.net> <20090106184552.GI17198@balbir.in.ibm.com> <1231318755.3899.57.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231318755.3899.57.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-07 09:59:15]:

> I have a couple questions if you don't mind.
> 
> In wake_idle() there's an odd looking check for kthreads.  Why does it
> matter if a kbuild task wakes kernel or userland helper thread?

Only user space tasks/threads should be biased at wakeup and
consolidated for the following reasons:

* kernel threads generally perform housekeeping tasks and its rate of
  execution and cpu utilisation is far less than that of user task in
  an under utilised system.  
* Biasing at wakeup help consolidate bursty user space tasks. Long
  running user space tasks will be consolidated by load balancer.
  kthreads are not bursty, they are generally very short running.

> I also don't see why sched_mc overrides domain tunings.  You can turn
> NEWIDLE off and sched_mc remains as set, so it's a one-way override.  If
> NEWIDLE is a requirement for sched_mc > 0, it seems only logical to set
> sched_mc to 0 if the user explicitly disables NEWIDLE.

SD_BALANCE_NEWIDLE is required for sched_mc=2 and power savings while
not mandated for sched_mc=0.  We can remove NEWIDLE balance at
sched_mc=0 if that helps baseline performance.  Ingo had identified
that removing NEWIDLE balance help performance in certain benchmarks.

I do not get what you have mentioned by NEWIDLE off?  Is there
a separate user space control to independently set or reset
SD_BALANCE_NEWIDLE at a give sched_domain level?

Thanks for the detailed review.

--Vaidy

