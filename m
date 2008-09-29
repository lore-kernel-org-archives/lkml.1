Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYI2SDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYI2SDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYI2SCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54277 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753279AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:50 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/31] cpumask: Provide new cpumask API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo Molnar wrote:
>
> could you please send whatever .c changes you have already, so that we 
> can have a look at how the end result will look like? Doesnt have to 
> build, i'm just curious about how it looks like in practice, 
> semantically.
> 
> 	Ingo

Here's one(*) proposal for a new cpumask interface API in a patch
that's compilable.  Obviously with a change of this magnitude, a large
number of files are affected.  I tried to group them into functional
changes, but there are a lot of "clean up" types of patches, so these
are grouped in the second half by sections.  Hopefully this minimizes
the interdependencies between patches.

[* - Rusty has an alternative approach that he'll be submitting shortly.]

The patches in this patchset are:

  * Doc files and basic "cleanup" changes.

	docs
	send_IPI_mask
	remove-min

  * Base changes to cpumask.h and helper files.

	mv-cpumask-alloc
	cpumask-base
	lib-cpumask

  * Minimal changes to let init/main.c compile cleanly.

  	init_main

  * Mechanical changes, mostly automated.

	Modify cpu-maps
	Get-rid-of-_nr variations
	Fix cpumask_of_cpu refs
	Remove set_cpus_allowed_ptr
	Remove CPU_MASK_ALL_PTR
	Modify for_each_cpu_mask
	Change first_cpu/next_cpu to cpus_first/cpus_next
	Remove node_to_cpumask_ptr

  * Sectional changes, to agree with API changes:

	acpi
	apic
	cpu
	cpufreq
	irq
	kernel
	misc
	mm
	pci
	rcu
	sched
	smp
	time
	tlb
	trace
	xen

  * Allocation of temporary onstack cpumask variables.
    (To be supplied.  See cpumask_alloc.h for prelim info.)

  * Changes to non-x86 architecture files.
    (To be supplied.)


These changes should work in the current code.  The flag to turn on the
new code is "CONFIG_CPUMASKS_OFFSTACK".  This is not yet turned on so
this code should be completely compatible with current code, only laying
down the groundwork for when cpumasks will be "offstack".  This should
allow testing to insure that the basic interface is functionally complete.

[Note: testing not yet started.]

-- 
