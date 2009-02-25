Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbZBYK5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbZBYK5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZBYK5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:57:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41642 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZBYK5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:57:07 -0500
Date: Wed, 25 Feb 2009 16:27:30 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 0/2] CPU controller statistics - v5
Message-ID: <20090225105730.GA4008@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Last year, Balaji posted a patch to collect CPU controller statistics. After
a few initial versions, I couldn't see any activity. Here I am posting the
next version of the patch for review.

Changes for v5:

- Updated to 2.6.29-rc6.
- Separated cgroup modifications into a different patch.
- Changed the prototype of the ->initialize() subsystem API from
  cgroup_subsys->initialize(int early) to cgroup_subsys->initialize(void)
  and calling it only from cgroup_init() and not from cgroup_init_early().
- Updated documentation for new API.
- Added guest time metric as another cpu controller statistic.
- Free percpu statistics counters when the cgroup is brought down.
- Account irq and softirq time also as system time for cgroup accounting.
- Separate out stats collection code under CONFIG_CGROUP_SCHED to a helper
  funtion to reduce ifdefs.

v4:
- http://lkml.org/lkml/2008/5/11/163

I have tried to address most of the comments given for the 4th version
of the patch. A few questions still remain:

- percpu counters are used for stats collection. Since percpu counters
  aren't usable during cgroup_init_early(), we have to allocate
  percpu stats counter for init_task_group separately later during
  cgroup_init(). Because of this, in the stats collection code, we
  end up having a 'is stats counter allocated?' check
- This patch collects per cgroup cpu controller stats. Does it make
  sense to account stime and utime hierarchially ? If so, we would
  probably be duplicating what cpuacct controller already does.
- Is steal time a useful per-cgroup metric ? Perhaps in container based
  virtualized environments ?

Regards,
Bharata.
