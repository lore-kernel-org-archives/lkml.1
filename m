Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYH2OIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYH2OIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbYH2OI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:08:26 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51764 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbYH2OIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:08:25 -0400
Date: Fri, 29 Aug 2008 19:35:44 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: sched_mc_power_savings broken with CGROUPS+CPUSETS
Message-ID: <20080829140544.GT4801@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Gregory Haskins <ghaskins@novell.com>
References: <20080829131514.GS4801@dirshya.in.ibm.com> <1220016237.17355.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1220016237.17355.48.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2008-08-29 15:23:57]:

> On Fri, 2008-08-29 at 18:45 +0530, Vaidyanathan Srinivasan wrote:
> > Hi,
> > 
> > sched_mc_power_savings seems to be broken with CGROUPS+CPUSETS.
> > When CONFIG_CPUSETS=y the attached BUG_ON() is being hit.
> > 
> > I added a BUG_ON to check if SD_POWERSAVINGS_BALANCE is set at
> > SD_LV_CPU whenever sched_mc_power_savings is set.
> > 
> > This BUG is hit when config CONFIG_CPUSETS (depends on CONFIG_CGROUPS)
> > is just compiled in while this is never hit when they are compiled
> > out.  The fact that SD_POWERSAVINGS_BALANCE being cleared even when
> > sched_mc_power_savings = 1 completely breaks the
> > sched_mc_power_savings heuristics.
> > 
> > To recreate the problem, 
> > Have sched_mc power savings enabled CONFIG_SCHED_MC=y
> > Add this BUG_ON()
> > 
> > echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> > 
> > Try these these on a multi core x86 box.
> > 
> > sched_mc_power_savings seems to be broken from 2.6.26-rc1, but
> > I do not have a confirmation that the root cause is same in all
> > successive versions. sched_mc_power_savings works perfect in 
> > 2.6.25.
> > 
> > Please help me root cause the issue.  Please point me to changes that
> > may potential cause this bug.
> 
> I'm still greatly mistified by all that power savings code.
> 
> Its hard to read and utterly hard to comprehend - I've been about to rip
> the whole stuff out on several occasions. But so far tried to carefully
> thread around it maintaining its operation even though not fully
> understood.
> 
> Someone with clue - preferably the authors of the code in question -
> should enlighten us with a patch that adds some comments as to the
> intent of said lines of code.

I will try to add my notes around it.  I have been playing around with
sched_mc to make it work for different workloads.

--Vaidy

