Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0BUVii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:38:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0BUVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:38:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PUTD2k237rRrOgFUGYKEoWj0FwxvP0i0Q63ExAQlwb87USsdOMLZsiGr+wtOVvEJH
	WFZly9f+H898BUoISno4Q==
Date: Sun, 21 Feb 2010 13:38:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <arighi@develer.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
In-Reply-To: <1266765525-30890-3-git-send-email-arighi@develer.com>
Message-ID: <alpine.DEB.2.00.1002211328530.22858@chino.kir.corp.google.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-3-git-send-email-arighi@develer.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Andrea Righi wrote:

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

This needs a comment since mem_cgroup_dirty_bytes() doesn't imply that it 
is responsible for returning the global vm_dirty_bytes when that's 
actually what it does (both for CONFIG_CGROUP_MEM_RES_CTRL=n and root 
cgroup).
