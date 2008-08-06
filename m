Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbYHFQWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbYHFQWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbYHFQV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:21:58 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41970 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYHFQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:21:57 -0400
Message-ID: <4899CFA1.60807@linux.vnet.ibm.com>
Date: Wed, 06 Aug 2008 21:51:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix oops in mem_cgroup_shrink_usage
References: <Pine.LNX.4.64.0808061511110.1539@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808061511110.1539@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Got an oops in mem_cgroup_shrink_usage() when testing loop over tmpfs:
> yes, of course, loop0 has no mm: other entry points check but this didn't.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  mm/memcontrol.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- 2.6.27-rc2/mm/memcontrol.c	2008-08-06 08:36:20.000000000 +0100
> +++ linux/mm/memcontrol.c	2008-08-06 09:05:26.000000000 +0100
> @@ -796,6 +796,8 @@ int mem_cgroup_shrink_usage(struct mm_st
> 
>  	if (mem_cgroup_subsys.disabled)
>  		return 0;
> +	if (!mm)
> +		return 0;
> 
>  	rcu_read_lock();
>  	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));

Looks good

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
