Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYF3CVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYF3CVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYF3CVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:21:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35040 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYF3CVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:21:24 -0400
Date: Mon, 30 Jun 2008 11:27:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: mem_cgroup_shrink_usage css_put
Message-Id: <20080630112704.632d2f6d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0806290114380.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
	<Pine.LNX.4.64.0806290114380.20280@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 01:15:38 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> mem_cgroup_shrink_usage makes no charge: balance its css_get with a css_put.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Sorry for my mistakes

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
> Should follow mmotm's memcg-helper-function-for-relcaim-from-shmem.patch
> 
>  mm/memcontrol.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
> +++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
> @@ -801,6 +801,7 @@ int mem_cgroup_shrink_usage(struct mm_st
>  		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
>  	} while (!progress && --retry);
>  
> +	css_put(&mem->css);
>  	if (!retry)
>  		return -ENOMEM;
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

