Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZENPOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZENPOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZENPN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:13:56 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47261 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZENPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:13:56 -0400
Date: Thu, 14 May 2009 20:43:30 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
	sched_max_capacity_pct=n
Message-ID: <20090514151330.GI4853@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090513150100.GW19296@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2009-05-13 17:01:00]:

> > >From what I've been told its popular to over-commit the cooling capacity
> > in a rack, so that a number of servers can run at full thermal capacity
> > but not all.
> 
> Yes. But in this case you don't want to use throttling, you want
> to use p-states which actually safe power unlike throttling.

One of the design points for the discussion is to bring in C-States
into the equation.  As you have mentioned today we can effectively use
P-States to reduce core frequency and thereby reduce average power
and heat.  With the introduction of very low power deep sleep states
in the processor, C-States can provide substantial power savings apart
from just P-State based methods.  Forcefully idling cores will lead to
exploitation of C-States and their power savings benefits.

As mentioned earlier, cpu throttling as it exist today should not
be used in normal operating conditions.  However exploiting P-States
and C-States as two control variables, the system can be made to
operate at various power (thermal) and performance points.

> 
> > I've also been told that hardware sucks at throttling, 
> 
> Throttling is not really something you should use in normal 
> operation, it's just a emergency measure. For that it works
> quite well, but you really don't want it in normal operation.
> 
> > therefore people
> > want to fix the OS so as to limit the thermal capacity and avoid the
> > hardware throttle from kicking in, whilst still not exceeding the rack
> > capacity or similar nonsense.
> 
> Yes that's fine and common, but you actually need to save power for this,
> which throttling doesn't do.

Reducing work, scheduling them smartly in the OS can greatly save
power as compared to throttling in hardware in order to reduce power
or heat.
 
> My understanding this work is a extension of the existing
> sched_mc_power_savings features that tries to be optionally more 
> aggressive to keep complete package idle so that package level
> power saving kicks in.

Scheduling work smartly (power efficiently) is part of the
sched_mc_power_savings framework, while this RFC/discussion is around
reducing work or forcing idle times but at a granularity of
cores/packages to provide maximum power/thermal benefits.

--Vaidy
