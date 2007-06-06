Return-Path: <linux-kernel-owner+w=401wt.eu-S934233AbXFFAGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbXFFAGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764804AbXFFAGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:06:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764245AbXFFAGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:06:09 -0400
Date: Tue, 5 Jun 2007 17:06:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib:  Replace calls to __get_free_pages() with
 __get_dma_pages().
Message-Id: <20070605170601.67bc2939.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain>
References: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 16:58:57 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> Replace a couple calls to __get_free_pages() with the corresponding
> calls to __get_dma_pages().
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   that's the lot of them.
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 10c13ad..8fc38dc 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -201,8 +201,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
>  	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> 
>  	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> -		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> -		                                        order);
> +		io_tlb_start = (char *)__get_dma_pages(__GFP_NOWARN, order);

__get_dma_pages() is just pointless obfuscation.  I think it'd be better to
go the other way: open-code the GFP_DMA at all callsites then send
__get_dma_pages() bitbucketwards.

