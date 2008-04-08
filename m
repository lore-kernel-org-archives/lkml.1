Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYDHSnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYDHSnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 14:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbYDHSnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 14:43:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41281 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756762AbYDHSnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 14:43:03 -0400
Message-Id: <20080408184301.651388000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Apr 2008 11:43:01 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: add cpus_scnprintf function v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  * Add cpu_sysdev_class functions to display the

	cpu_online_map
	cpu_present_map
	cpu_possible_map
	cpu_system_map

  * Cleanup usages of cpumask_scprintf in the following files and add
    another interface to use cpulist_scnprintf where appropriate.

	arch/x86/kernel/cpu/intel_cacheinfo.c
	drivers/base/cpu.c
	drivers/base/node.c
	drivers/base/topology.c
	drivers/pci/pci-sysfs.c
	drivers/pci/probe.c
	include/linux/sysdev.h
	kernel/cpuset.c
	kernel/sched_stats.h
	kernel/trace/trace.c

  - The new interface is generally the same base name but uses 'list'
    instead of 'map'.  For example, there is now:

	# cat /sys/devices/system/node/node0/cpumap
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003

  - And the new interface:

	# cat /sys/devices/system/node/node0/cpulist
	0-1

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v3:
    Removed cpus_scnprintf() and all references.

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
