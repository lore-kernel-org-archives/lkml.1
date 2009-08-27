Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZH0MVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZH0MVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZH0MVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:21:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:24211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZH0MVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:21:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="180965755"
Date: Thu, 27 Aug 2009 20:21:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
       Zhu Yanhai <yanhai.zhu@linux.intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Make radix_tree_preload alloc one more slot
Message-ID: <20090827122144.GA20443@localhost>
References: <4A9677C1.3090804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9677C1.3090804@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Yanhai,

[Nick CCed]

On Thu, Aug 27, 2009 at 08:10:41PM +0800, Zhu Yanhai wrote:
> The operations against radix tree always use paths with RADIX_TREE_MAX_PATH
> + 1 slots, but radix_tree_preload only pre-allocs RADIX_TREE_MAX_PATH
> slots at present, which causes radix_tree_node_alloc tries to do
> kmem_cache_alloc at the last slot even if we don't have gfp_mask &
> __GFP_WAIT in hand.
 
Are you sure?  The comments read:

        /*
         * The radix tree path needs to be one longer than the maximum path
         * since the "list" is null terminated.
         */
        struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;

Thanks,
Fengguang


> Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>
> 
> ---
>  lib/radix-tree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 23abbd9..72225a8 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -79,7 +79,7 @@ static struct kmem_cache *radix_tree_node_cachep;
>   */
>  struct radix_tree_preload {
>  	int nr;
> -	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
> +	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH + 1];
>  };
>  static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
>  
> -- 
> 1.6.2.2
