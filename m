Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZDPGmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZDPGmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZDPGmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:42:11 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51591 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZDPGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:42:10 -0400
Date: Thu, 16 Apr 2009 12:11:36 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Richard Henderson <rth@twiddle.net>, Chris Zankel <chris@zankel.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [v6 PATCH 0/4] timers: Framework for migration of timers
Message-ID: <20090416064136.GA7510@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas, all,


In an SMP system, tasks are scheduled on different CPUs by the
scheduler, interrupts are managed by irqbalancer daemon, but timers
are still stuck to the CPUs that they have been initialised.  Timers
queued by tasks gets re-queued on the CPU where the task gets to run
next, but timers from IRQ context like the ones in device drivers are
still stuck on the CPU they were initialised.  This framework will
help move all 'movable timers' using a sysctl interface.

Please consider for inclusion into -tip


Testing Carried Out:

* Kernbench on a 2-package, quad-core machine results are as follows:

-----------------------------------------------------------------------
| No. of Threads  |	 Time(s) - Without   |	   Time(s) - With the |
|		  |       patches applied    |	     patches applied  |
-----------------------------------------------------------------------
|	2	  |	      106.9	     |		106.3	      |
|	4	  |	       54.7	     |		 54.4	      |
|	8	  |	       31.5	     |		 31.1	      |
|      16	  |	       28.0	     |		 27.5	      |
|      32	  |	       28.1	     |		 28.9	      |
-----------------------------------------------------------------------

* I have cross-compiled my patches against alpha architecture in order
to test if my patches have any issues for architectures without
clockevents support.

The patches cross-compile without any issues for alpha architecture,
but I need help to test if there is any performance regression.
So I'm Cc-ing the maintainers of architectures without clockevents support.


The following patches are included:
PATCH 1/4 - framework to identify pinned timers.
PATCH 2/4 - identifying the existing pinned hrtimers.
PATCH 3/4 - /proc/sys sysctl hook to enable timer migration.
PATCH 4/4 - logic to enable timer migration.

The patchset is based on the latest tip/master.

Timer migration is enabled by default.
It can be turned off when CONFIG_SCHED_DEBUG=y by

echo 0 > /proc/sys/kernel/timer_migration


--arun
