Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZBCErk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZBCErk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZBCErc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:47:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37404 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZBCErb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:47:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=vE+Eitcvu9tX08crkVkS5zHN5HP1f9fKzC20NwpE/THlFwb7Yr0lTDFYazEU7n9S/
	dI1THcXHYjus19IpUATIQ==
Date: Mon, 2 Feb 2009 20:47:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Li Zefan <lizf@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
In-Reply-To: <20090203044143.GM918@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.0902022045170.27139@chino.kir.corp.google.com>
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202140849.GB918@balbir.in.ibm.com> <49879DE5.8030505@cn.fujitsu.com> <20090203044143.GM918@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.144
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Balbir Singh wrote:

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
> > I think this can be put outside the task lock. The lock is used to call task_cs() safely in
> > cpuset_print_task_mems_allowed().
> >
> 
> Thanks, I'll work on that in the next version.
>  

I was also wondering about this and assumed that it was necessary to 
prevent the cgroup from disappearing during the oom.  If task_lock() isn't 
held, is the memcg->css.cgroup->dentry->d_name.name dereference always 
safe without rcu?
