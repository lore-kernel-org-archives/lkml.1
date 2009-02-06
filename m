Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZBFC0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZBFC0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZBFC0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:26:08 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41578 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZBFC0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:26:07 -0500
Date: Fri, 6 Feb 2009 07:56:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, lizf@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-ID: <20090206022600.GC13655@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090203172135.GF918@balbir.in.ibm.com> <20090203144647.09bf9c97.akpm@linux-foundation.org> <20090205135554.61488ed6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090205135554.61488ed6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-02-05 13:55:54]:

> On Tue, 3 Feb 2009 14:46:47 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +/**
> > > + * mem_cgroup_print_mem_info: Called from OOM with tasklist_lock held in
> > > + * read mode.
> > > + * @memcg: The memory cgroup that went over limit
> > > + * @p: Task that is going to be killed
> > > + *
> > > + * NOTE: @memcg and @p's mem_cgroup can be different when hierarchy is
> > > + * enabled
> > > + */
> > > +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > > +{
> > > +	struct cgroup *task_cgrp;
> > > +	struct cgroup *mem_cgrp;
> > > +	/*
> > > +	 * Need a buffer on stack, can't rely on allocations. The code relies
> > > +	 * on the assumption that OOM is serialized for memory controller.
> > > +	 * If this assumption is broken, revisit this code.
> > > +	 */
> > > +	static char task_memcg_name[PATH_MAX];
> > > +	static char memcg_name[PATH_MAX];
> > 
> > I don't think we need both of these.  With a bit of shuffling we could
> > reuse the single buffer?
> 
> ping?
>

We can use a single buffer, I'll post a patch to fix it.
 

-- 
	Balbir
