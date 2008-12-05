Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYLENYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYLENYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbYLENYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:24:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37916 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbYLENYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:24:18 -0500
Message-ID: <56721.10.75.179.61.1228483455.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081205212401.1f446c93.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
    <20081205212401.1f446c93.nishimura@mxp.nes.nec.co.jp>
Date: Fri, 5 Dec 2008 22:24:15 +0900 (JST)
Subject: Re: [RFC][PATCH -mmotm 2/4] memcg: remove mem_cgroup_try_charge
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
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

Daisuke Nishimura said:
> Now, mem_cgroup_try_charge is not used by anyone, so we can remove it.
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Not Now, but after patch [1/4] ;)
Acked-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  include/linux/memcontrol.h |    8 --------
>  mm/memcontrol.c            |   21 +--------------------
>  2 files changed, 1 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fe82b58..4b35739 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -40,8 +40,6 @@ struct mm_struct;
>  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct
> *mm,
>  				gfp_t gfp_mask);
>  /* for swap handling */
> -extern int mem_cgroup_try_charge(struct mm_struct *mm,
> -		gfp_t gfp_mask, struct mem_cgroup **ptr);
>  extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  		struct page *page, gfp_t mask, struct mem_cgroup **ptr);
>  extern void mem_cgroup_commit_charge_swapin(struct page *page,
> @@ -135,12 +133,6 @@ static inline int mem_cgroup_cache_charge(struct page
> *page,
>  	return 0;
>  }
>
> -static inline int mem_cgroup_try_charge(struct mm_struct *mm,
> -			gfp_t gfp_mask, struct mem_cgroup **ptr)
> -{
> -	return 0;
> -}
> -
>  static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 50ee1be..9c5856b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -808,27 +808,8 @@ nomem:
>  	return -ENOMEM;
>  }
>
> -/**
> - * mem_cgroup_try_charge - get charge of PAGE_SIZE.
> - * @mm: an mm_struct which is charged against. (when *memcg is NULL)
> - * @gfp_mask: gfp_mask for reclaim.
> - * @memcg: a pointer to memory cgroup which is charged against.
> - *
> - * charge against memory cgroup pointed by *memcg. if *memcg == NULL,
> estimated
> - * memory cgroup from @mm is got and stored in *memcg.
> - *
> - * Returns 0 if success. -ENOMEM at failure.
> - * This call can invoke OOM-Killer.
> - */
> -
> -int mem_cgroup_try_charge(struct mm_struct *mm,
> -			  gfp_t mask, struct mem_cgroup **memcg)
> -{
> -	return __mem_cgroup_try_charge(mm, mask, memcg, true);
> -}
> -
>  /*
> - * commit a charge got by mem_cgroup_try_charge() and makes page_cgroup
> to be
> + * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup
> to be
>   * USED state. If already USED, uncharge and return.
>   */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


