Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYG2DDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYG2DDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYG2DD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:03:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbYG2DD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:03:28 -0400
Date: Tue, 29 Jul 2008 12:00:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] memcg: remove redundant check in move_task()
Message-Id: <20080729120027.0602afe1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <488D2ECB.2070801@cn.fujitsu.com>
References: <488D2ECB.2070801@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 10:28:27 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> It's guaranteed by cgroup that old_cgrp != cgrp.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thank you. 
Hmm.. I like BUG_ON() to show that "this will never happen" rather
than just removing.

Anyway. I ack this.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fba566c..7056c3b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1168,9 +1168,6 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
>  	mem = mem_cgroup_from_cont(cont);
>  	old_mem = mem_cgroup_from_cont(old_cont);
>  
> -	if (mem == old_mem)
> -		goto out;
> -
>  	/*
>  	 * Only thread group leaders are allowed to migrate, the mm_struct is
>  	 * in effect owned by the leader
> -- 
> 1.5.4.rc3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

