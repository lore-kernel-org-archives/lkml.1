Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZBZKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZBZKk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZBZKkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:40:18 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:47943 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZBZKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:40:17 -0500
Date: Thu, 26 Feb 2009 16:10:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Message-ID: <20090226104008.GJ11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <49A6475F.4000502@cn.fujitsu.com> <20090226083702.GI11421@balbir.in.ibm.com> <49A655B0.9020002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49A655B0.9020002@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-02-26 16:41:20]:

> Balbir Singh wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> [2009-02-26 15:40:15]:
> > 
> >> cpuacct_charge() is in fast-path, and checking of !cpuacct_susys.active
> >> always returns false after cpuacct has been initialized at system boot.
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> >> ---
> >>  kernel/sched.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/kernel/sched.c b/kernel/sched.c
> >> index 410eec4..fd2f7fc 100644
> >> --- a/kernel/sched.c
> >> +++ b/kernel/sched.c
> >> @@ -9589,7 +9589,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
> >>  	struct cpuacct *ca;
> >>  	int cpu;
> >>
> >> -	if (!cpuacct_subsys.active)
> >> +	if (unlikely(!cpuacct_subsys.active))
> > 
> > What happens if most distros make cpuacct_subsys active? Can we decide
> > on unlikely depending on how the system is configured?
> > 
> 
> Note, it's ->active but not ->disabled. ;)
>

I've seen that
 
> And note, I make it "unlikely(!cpuacct_subsys.active)", but not "unlikely(cpuacct_subsys.active)"
>
> ->active can't be configured by users. If CONFIG_CGROUP_CPUACCT is enabled,
> cpuacct_subsys.active will be set to true after cpuacct is initialized.
>

My point is the likely/unlikely in this case depends on turning on/off
CONFIG_CGROUP_CPUACCT? Am I missing something?


-- 
	Balbir
