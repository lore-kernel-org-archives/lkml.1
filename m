Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYELBl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYELBl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 21:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYELBlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 21:41:18 -0400
Received: from mga05.intel.com ([192.55.52.89]:22882 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752805AbYELBlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 21:41:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,470,1204531200"; 
   d="scan'208";a="563447732"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: vatsa@linux.vnet.ibm.com
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <20080509155240.GH3612@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
	 <1210223914.3453.102.camel@ymzhang>
	 <20080508054047.GD32729@linux.vnet.ibm.com>
	 <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 09:39:10 +0800
Message-Id: <1210556351.3151.2.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-09 at 21:22 +0530, Srivatsa Vaddagiri wrote:
> On Thu, May 08, 2008 at 11:41:25AM +0530, Srivatsa Vaddagiri wrote:
> > The other combination that I am interested to know is when:
> > 
> > CONFIG_FAIR_GROUP_SCHED=y and CONFIG_CGROUP_SCHED=y
> > 
> > [i.e cgroup based scheduling rather than uid based scheduling. Former
> > should result in only one group at bootup]
> > 
> > I will also try to get some numbers with this combination.
> 
> I ran with that combination and here are some results:
> 
> 2.6.25 (with CONFIG_USER_SCHED) 
> 
> 	Volanomark perf = 20436.6 (Avg of 10 runs)
> 
> 2.6.26-rc1 + patches in Ingo's tree [1] as of Fri morning IST (abt 8 hrs
> before) (with CONFIG_CGROUP_SCHED)
> 	
> 	Volanomark perf = 21529.6
> 
> i.e CGROUP based grouping in 2.6.26-rc1 gives same (if not somewhat
> better) results as UID-based scheduling in 2.6.25.
> 
> Yamin,
> 	Could you validate this as well? i.e just turn on cgroup-based
> grouping (CONFIG_CGROUP_SCHED) and check the resulting performance with 2625
> you already have (using CONFIG_USER_SCHED).
> 
> 
> A) In 2.6.25, with UID based scheduling,
> 	CPU load = summation of task load
> 
> B) In 2.6.26-rc1, with UID based scheduling,
> 	CPU load = summation of group weights
> 
> C) In 2.6.26-rc1, with CGROUP based scheduling,
> 	CPU load = summation of task weights
I'm confused by these conceptions. Would you like to tell me the exact config options
you want to turn on?

Options in my config file(both 2.6.25 and 2.6.26-rc1):

# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set

> 
> 
> This change in definition of cpu load is affecting load balance routines
> (find_busiest_group et al). As a result, threads of volanomark benchmark
> aren't quickly spread across the cpus, resulting in slower performance.
> 
> In case of B), cpu load can be low numbers (100 or 200), while in A or
> C, cpu load are large numbers. I think find_busiest_group() and related 
> routines need to be "educated" to deal with such low numbers ..
> 
> 

