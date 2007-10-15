Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbXJOLIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbXJOLIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759004AbXJOLIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:08:35 -0400
Received: from mx10.go2.pl ([193.17.41.74]:36196 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758353AbXJOLIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:08:34 -0400
Date: Mon, 15 Oct 2007 13:11:32 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Message-ID: <20071015111132.GA3015@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47101F7D.8050101@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-10-2007 03:29, Peter Williams wrote:
> Jarek Poplawski wrote:
>> On 12-10-2007 00:23, Peter Williams wrote:
>> ...
>>> The reason I was going that route was for modularity (which helps 
>>> when adding plugsched patches).  I'll submit a revised patch for 
>>> consideration.
>> ...
>>
>> IMHO, it looks like modularity could suck here:
>>
>>> +static unsigned int default_timeslice_fair(struct task_struct *p)
>>> +{
>>> +    return NS_TO_JIFFIES(sysctl_sched_min_granularity);
>>> +}
>>
>> If it's needed for outside and sched_fair will use something else
>> (to avoid double conversion) this could be misleading. Shouldn't
>> this be kind of private and return something usable for the class
>> mainly?
> 
> This is supplying data for a system call not something for internal use 
> by the class.  As far as the sched_fair class is concerned this is just 
> a (necessary - because it's need by a system call) diversion.

So, now all is clear: this is the misleading case!

> 
>> Why anything else than sched_fair should care about this?
> 
> sched_fair doesn't care so if nothing else does why do we even have 
> sys_sched_rr_get_interval()?  Is this whole function an anachronism that 
> can be expunged?  I'm assuming that the reason it exists is that there 
> are user space programs that use this system call.  Am I correct in this 
> assumption?  Personally, I can't think of anything it would be useful 
> for other than satisfying curiosity.

Since this is for some special aim (not default for most classes, at
least not for sched_fair) I'd suggest to change names:
default_timeslice_fair() and .default_timeslice to something like eg.:
rr_timeslice_fair() and .rr_timeslice or rr_interval_fair() and
.rr_interval (maybe with this "default" before_"rr_" if necessary).

On the other hand man (2) sched_rr_get_interval mentions that:
"The identified process should be running under the SCHED_RR
scheduling policy".

Also this place seems to say about something simpler:
http://www.gnu.org/software/libc/manual/html_node/Basic-Scheduling-Functions.html

So, I still doubt sched_fair's "notion" of timeslices should be
necessary here.

Sorry for too harsh words.

Thanks,
Jarek P.
