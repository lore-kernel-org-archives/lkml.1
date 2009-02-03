Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZBCFgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZBCFgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZBCFf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:35:57 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:40402 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZBCFf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:35:56 -0500
Date: Tue, 3 Feb 2009 11:05:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
Message-ID: <20090203053551.GP918@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202140849.GB918@balbir.in.ibm.com> <49879DE5.8030505@cn.fujitsu.com> <20090203044143.GM918@balbir.in.ibm.com> <alpine.DEB.2.00.0902022045170.27139@chino.kir.corp.google.com> <4987D512.90001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4987D512.90001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-02-03 13:24:34]:

> David Rientjes wrote:
> > On Tue, 3 Feb 2009, Balbir Singh wrote:
> > 
> >>>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> >>>> index d3b9bac..b8e53ae 100644
> >>>> --- a/mm/oom_kill.c
> >>>> +++ b/mm/oom_kill.c
> >>>> @@ -392,6 +392,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >>>>  			current->comm, gfp_mask, order, current->oomkilladj);
> >>>>  		task_lock(current);
> >>>>  		cpuset_print_task_mems_allowed(current);
> >>>> +		mem_cgroup_print_mem_info(mem);
> >>> I think this can be put outside the task lock. The lock is used to call task_cs() safely in
> >>> cpuset_print_task_mems_allowed().
> >>>
> >> Thanks, I'll work on that in the next version.
> >>  
> > 
> > I was also wondering about this and assumed that it was necessary to 
> > prevent the cgroup from disappearing during the oom.  If task_lock() isn't 
> > held, is the memcg->css.cgroup->dentry->d_name.name dereference always 
> > safe without rcu?
> > 
> 
> The cgroup won't disappear, since mem_cgroup_out_of_memory() is called with memcg's css refcnt
> increased. :)
>

And this as well, yes!
 

-- 
	Balbir
