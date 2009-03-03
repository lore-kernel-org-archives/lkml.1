Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZCCOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZCCOoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZCCOoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:44:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:52719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZCCOoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:44:09 -0500
Date: Tue, 3 Mar 2009 15:44:04 +0100
From: Nick Piggin <npiggin@suse.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] slqb: use correct name for rcu callback
Message-ID: <20090303144404.GB18142@wotan.suse.de>
References: <49AD3033.4090608@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD3033.4090608@cn.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.
Acked-by: Nick Piggin <npiggin@suse.de>

On Tue, Mar 03, 2009 at 09:27:15PM +0800, Lai Jiangshan wrote:
> 
> struct slqb_page defines struct rcu_head rcu_head for rcu,
> the rcu callback should use it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/mm/slqb.c b/mm/slqb.c
> index 07bf5b3..48bdf3b 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -1026,7 +1043,7 @@ static void rcu_free_slab(struct rcu_head *h)
>  {
>  	struct slqb_page *page;
>  
> -	page = container_of((struct list_head *)h, struct slqb_page, lru);
> +	page = container_of(h, struct slqb_page, rcu_head);
>  	__free_slab(page->list->cache, page);
>  }
>  
> 
