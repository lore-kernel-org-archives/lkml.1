Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbYHFQUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbYHFQUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYHFQUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:20:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35191 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYHFQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:19:58 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <15853594.1218039196773.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 7 Aug 2008 01:13:16 +0900 (JST)
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] memcg: fix oops in mem_cgroup_shrink_usage
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808061511110.1539@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <Pine.LNX.4.64.0808061511110.1539@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>Date: 	Wed, 6 Aug 2008 15:15:08 +0100 (BST)
>From: Hugh Dickins <hugh@veritas.com>
>To: Andrew Morton <akpm@linux-foundation.org>
>cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
>   Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
>Subject: [PATCH] memcg: fix oops in mem_cgroup_shrink_usage
>
>
>Got an oops in mem_cgroup_shrink_usage() when testing loop over tmpfs:
>yes, of course, loop0 has no mm: other entry points check but this didn't.
>
>Signed-off-by: Hugh Dickins <hugh@veritas.com>

Ahh, thank you!

-Kame

>---
>
> mm/memcontrol.c |    2 ++
> 1 file changed, 2 insertions(+)
>
>--- 2.6.27-rc2/mm/memcontrol.c	2008-08-06 08:36:20.000000000 +0100
>+++ linux/mm/memcontrol.c	2008-08-06 09:05:26.000000000 +0100
>@@ -796,6 +796,8 @@ int mem_cgroup_shrink_usage(struct mm_st
> 
> 	if (mem_cgroup_subsys.disabled)
> 		return 0;
>+	if (!mm)
>+		return 0;
> 
> 	rcu_read_lock();
> 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

