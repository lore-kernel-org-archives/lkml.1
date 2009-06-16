Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZFPIH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZFPIH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZFPIHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:07:44 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:34793 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZFPIHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:07:42 -0400
Date: Tue, 16 Jun 2009 13:37:15 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
Message-ID: <20090616080715.GB7961@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090615232318.74b099a6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090615232318.74b099a6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:

> On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > Currently on a ppc64 box with 16 CPUs, the time taken for
> > a individual cpu-hotplug operation is as follows.
> > 
> > 	# time echo 0 > /sys/devices/system/cpu/cpu2/online
> > 	real    0m0.025s
> > 	user    0m0.000s
> > 	sys     0m0.002s
> > 
> > 	# time echo 1 > /sys/devices/system/cpu/cpu2/online
> > 	real    0m0.021s
> > 	user    0m0.000s
> > 	sys     0m0.000s
> 
> Surprised.  Do people really online and offline CPUs frequently enough
> for this to be a problem?

Certainly not for hardware faults or hardware replacement, but
cpu-hotplug interface is useful for changing system configuration to
meet different objectives like

* Reduce system capacity to reduce average power and reduce heat

* Increasing number of cores and threads in a CPU package is leading
  to multiple cpu offline/online operations for any perceivable effect

* Dynamically change CPU configurations in virtualized environments

Ref:

[1] Saving power by cpu evacuation sched_max_capacity_pct=n
    http://lkml.org/lkml/2009/5/13/173

[2] Make offline cpus to go to deepest idle state using
    http://lkml.org/lkml/2009/5/22/431

[3] cpuset: add new API to change cpuset top group's cpus
    http://lkml.org/lkml/2009/5/19/54        

For getting stuff off a certain CPU, cpu-hotplug framework seems to do
the right thing.  Identifying bottlenecks in the framework can
significantly help other use cases.

--Vaidy

