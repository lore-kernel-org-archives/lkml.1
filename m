Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYIPMpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYIPMpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYIPMpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:45:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYIPMpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:45:06 -0400
Date: Tue, 16 Sep 2008 14:49:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       a.p.zijlstra@chello.nl, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/1]: timers: Timer Migration
Message-ID: <20080916124922.GB25711@one.firstfloor.org>
References: <20080916091219.GA1068@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916091219.GA1068@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 02:42:31PM +0530, Arun R Bharadwaj wrote:
> Hi,
> 
> An idle cpu on which device drivers have initialized timers, has to be frequently woken up to service the timers. So, consolidation of timers onto a fewer number of cpus is important. Migration of
> timers from idle cpus onto lesser idle cpus is necessary. Currently, timers are migrated during the cpu offline operation. However cpu-hotplug for the sake of idle system power management is too
> heavy. So, this patch implements a lightweight timer migration framework.


Who would trigger such migrations?

I'm not sure it's a good idea to make it fully manually triggered. It would be nicer 
if it was bound to the scheduler's power saving heuristic. So if the scheduler consolidates
threads on a single package for power saving the timers should follow too.

> 
> Also, in a multi-core, multi-package system, it is always desirable to have all the timers firing on the cpus present in the same package. This would enable us to place the idle package in deep sleep
> state. So, migration of timers is required for this.
> 
> A per_cpu sysfs hook is created at /sys/devices/system/cpu/cpuX/timer_migration. By echo-ing 1 to cpuX/timer_migration, all regular and hrtimers from cpuX are migrated to cpu0. The fact that all
> timers are migrated from cpuX to cpu0 is demonstrated by making a note of /proc/interrupts.


I suspect moving all to cpu 0 is too inflexible as Peter already mentioned.

(haven't looked at the actual code yet sorry)

-Andi
