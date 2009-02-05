Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZBEV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZBEV4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZBEV40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:56:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbZBEV4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:56:25 -0500
Date: Thu, 5 Feb 2009 13:55:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-Id: <20090205135554.61488ed6.akpm@linux-foundation.org>
In-Reply-To: <20090203144647.09bf9c97.akpm@linux-foundation.org>
References: <20090203172135.GF918@balbir.in.ibm.com>
	<20090203144647.09bf9c97.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 14:46:47 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +/**
> > + * mem_cgroup_print_mem_info: Called from OOM with tasklist_lock held in
> > + * read mode.
> > + * @memcg: The memory cgroup that went over limit
> > + * @p: Task that is going to be killed
> > + *
> > + * NOTE: @memcg and @p's mem_cgroup can be different when hierarchy is
> > + * enabled
> > + */
> > +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > +{
> > +	struct cgroup *task_cgrp;
> > +	struct cgroup *mem_cgrp;
> > +	/*
> > +	 * Need a buffer on stack, can't rely on allocations. The code relies
> > +	 * on the assumption that OOM is serialized for memory controller.
> > +	 * If this assumption is broken, revisit this code.
> > +	 */
> > +	static char task_memcg_name[PATH_MAX];
> > +	static char memcg_name[PATH_MAX];
> 
> I don't think we need both of these.  With a bit of shuffling we could
> reuse the single buffer?

ping?
