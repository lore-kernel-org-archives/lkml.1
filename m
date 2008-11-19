Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYKSMgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYKSMgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYKSMgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:36:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51752 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYKSMgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:36:08 -0500
Message-ID: <56006.10.75.179.61.1227098164.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <200811190744.mAJ7iRVn021314@imap1.linux-foundation.org>
References: <200811190744.mAJ7iRVn021314@imap1.linux-foundation.org>
Date: Wed, 19 Nov 2008 21:36:04 +0900 (JST)
Subject: Re: + memcg-swap-cgroup-for-remembering-usage-fix-4.patch added to 
     -mm tree
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: hugh@veritas.com, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org said:

> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
>
> The current -mm tree may be found at
> http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: memcg: avoid using buggy kmap at swap_cgroup
> From: Hugh Dickins <hugh@veritas.com>
>
> swap_cgroup's kmap logic conflicts shmem's kmap logic.
> avoid to use HIGHMEM for now and revisit this later.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Hugh Dickins <hugh@veritas.com>

Sorry for inconvenience but I'm out of office until Friday.
I met Nishimura and disccussed to post rework patch.
(means unififed patch of original+fix1,2,3,4 + consider about lock again)

Thank you for handling.

Regards,
-Kame

> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/page_cgroup.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff -puN mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-4
> mm/page_cgroup.c
> --- a/mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-4
> +++ a/mm/page_cgroup.c
> @@ -305,7 +305,7 @@ static int swap_cgroup_prepare(int type)
>  	ctrl = &swap_cgroup_ctrl[type];
>
>  	for (idx = 0; idx < ctrl->length; idx++) {
> -		page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
> +		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>  		if (!page)
>  			goto not_enough_page;
>  		ctrl->map[idx] = page;
> @@ -346,11 +346,10 @@ struct mem_cgroup *swap_cgroup_record(sw
>
>  	mappage = ctrl->map[idx];
>  	spin_lock_irqsave(&ctrl->lock, flags);
> -	sc = kmap_atomic(mappage, KM_USER0);
> +	sc = page_address(mappage);
>  	sc += pos;
>  	old = sc->val;
>  	sc->val = mem;
> -	kunmap_atomic((void *)sc, KM_USER0);
>  	spin_unlock_irqrestore(&ctrl->lock, flags);
>  	return old;
>  }
> @@ -381,10 +380,9 @@ struct mem_cgroup *lookup_swap_cgroup(sw
>  	mappage = ctrl->map[idx];
>
>  	spin_lock_irqsave(&ctrl->lock, flags);
> -	sc = kmap_atomic(mappage, KM_USER0);
> +	sc = page_address(mappage);
>  	sc += pos;
>  	ret = sc->val;
> -	kunmap_atomic((void *)sc, KM_USER0);
>  	spin_unlock_irqrestore(&ctrl->lock, flags);
>  	return ret;
>  }
> _
>
> Patches currently in -mm which might be from hugh@veritas.com are
>
> lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop.patch
> sprint_symbol-use-less-stack.patch
> migration-fix-writepage-error.patch
> vmscan-let-gfp_nofs-go-to-swap-again.patch
> dont-unlink-an-active-swapfile.patch
> linux-next.patch
> mm-dont-mark_page_accessed-in-shmem_fault.patch
> mm-apply_to_range-call-pte-function-with-lazy-updates.patch
> memcg-handle-swap-caches.patch
> memcg-handle-swap-caches-build-fix.patch
> memcg-swap-cgroup-for-remembering-usage-fix-2.patch
> memcg-swap-cgroup-for-remembering-usage-fix-3.patch
> memcg-swap-cgroup-for-remembering-usage-fix-4.patch
> memcg-memswap-controller-core.patch
> memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
> prio_tree-debugging-patch.patch
>
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


