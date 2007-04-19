Return-Path: <linux-kernel-owner+w=401wt.eu-S2993041AbXDSA24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993041AbXDSA24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993043AbXDSA24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:28:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54376 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993041AbXDSA2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:28:55 -0400
Date: Thu, 19 Apr 2007 09:29:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: akpm@linux-foundation.org, clameter@engr.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix OOM killing processes wrongly thought MPOL_BIND
Message-Id: <20070419092903.a286be3a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 20:35:22 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> I only have CONFIG_NUMA=y for build testing: surprised when trying a memhog
> to see lots of other processes killed with "No available memory (MPOL_BIND)".
> memhog is killed correctly once we initialize nodemask in constrained_alloc().
> 

thank you for catching bug.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Perhaps appropriate for 2.6.20-stable too - regression since 2.6.19.
> 
>  mm/oom_kill.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- 2.6.21-rc7/mm/oom_kill.c	2007-03-26 07:30:54.000000000 +0100
> +++ linux/mm/oom_kill.c	2007-04-18 20:18:21.000000000 +0100
> @@ -176,6 +176,8 @@ static inline int constrained_alloc(stru
>  	struct zone **z;
>  	nodemask_t nodes;
>  	int node;
> +
> +	nodes_clear(nodes);
>  	/* node has memory ? */
>  	for_each_online_node(node)
>  		if (NODE_DATA(node)->node_present_pages)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

