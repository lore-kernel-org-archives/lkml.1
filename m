Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZBZIh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZBZIh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZBZIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:37:13 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59329 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZBZIhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:37:12 -0500
Date: Thu, 26 Feb 2009 14:07:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Message-ID: <20090226083702.GI11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <49A6475F.4000502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49A6475F.4000502@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-02-26 15:40:15]:

> cpuacct_charge() is in fast-path, and checking of !cpuacct_susys.active
> always returns false after cpuacct has been initialized at system boot.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 410eec4..fd2f7fc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9589,7 +9589,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>  	struct cpuacct *ca;
>  	int cpu;
> 
> -	if (!cpuacct_subsys.active)
> +	if (unlikely(!cpuacct_subsys.active))

What happens if most distros make cpuacct_subsys active? Can we decide
on unlikely depending on how the system is configured?


-- 
	Balbir
