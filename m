Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYFZSvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYFZSvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYFZSu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:50:57 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48559 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYFZSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:50:56 -0400
Date: Fri, 27 Jun 2008 00:22:54 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080626185254.GA12416@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4863DB29.1020304@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2008-06-26 20:08:41]:

> 
> > A user could be an application and certain applications can predict their
> > workload.
> 
> So you expect the applications to run suid root and change a sysctl?
> And what happens when two applications run that do that and they have differing
> requirements? Will they fight over the sysctl?

System management software and workload monitoring and managing
software can potentially control the tunable on behalf of the
applications for best overall power savings and performance.

Applications with conflicting goals should resolve among themselves.
The application with highest performance requirement should win.  The
power QoS framework set_acceptable_latency() ensures that the lowest
latency set across the system wins.  This tunable can also be based on
the similar approach.

 
> > For example, a database, a file indexer, etc can predict their workload.
> 
> 
> A file indexer should run with a high nice level and low priority would ideally always
> prefer power saving. But it doesn't currently. Perhaps it should?

Power management settings affect the entire system.  It may not be
based on per application priority or nice value.  However if the
priority of all the applications currently running in the system
indicate power savings, then the kernel can goto more aggressive power
saving state.

> > 
> > Policies are best known in user land and the best controlled from there.
> > Consider a case where the end user might select a performance based policy or a
> > policy to aggressively save power (during peak tariff times). With
> 
> How many users are going to do that? Seems like a unrealistic case to me.

System management software should do this.  Certainly manual
intervention to change these settings will not be popular.  Given the
trends in virtualisation and modular systems, most datacenters will
use some form of systems management software and infrastructure that
is empowered to make policy based decisions on provisioning and
systems configuration.

In a small-scale datacenters, peak and off-peak hour settings can be
potentially done through simple cron jobs.  

--Vaidy
