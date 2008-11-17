Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYKQAPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYKQAPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 19:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYKQAO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 19:14:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52607 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKQAO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 19:14:56 -0500
Date: Mon, 17 Nov 2008 09:14:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] memcg: handle swap caches build fix
Message-Id: <20081117091413.4a123b7d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0811162046080.5813@blonde.site>
References: <Pine.LNX.4.64.0811162046080.5813@blonde.site>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 20:52:22 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> Fix to build error when CONFIG_SHMEM=y but CONFIG_SWAP is not set:
> mm/shmem.c: In function ‘shmem_unuse_inode’:
> mm/shmem.c:927: error: implicit declaration of function ‘mem_cgroup_cache_charge_swapin’
> 
> Yes, there's a lot of code in mm/shmem.c which only comes into play when
> CONFIG_SWAP=y: better than this quick fix would be to restructure shmem.c
> with all swap stuff in a separate file; that's on my mind, but now is not
> the moment for it.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Thanks! (>_<

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> Fix should follow or be merged into memcg-handle-swap-caches.patch
> 
>  include/linux/swap.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- mmotm/include/linux/swap.h	2008-11-16 17:33:25.000000000 +0000
> +++ linux/include/linux/swap.h	2008-11-16 20:18:27.000000000 +0000
> @@ -442,6 +442,12 @@ static inline swp_entry_t get_swap_page(
>  #define has_swap_token(x) 0
>  #define disable_swap_token() do { } while(0)
>  
> +static inline int mem_cgroup_cache_charge_swapin(struct page *page,
> +			struct mm_struct *mm, gfp_t mask, bool locked)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_SWAP */
>  #endif /* __KERNEL__*/
>  #endif /* _LINUX_SWAP_H */

