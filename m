Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZKZT6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZKZT6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZKZT6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:58:49 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40145 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:58:48 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v6 0/2] pseries: Add cede support for cpu-offline
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>, Vaidy <svaidy@linux.vnet.ibm.com>
Date: Fri, 27 Nov 2009 01:28:45 +0530
Message-ID: <20091126195121.29159.66098.stgit@drishya>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 6 of patch series that provides a framework to choose the state
a pseries CPU must be put to when it is offlined.

Previous versions can be found here:
Version 5: http://lkml.org/lkml/2009/10/30/6
Version 4: http://lkml.org/lkml/2009/10/9/59
Version 3: http://lkml.org/lkml/2009/9/15/164
Version 2: http://lkml.org/lkml/2009/8/28/102
Version 1: http://lkml.org/lkml/2009/8/6/236

Changes from the previous version include:

- Built on Nathan Fontenot's v3 of "Kernel handling of Dynamic
  Logical Partitioning" http://lkml.org/lkml/2009/11/25/21

- Rebased to powerpc.git tree and hence dropped 1st and 2nd patch in
  the stack since they are already in the powerpc.git tree:

  With reference to previous version,

  Dropped:
  1/4 pSeries: extended_cede_processor() helper function
  2/4 pSeries: Add hooks to put the CPU into an appropriate offline state

  Posting only:
  3/4 pseries: Add code to online/offline CPUs of a DLPAR node
  4/4 pseries: Serialize cpu hotplug operations during deactivate Vs deallocate

  Minor changes in the above patchs due to changes in Nathan's routines.

Also,

- This approach addresses Peter Z's objections regarding layering
  violations. The user simply offlines the cpu and doesn't worry about what
  state the CPU should be put into. That part is automatically handled by the
  kernel.

  Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
  http://lkml.org/lkml/2009/11/11/328

- It does not add any additional sysfs interface instead uses the existing
  sysfs interface to offline CPUs.

- On platforms which do not have support for ceding the vcpu with a
  latency specifier value, the offlining mechanism defaults to the current
  method of calling rtas_stop_self().

This patchset is based on powerpc.git + Nathan's patches and has been built and
tested on pseries platforms.  This series can be applied to powerpc.git after
Nathan's patches.

Thanks,
Vaidy

---

Gautham R Shenoy (2):
      pseries: Serialize cpu hotplug operations during deactivate Vs deallocate
      pseries: Add code to online/offline CPUs of a DLPAR node


 arch/powerpc/platforms/pseries/dlpar.c |  144 ++++++++++++++++++++++++++++++--
 drivers/base/cpu.c                     |    2 
 include/linux/cpu.h                    |   13 +++
 3 files changed, 150 insertions(+), 9 deletions(-)

-- 
