Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXJMFAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXJMFAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXJMFA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:00:26 -0400
Received: from qsrv02sl.mx.bigpond.com ([144.140.93.182]:62508 "EHLO
	qsrv02sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXJMFAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:00:25 -0400
Message-ID: <47101F7D.8050101@bigpond.net.au>
Date: Sat, 13 Oct 2007 11:29:33 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
References: <20071012064927.GA1962@ff.dom.local>
In-Reply-To: <20071012064927.GA1962@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [124.179.200.236] using ID pwil3058@bigpond.net.au at Sat, 13 Oct 2007 01:29:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 12-10-2007 00:23, Peter Williams wrote:
> ...
>> The reason I was going that route was for modularity (which helps when 
>> adding plugsched patches).  I'll submit a revised patch for consideration.
> ...
> 
> IMHO, it looks like modularity could suck here:
> 
>> +static unsigned int default_timeslice_fair(struct task_struct *p)
>> +{
>> +	return NS_TO_JIFFIES(sysctl_sched_min_granularity);
>> +}
> 
> If it's needed for outside and sched_fair will use something else
> (to avoid double conversion) this could be misleading. Shouldn't
> this be kind of private and return something usable for the class
> mainly?

This is supplying data for a system call not something for internal use 
by the class.  As far as the sched_fair class is concerned this is just 
a (necessary - because it's need by a system call) diversion.

> Why anything else than sched_fair should care about this?

sched_fair doesn't care so if nothing else does why do we even have 
sys_sched_rr_get_interval()?  Is this whole function an anachronism that 
can be expunged?  I'm assuming that the reason it exists is that there 
are user space programs that use this system call.  Am I correct in this 
assumption?  Personally, I can't think of anything it would be useful 
for other than satisfying curiosity.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
