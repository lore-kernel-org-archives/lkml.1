Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbZE1IvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbZE1IvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZE1IvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:51:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45359 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbZE1IvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:51:15 -0400
Date: Thu, 28 May 2009 17:49:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RESEND] [PATCH] memcg: Fix build warning and avoid checking
 for mem != null again and again
Message-Id: <20090528174943.d4447480.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200905281420.44338.knikanth@suse.de>
References: <200905281420.44338.knikanth@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 14:20:43 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> 
> Resending the patch to Andrew for inclusion in -mm tree.
> 
> Thanks
> Nikanth
> 
> Fix build warning, "mem_cgroup_is_obsolete defined but not used" when
> CONFIG_DEBUG_VM is not set. Also avoid checking for !mem again and again.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 01c2d8f..d253846 100644
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
> @@ -932,7 +924,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	if (unlikely(!mem))
>  		return 0;
>  
> -	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
> +	VM_BUG_ON(css_is_removed(&mem->css));
>  
>  	while (1) {
>  		int ret;
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

