Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZEABEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZEABEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZEABEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:04:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304AbZEABEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:04:46 -0400
Date: Thu, 30 Apr 2009 17:59:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Karsten Mehrhoff <kawime@gmx.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Shaohua Li <shaohua.li@intel.com>, Dave Airlie <airlied@linux.ie>,
       stable@kernel.org
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
Message-Id: <20090430175927.a89f1cd3.akpm@linux-foundation.org>
In-Reply-To: <op.us6ywl2jgp7xae@127.0.0.1>
References: <op.us6ywl2jgp7xae@127.0.0.1>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 10:51:47 +0200
Karsten Mehrhoff <kawime@gmx.de> wrote:

> [1.]
> PROBLEM: No more agp card functionality with the patch 2.6.29.2 of 'a/drivers/char/agp/generic.c'
> 
> [2.]
> I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run into problems with the speed of my ATI RADEON 9600 (rv350)
> 

So we have a 2.6.29.1 -> 2.6.29.2 regression.

> ...
> 
> Problematic patch:
> //---
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -1226,7 +1226,7 @@ int agp_generic_alloc_pages(struct agp_bridge_data *bridge, struct agp_memory *m
>          int i, ret = -ENOMEM;
>  
>          for (i = 0; i < num_pages; i++) {
> -                page = alloc_page(GFP_KERNEL | GFP_DMA32);
> +                page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
>                  /* agp_free_memory() needs gart address */
>                  if (page == NULL)
>                          goto out;
> @@ -1257,7 +1257,7 @@ void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
>  {
>          struct page * page;
>  
> -        page = alloc_page(GFP_KERNEL | GFP_DMA32);
> +        page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
>          if (page == NULL)
>                  return NULL;
> ---//
> 
> I reverted the patch back to 2.6.29.1, compiled and the kernel agian and agp works ok.

Really?  So reverting 

: commit 59de2bebabc5027f93df999d59cc65df591c3e6e
: Author:     Shaohua Li <shaohua.li@intel.com>
: AuthorDate: Mon Apr 20 10:08:35 2009 +1000
: Commit:     Dave Airlie <airlied@redhat.com>
: CommitDate: Mon Apr 20 10:08:35 2009 +1000
:
:    agp: zero pages before sending to userspace

makes your AGP work properly?

That's really weird.
