Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXEGMkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXEGMkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933613AbXEGMkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:40:02 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48255 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571AbXEGMkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:40:00 -0400
Date: Mon, 7 May 2007 18:09:56 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty realtime processes
Message-ID: <20070507123956.GA11416@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com> <20070507104724.GA10624@in.ibm.com> <20070507110256.GM7311@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507110256.GM7311@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 04:32:56PM +0530, Srivatsa Vaddagiri wrote:
> On Mon, May 07, 2007 at 04:17:24PM +0530, Gautham R Shenoy wrote:
> > Nevertheless, with the freezer based approach that we're experimenting,
> > this problem shouldn't arise. We expect the whole system to get frozen
> > before we actually do a cpu_down() (which will then call
> > __stop_machine_run). So any such rogue RT task will have to first fail
> > the freezer ( which it will), 
> 
> >From what I understand of the freezer, if the RT task is running in user
> space (which seems to be the case in this thread), it should get frozen even 
> if it is a forever running SCHED_FIFO task at MAX_RT_PRIO -1 priority?

Yes, you are right. It will end up getting the fake signal. 
So yeah, freezer pretty much solves the problem for cpu hotplug.

But I now wonder if we will have some problem with module stopping if we 
have a high prio SCHED_FIFO in the system.

> 
> -- 
> Regards,
> vatsa

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
