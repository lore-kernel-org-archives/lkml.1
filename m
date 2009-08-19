Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbZHSM50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbZHSM50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZHSM5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:57:25 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35604 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZHSM5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:57:25 -0400
Date: Wed, 19 Aug 2009 18:27:16 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/2]: cpuidle: Introducing cpuidle infrastructure to
	powerpc.
Message-ID: <20090819125716.GA20627@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


**** RFC not for inclusion ****

"Cpuidle" is a CPU Power Management infrastrusture which helps manage
idle CPUs in a clean and efficient manner. The architecture can register
its driver (in this case, tpmd_idle driver) so that it subscribes for
cpuidle feature. Cpuidle has a set of governors (ladder and menu),
which will decide the best idle state to be chosen for the current situation,
based on heuristics, and calculates the expected residency time
for the current idle state. So based on this, the cpu is put into
the right idle state.

Currently, cpuidle infrasture is exploited by ACPI to choose between
the available ACPI C-states. This patch-set is aimed at enabling
cpuidle for powerpc and provides a sample implementation for pseries.

Currently, in the pseries_dedicated_idle_sleep(), the processor would
poll for a time period, which is called the snooze, and only then it
is ceded, which would put the processor in nap state. Cpuidle aims at
separating this into 2 different idle states. Based on the expected
residency time predicted by the cpuidle governor, the idle state is
chosen directly. So, choosing to enter the nap state directly based on
the decision made by cpuidle would avoid unnecessary snoozing before
entering nap.

This patch-set tries to achieve the above objective by introducing a
Thermal and Power Management Device module called tpmd_idle in
arch/powerpc/platform/pseries/tpmd_idle.c, which implements cpuidle
idle loop which would replace the pseries_dedicated_idle_sleep()
when cpuidle is enabled.

Patches included in this set:
PATCH 1/2 - Enable cpuidle for pSeries.
PATCH 2/2 - Implement Thermal & Power Management Devices(TPMD) idle module


Any feedback on the overall design and idea is immensely valuable.

--arun
