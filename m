Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZDALcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZDALcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZDALbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:31:55 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55582 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZDALby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:31:54 -0400
Date: Wed, 1 Apr 2009 17:01:28 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, arun@linux.vnet.ibm.com
Subject: [v4 RFC PATCH 0/4] timers: Framework for migration of timers
Message-ID: <20090401113128.GA22478@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


In an SMP system, tasks are scheduled on different CPUs by the
scheduler, interrupts are managed by irqbalancer daemon, but timers
are still stuck to the CPUs that they have been initialised.  Timers
queued by tasks gets re-queued on the CPU where the task gets to run
next, but timers from IRQ context like the ones in device drivers are
still stuck on the CPU they were initialised.  This framework will
help move all 'movable timers' using a sysctl interface.

Iteration v3 of this patch can be found at
http://lkml.org/lkml/2009/3/16/162

Changelog: v3->v4

-An hrtimer is migrated *only* if its expiry occurs after the next timer
interrupt on the CPU to which it is being migrated to. This prevents any
possible latency, which might have arised otherwise due to migration.

So, a few helper functions have been added to check if migration would
result in latency or not.
Thanks to Thomas for pointing out this issue.

The following patches are included:
PATCH 1/4 - framework to identify pinned timers.
PATCH 2/4 - identifying the existing pinned hrtimers.
PATCH 3/4 - /proc/sys sysctl hook to enable timer migration.
PATCH 4/4 - logic to enable timer migration.

The patchset is based on the latest tip/master.

Timer migration is enabled by default as suggested by Ingo.
It can be turned off when CONFIG_SCHED_DEBUG=y by

echo 0 > /proc/sys/kernel/timer_migration



Please let me know your comments.

--arun
