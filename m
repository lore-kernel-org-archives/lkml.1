Return-Path: <linux-kernel-owner+w=401wt.eu-S967747AbXEHECv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967747AbXEHECv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967722AbXEHECr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:02:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45113 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967721AbXEHECr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:02:47 -0400
Date: Tue, 8 May 2007 09:40:33 +0530
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
Message-ID: <20070508041033.GB25030@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com> <1178545373.28438.7.camel@localhost.localdomain> <877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com> <1178593345.28438.29.camel@localhost.localdomain> <874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 12:29:19PM +0900, Satoru Takeuchi wrote:
> > We used to be able to create kernel threads higher than any userspace
> > priority.  If this is no longer true, I think that's OK: equal priority
> > still means we'll get scheduled, right?
> 
> IF SCHED_RR, yes. However, if SCHED_FIFO, no. Such process doen't have timeslice
> and only relinquish CPU time voluntarily.

yeah ..this is truly a problem if SCHED_FIFO user-space cpu hog task is
running at MAX_USER_RT_PRIO (which happens to be same as max real-time
priority kernel threads can attain - MAX_RT_PRIO).

One option is to make MAX_USER_RT_PRIO < MAX_RT_PRIO. I am not sure what
semantics that will break (perhaps the real-time folks can clarify
that).

The other easier option is to add a wake_up_process_to_front() API in
sched.c, which essentially wakes up the process and enqueues the task to
the front of runqueue.

> # Hence this problem is complicated ;-(

-- 
Regards,
vatsa
