Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYELCEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYELCEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYELCEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:04:14 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:40844 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYELCEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:04:13 -0400
Date: Mon, 12 May 2008 07:34:02 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: vatsa@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080512020402.GF15063@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang> <20080508054047.GD32729@linux.vnet.ibm.com> <1210226013.3453.113.camel@ymzhang> <20080508061125.GC3644@linux.vnet.ibm.com> <20080509155240.GH3612@linux.vnet.ibm.com> <1210556351.3151.2.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210556351.3151.2.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 09:39:10AM +0800, Zhang, Yanmin wrote:
> 
> On Fri, 2008-05-09 at 21:22 +0530, Srivatsa Vaddagiri wrote:
> > On Thu, May 08, 2008 at 11:41:25AM +0530, Srivatsa Vaddagiri wrote:
> > > The other combination that I am interested to know is when:
> > > 
> > > CONFIG_FAIR_GROUP_SCHED=y and CONFIG_CGROUP_SCHED=y
> > > 
> > > [i.e cgroup based scheduling rather than uid based scheduling. Former
> > > should result in only one group at bootup]
> > > 
> > > I will also try to get some numbers with this combination.
> > 
> > I ran with that combination and here are some results:
> > 
> > 2.6.25 (with CONFIG_USER_SCHED) 
> > 
> > 	Volanomark perf = 20436.6 (Avg of 10 runs)
> > 
> > 2.6.26-rc1 + patches in Ingo's tree [1] as of Fri morning IST (abt 8 hrs
> > before) (with CONFIG_CGROUP_SCHED)
> > 	
> > 	Volanomark perf = 21529.6
> > 
> > i.e CGROUP based grouping in 2.6.26-rc1 gives same (if not somewhat
> > better) results as UID-based scheduling in 2.6.25.
> > 
> > Yamin,
> > 	Could you validate this as well? i.e just turn on cgroup-based
> > grouping (CONFIG_CGROUP_SCHED) and check the resulting performance with 2625
> > you already have (using CONFIG_USER_SCHED).
> > 
> > 
> > A) In 2.6.25, with UID based scheduling,
> > 	CPU load = summation of task load
> > 
> > B) In 2.6.26-rc1, with UID based scheduling,
> > 	CPU load = summation of group weights
> > 
> > C) In 2.6.26-rc1, with CGROUP based scheduling,
> > 	CPU load = summation of task weights
> I'm confused by these conceptions. Would you like to tell me the exact config options
> you want to turn on?
> 
> Options in my config file(both 2.6.25 and 2.6.26-rc1):
> 
> # CONFIG_CGROUPS is not set
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set
> 

This is fine for 2.6.25. For 2.6.26-rc1, can you turn off USER_SCHED adn
turn on CGROUP_SCHED?

-- 
regards,
Dhaval
