Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbXBNOlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbXBNOlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbXBNOlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:41:53 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35313 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbXBNOlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:41:52 -0500
Date: Wed, 14 Feb 2007 20:10:31 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu
Cc: vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl
Subject: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070214144031.GA15257@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everybody,

This is an experiment towards process_freezer based implementation
of cpu-hotplug. This is mainly based on ideas of Andrew Morton, 
Ingo Molnar and Paul Mckenney featured in the discussion
http://lkml.org/lkml/2007/1/31/323.

This is an absolute bare-minimal implementation to check the feasibility
of using process freezer for cpu-hotplug. 

The patchset comprises of four patches.
o PATCH 1/4: Core implementation of freezer-based-hotplug.
o PATCH 2/4: Revert changes to workqueue to make it work with the
             freezer-cpu-hotplug.
o PATCH 3/4: Eliminate hotcpu subsystem mutexes from sched and slab.
o PATCH 4/4: Eliminate lock_cpu_hotplug from the kernel.

These patches have been stress tested on i386 SMP box, with cpu-hotplug
operations in a tight-loop and make -jN (kernel compile) running
parallely. The cpu hotplug operations have been pretty stable.

Observation:
-------------
Certain threads like ksoftirqd/1, firmware.agent
were not frozen during the hotplug operations. However, these
were rare occurances.

This implementation is by no means perfect or complete. Things
that are yet to be done are as follows:

- Most of Paul's suggestions including introduction of new states
  for process freezer like PFE_SUSPEND, PFE_KPROBES, PFE_HOTPLUG
  so that processes which are not concerned with these events
  can be exempted from being frozen.

- Ensure the working of cpu_hotplug on all architectures on which 
  it is supported. At present, it has been tested only on i386.

- Updated documentation for cpu-hotplug.

Any feedback would be greatly appreciated.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
