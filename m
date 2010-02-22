Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0BVTdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0BVTdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:33:52 -0500
Date: Mon, 22 Feb 2010 14:31:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
	infrastructure
Message-ID: <20100222193113.GE3096@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-2-git-send-email-arighi@develer.com> <20100222092242.98df82e4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222092242.98df82e4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:22:42AM +0900, KAMEZAWA Hiroyuki wrote:

[..]
> > +static int mem_cgroup_dirty_bytes_write(struct cgroup *cgrp, struct cftype *cft,
> > +				       u64 val)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> > +	struct mem_cgroup *parent;
> > +
> > +	if (cgrp->parent == NULL)
> > +		return -EINVAL;
> > +
> > +	parent = mem_cgroup_from_cont(cgrp->parent);
> > +
> > +	cgroup_lock();
> > +
> > +	/* If under hierarchy, only empty-root can set this value */
> > +	if ((parent->use_hierarchy) ||
> > +	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
> > +		cgroup_unlock();
> > +		return -EINVAL;
> > +	}
> 
> Okay, then, only hierarchy root can set the value.
> Please descirbe this kind of important things in patch description.
> 

Hi Andrea,

Why can only root of the hierarchy set set dirty_bytes value? In this
case, a child cgroup's amount of dirty pages will be controlled by
dirty_ratio?

Thanks
Vivek
