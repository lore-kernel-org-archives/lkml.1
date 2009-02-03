Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbZBCFZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbZBCFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZBCFZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:25:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZBCFZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:25:13 -0500
Message-ID: <4987D512.90001@cn.fujitsu.com>
Date: Tue, 03 Feb 2009 13:24:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202140849.GB918@balbir.in.ibm.com> <49879DE5.8030505@cn.fujitsu.com> <20090203044143.GM918@balbir.in.ibm.com> <alpine.DEB.2.00.0902022045170.27139@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0902022045170.27139@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 3 Feb 2009, Balbir Singh wrote:
> 
>>>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>>>> index d3b9bac..b8e53ae 100644
>>>> --- a/mm/oom_kill.c
>>>> +++ b/mm/oom_kill.c
>>>> @@ -392,6 +392,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>>>>  			current->comm, gfp_mask, order, current->oomkilladj);
>>>>  		task_lock(current);
>>>>  		cpuset_print_task_mems_allowed(current);
>>>> +		mem_cgroup_print_mem_info(mem);
>>> I think this can be put outside the task lock. The lock is used to call task_cs() safely in
>>> cpuset_print_task_mems_allowed().
>>>
>> Thanks, I'll work on that in the next version.
>>  
> 
> I was also wondering about this and assumed that it was necessary to 
> prevent the cgroup from disappearing during the oom.  If task_lock() isn't 
> held, is the memcg->css.cgroup->dentry->d_name.name dereference always 
> safe without rcu?
> 

The cgroup won't disappear, since mem_cgroup_out_of_memory() is called with memcg's css refcnt
increased. :)


