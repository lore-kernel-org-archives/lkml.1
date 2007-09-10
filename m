Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXIJIXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXIJIXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 04:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbXIJIXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 04:23:36 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50044 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbXIJIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 04:23:35 -0400
Message-ID: <46E4FEF7.1090308@linux.vnet.ibm.com>
Date: Mon, 10 Sep 2007 13:53:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] mm/memcontrol.c: clenups
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202548.GW3563@stusta.de>
In-Reply-To: <20070909202548.GW3563@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>> ...
>> Changes since 2.6.23-rc3-mm1:
>> ...
>> +memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
>> ...
>>  memory containment
>> ...
> 
> This patch makes the following needlessly global functions static:
> - lock_page_container()
> - unlock_page_container()
> - __mem_container_move_lists()
> 
> Additionally, there was no reason for the "mem_control_type" object.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  mm/memcontrol.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> b582cc510b6b0a182dc56025828e7a3c566b9724 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8162d98..49bf04f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -91,7 +91,7 @@ enum {
>  	MEM_CONTAINER_TYPE_CACHED,
>  	MEM_CONTAINER_TYPE_ALL,
>  	MEM_CONTAINER_TYPE_MAX,
> -} mem_control_type;
> +};
> 

Not sure about this, is this the preferred style?

>  static struct mem_container init_mem_container;
> 
> @@ -156,18 +156,18 @@ struct page_container *page_get_page_container(struct page *page)
>  		(page->page_container & ~PAGE_CONTAINER_LOCK);
>  }
> 
> -void __always_inline lock_page_container(struct page *page)
> +static void __always_inline lock_page_container(struct page *page)
>  {
>  	bit_spin_lock(PAGE_CONTAINER_LOCK_BIT, &page->page_container);
>  	VM_BUG_ON(!page_container_locked(page));
>  }
> 
> -void __always_inline unlock_page_container(struct page *page)
> +static void __always_inline unlock_page_container(struct page *page)
>  {
>  	bit_spin_unlock(PAGE_CONTAINER_LOCK_BIT, &page->page_container);
>  }
> 

These look good.

> -void __mem_container_move_lists(struct page_container *pc, bool active)
> +static void __mem_container_move_lists(struct page_container *pc, bool active)
>  {
>  	if (active)
>  		list_move(&pc->lru, &pc->mem_container->active_list);
> 

This looks good as well


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
