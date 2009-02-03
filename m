Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZBCGBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZBCGBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 01:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZBCGBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 01:01:22 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45683 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZBCGBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 01:01:22 -0500
Date: Tue, 3 Feb 2009 14:55:04 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [-mm patch] Show memcg information during OOM
Message-Id: <20090203145504.0ffef746.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090203124436.bc0120ca.nishimura@mxp.nes.nec.co.jp>
References: <20090202125240.GA918@balbir.in.ibm.com>
	<20090202134505.GA4848@cmpxchg.org>
	<20090203124436.bc0120ca.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > index d3b9bac..b8e53ae 100644
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -392,6 +392,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> > >  			current->comm, gfp_mask, order, current->oomkilladj);
> > >  		task_lock(current);
> > >  		cpuset_print_task_mems_allowed(current);
> > > +		mem_cgroup_print_mem_info(mem);
> > 
> > mem is only !NULL when we come from mem_cgroup_out_of_memory().  This
> > crashes otherwise in mem_cgroup_print_mem_info(), no?
> > 
> I think you're right.
> 
> IMHO, "mem_cgroup_print_mem_info(current)" would be better here,
> and call mem_cgroup_from_task at mem_cgroup_print_mem_info.
> 
Reading other messages on this thread, mem_cgroup_print_mem_info
should be called only when oom_kill_process is called from mem_cgroup_out_of_memory,
so checking "if (!mem)" would be enough.


Thanks,
Daisuke Nishimura.
