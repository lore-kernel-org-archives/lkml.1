Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbXEHQlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbXEHQlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934094AbXEHQlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:41:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:32902 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068AbXEHQlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:41:08 -0400
Date: Tue, 8 May 2007 22:18:50 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       paulmck@us.ibm.com
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty	realtime	processes
Message-ID: <20070508164850.GS7311@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com> <1178545373.28438.7.camel@localhost.localdomain> <877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com> <1178593345.28438.29.camel@localhost.localdomain> <874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com> <20070508041033.GB25030@in.ibm.com> <87irb3g4zt.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87irb3g4zt.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:16:06PM +0900, Satoru Takeuchi wrote:
> Sometimes I wonder at prio_array. It has 140 entries(from 0 to 139),
> and the meaning of each entry is as follows, I think.
> 
> +-----------+-----------------------------------------------+
> | index     | usage                                         |
> +-----------+-----------------------------------------------+
> | 0 - 98    | RT processes are here. They are in the entry  |
> |           | whose index is 99 - sched_priority.           |

>From sched.h:

/*
 * Priority of a process goes from 0..MAX_PRIO-1, valid RT
 * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
 * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1.

so shouldn't the index for RT processes be 0 - 99, given that
MAX_RT_PRIO = 100?

> +-----------+-----------------------------------------------+
> | 99        | No one use it? CMIIW.                         |
> +-----------+-----------------------------------------------+
> | 100 - 139 | Ordinally processes are here. They are in the |
> |           | entry whose index is (nice+120) +/- 5         |
> +-----------+-----------------------------------------------+
> 
> What's the purpose of the prio_array[99]? Once I exlore source tree
> briefly and can't found any kernel thread which uses this entry.
> Does anybody know?

-- 
Regards,
vatsa
