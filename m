Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0BWVac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:30:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0BWVaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:30:30 -0500
Date: Tue, 23 Feb 2010 16:29:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-ID: <20100223212943.GF11930@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-3-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266765525-30890-3-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 04:18:45PM +0100, Andrea Righi wrote:

[..]
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0b19943..c9ff1cd 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -137,10 +137,11 @@ static struct prop_descriptor vm_dirties;
>   */
>  static int calc_period_shift(void)
>  {
> -	unsigned long dirty_total;
> +	unsigned long dirty_total, dirty_bytes;
>  
> -	if (vm_dirty_bytes)
> -		dirty_total = vm_dirty_bytes / PAGE_SIZE;
> +	dirty_bytes = mem_cgroup_dirty_bytes();
> +	if (dirty_bytes)
> +		dirty_total = dirty_bytes / PAGE_SIZE;
>  	else
>  		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
>  				100;

Ok, I don't understand this so I better ask. Can you explain a bit how memory
cgroup dirty ratio is going to play with per BDI dirty proportion thing.

Currently we seem to be calculating per BDI proportion (based on recently
completed events), of system wide dirty ratio and decide whether a process
should be throttled or not.

Because throttling decision is also based on BDI and its proportion, how
are we going to fit it with mem cgroup? Is it going to be BDI proportion
of dirty memory with-in memory cgroup (and not system wide)?

Thanks
Vivek
