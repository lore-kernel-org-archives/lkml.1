Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0BVR5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:57:37 -0500
Received: from trinity.develer.com ([83.149.158.210]:55237 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0BVR5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:57:36 -0500
Date: Mon, 22 Feb 2010 18:57:29 +0100
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-ID: <20100222175728.GA4052@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-3-git-send-email-arighi@develer.com>
 <20100222093221.eaaff1b4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222093221.eaaff1b4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:32:21AM +0900, KAMEZAWA Hiroyuki wrote:
> > -	if (vm_dirty_bytes)
> > -		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
> > +	dirty_bytes = mem_cgroup_dirty_bytes();
> > +	if (dirty_bytes)
> > +		dirty = DIV_ROUND_UP(dirty_bytes, PAGE_SIZE);
> >  	else {
> >  		int dirty_ratio;
> 
> you use local value. But, if hierarchila accounting used, memcg->dirty_bytes
> should be got from root-of-hierarchy memcg.
> 
> I have no objection if you add a pointer as
> 	memcg->subhierarchy_root
> to get root of hierarchical accounting. But please check problem of hierarchy, again.

Right, it won't work with hierarchy. I'll fix also considering the
hierarchy case.

Thanks for your review.

-Andrea
