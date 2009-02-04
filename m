Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZBDDiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZBDDiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBDDhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:37:55 -0500
Received: from [202.81.31.146] ([202.81.31.146]:60439 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZBDDhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:37:54 -0500
Date: Wed, 4 Feb 2009 09:07:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-ID: <20090204033750.GB4456@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090203172135.GF918@balbir.in.ibm.com> <4988E727.8030807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4988E727.8030807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-02-04 08:53:59]:

> > @@ -104,6 +104,8 @@ struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
> >  						      struct zone *zone);
> >  struct zone_reclaim_stat*
> >  mem_cgroup_get_reclaim_stat_from_page(struct page *page);
> > +extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
> > +					struct task_struct *p);
> >  
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> >  extern int do_swap_account;
> > @@ -270,6 +272,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
> >  	return NULL;
> >  }
> >  
> > +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > +{
> 
> should be static inline, otherwise it won't compile if CONFIG_CGROUP_MEM_CONT=n
> 

Oh! yes.

> > +}
> > +
> >  #endif /* CONFIG_CGROUP_MEM_CONT */
> >  
> 
> > +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > +{
> > +	struct cgroup *task_cgrp;
> > +	struct cgroup *mem_cgrp;
> > +	/*
> > +	 * Need a buffer on stack, can't rely on allocations. The code relies
> 
> I think it's in .bss section, but not on stack, and it's better to explain why
> the static buffer is safe in the comment.
>

Yes, it is no longer on stack, in the original patch it was. I'll send
an updated patch 

-- 
	Balbir
