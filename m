Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZDPAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZDPAtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZDPAtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:49:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45419 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZDPAtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:49:10 -0400
Date: Thu, 16 Apr 2009 09:47:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg remove warning at DEBUG_VM=off
Message-Id: <20090416094738.2904c799.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090415101317.GA3240@linux>
References: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408052715.GX7082@balbir.in.ibm.com>
	<20090409222512.bd026a40.akpm@linux-foundation.org>
	<20090410153335.b52c5f74.kamezawa.hiroyu@jp.fujitsu.com>
	<20090415101317.GA3240@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 12:13:17 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> The warning is still there actually. I've just written a fix and seen
> this discussion, maybe I can offload a little bit Kame. ;)
> 
> -Andrea

Thank you.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> memcg: remove warning when CONFIG_DEBUG_VM is not set
> 
> Fix the following warning removing mem_cgroup_is_obsolete():
> 
>   mm/memcontrol.c:318: warning: ‘mem_cgroup_is_obsolete’ defined but not used
> 
> Moreover, split the VM_BUG_ON() checks in two parts to be aware of which
> one triggered the bug.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  mm/memcontrol.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e44fb0f..8cd6358 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -314,14 +314,6 @@ static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
>  	return mem;
>  }
>  
> -static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
> -{
> -	if (!mem)
> -		return true;
> -	return css_is_removed(&mem->css);
> -}
> -
> -
>  /*
>   * Call callback function against all cgroup under hierarchy tree.
>   */
> @@ -932,7 +924,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	if (unlikely(!mem))
>  		return 0;
>  
> -	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
> +	VM_BUG_ON(!mem);
> +	VM_BUG_ON(css_is_removed(&mem->css));
>  
>  	while (1) {
>  		int ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

