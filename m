Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0BVSAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:00:21 -0500
Received: from trinity.develer.com ([83.149.158.210]:55332 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0BVSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:00:19 -0500
Date: Mon, 22 Feb 2010 19:00:14 +0100
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100222180013.GB4052@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-2-git-send-email-arighi@develer.com>
 <20100222092242.98df82e4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222092242.98df82e4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:22:42AM +0900, KAMEZAWA Hiroyuki wrote:

[snip]

> > +static unsigned long get_dirty_bytes(struct mem_cgroup *memcg)
> > +{
> > +	struct cgroup *cgrp = memcg->css.cgroup;
> > +	unsigned long dirty_bytes;
> > +
> > +	/* root ? */
> > +	if (cgrp->parent == NULL)
> > +		return vm_dirty_bytes;
> 
> We have mem_cgroup_is_root() macro.
> 
> > +
> > +	spin_lock(&memcg->reclaim_param_lock);
> > +	dirty_bytes = memcg->dirty_bytes;
> > +	spin_unlock(&memcg->reclaim_param_lock);
> > +
> > +	return dirty_bytes;
> > +}
> Hmm...do we need spinlock ? You use "unsigned long", then, read-write
> is always atomic if not read-modify-write.

I think I simply copy&paste the memcg->swappiness case. But I agree,
read-write should be atomic.

-Andrea
