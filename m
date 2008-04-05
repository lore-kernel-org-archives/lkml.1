Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYDEBZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYDEBZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYDEBYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:24:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751167AbYDEBYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:24:49 -0400
Message-Id: <20080405012447.440875000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:24:47 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: add cpus_scnprintf function v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  * Add a new cpus_scnprintf and a sysctl flag to control how cpumask sets
    are printed.  The default (1) is to use the current cpumask_scnprintf.
    If kernel.compat_cpus_printf is '0', then cpulist_scnprintf is used.
    In addition, a nodes_scnprintf function is provided for compatibilty.

  * This is introduced with a CONFIG_KERN_COMPAT_CPUSET_PRINTF flag which
    currently is only defined for X86_64_SMP architecture.  For all other
    architectures the current cpumask_scnprintf() is used.

  * Add usage information to Documentation/sysctl/kernel.txt for the
    /proc/sys/kernel/compat_cpus_printf flag.

  * Add cpu_sysdev_class functions to display the

	cpu_online_map
	cpu_present_map
	cpu_possible_map
	cpu_system_map

  * Modify usages of cpumask_scnprintf to use the new cpus_scnprintf where
    appropriate.  The list of files affected are:

	arch/x86/kernel/cpu/intel_cacheinfo.c
	drivers/base/node.c
	drivers/base/topology.c
	drivers/pci/pci-sysfs.c
	drivers/pci/probe.c
	kernel/irq/proc.c
	kernel/profile.c
	kernel/sched_stats.h
	kernel/sysctl.c
	kernel/sysctl_check.c
	kernel/trace/trace.c

Note that kernel/sched.c is not in this patchset as it has many other changes,
so the change to use cpus_scnprintf is in a following patchset.

For inclusion in x86/latest.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v2:
    Renamed cpuset_scnprintf() to cpus_scnprintf to avoid confusion with
    "cpusets", and changed the other names to match.

    Added a sentinel character for the cpulist type output so scripts can
    be written to handle both cases.

    Added warning in the Documentation/sysctl/kernel.txt that changing this
    option may break scripts and programs that rely on the current format.
    Also provided example on how to process the output.

    Added information to Documentation/scheduler/sched-stats.txt about
    change in version number because of new cpus_scnprintf function.

-- 
