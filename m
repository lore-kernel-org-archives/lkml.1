Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZIVLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZIVLZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbZIVLZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:25:37 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39283 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbZIVLZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:25:37 -0400
Date: Tue, 22 Sep 2009 16:55:27 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v6 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power management
	code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
	cpuidle to POWER.
Message-ID: <20090922112526.GA7788@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset introduces cpuidle infrastructure to POWER, prototyping
for pSeries, and also does a major refactoring of current x86 idle
power management and a cleanup of cpuidle infrastructure.

My earlier iterations can be found at:

v5 --> http://lkml.org/lkml/2009/9/22/26
v4 --> http://lkml.org/lkml/2009/9/1/133
v3 --> http://lkml.org/lkml/2009/8/27/124
v2 --> http://lkml.org/lkml/2009/8/26/233
v1 --> http://lkml.org/lkml/2009/8/19/150


Changes in this version:
------------------------------------------
Remove the bug from previous iteration in the routine
cpuidle_remove_from_list(), which was causing the kernel to panic on
platform supporting multiple sleep states.

Add the routine cpuidle_kick_cpus() in POWER, which is needed to kick
the cpus out of their idle when changing the idle routines.


TODO:
-------------------------------------------
Peterz suggested it would be nice to have a sysfs interface through
which an idle routine can be forced at runtime.

Also, current implementation registers every cpu as a cpuidle_device,
but this is an overkill and the registering mechanism should be a
systemwide process and not per-cpu. (probably one of the original
cpuidle authors can reply to this - Venki, Shaohua Li? ).

ppc_md.power_save has been replaced by cpuidle_idle_call only for
pseries. So this needs to be done for all POWER platforms so that
ppc_md.power_save is completely removed.


Any comments on the design is welcome.

--arun
