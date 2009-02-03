Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZBCEl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZBCEl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZBCElt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:41:49 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:59232 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZBCEls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:41:48 -0500
Date: Tue, 3 Feb 2009 10:11:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
Message-ID: <20090203044143.GM918@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202140849.GB918@balbir.in.ibm.com> <49879DE5.8030505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49879DE5.8030505@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-02-03 09:29:09]:

> > +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg)
> > +{
> > +	printk(KERN_WARNING "Memory cgroups's name %s\n",
> > +		memcg->css.cgroup->dentry->d_name.name);
> > +	printk(KERN_WARNING "Memory cgroup RSS : usage %llu, limit %llu"
> > +		" failcnt %llu\n", res_counter_read_u64(&memcg->res, RES_USAGE),
> 
> ", failcnt %llu\n" ?
> 
> > +		res_counter_read_u64(&memcg->res, RES_LIMIT),
> > +		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> > +	printk(KERN_WARNING "Memory cgroup swap: usage %llu, limit %llu "
> > +		"failcnt %llu\n",
> 
> ", failcnt %llu\n" ?
> 
> > +		res_counter_read_u64(&memcg->memsw, RES_USAGE),
> > +		res_counter_read_u64(&memcg->memsw, RES_LIMIT),
> > +		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> > +}
> > +
> >  /*
> >   * Unlike exported interface, "oom" parameter is added. if oom==true,
> >   * oom-killer can be invoked.
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index d3b9bac..b8e53ae 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -392,6 +392,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  			current->comm, gfp_mask, order, current->oomkilladj);
> >  		task_lock(current);
> >  		cpuset_print_task_mems_allowed(current);
> > +		mem_cgroup_print_mem_info(mem);
> 
> I think this can be put outside the task lock. The lock is used to call task_cs() safely in
> cpuset_print_task_mems_allowed().
>

Thanks, I'll work on that in the next version.
 
> >  		task_unlock(current);
> >  		dump_stack();
> >  		show_mem();
> > 
> 

-- 
	Balbir
