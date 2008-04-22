Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYDVDed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYDVDed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYDVDeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:34:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:53088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbYDVDeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:34:24 -0400
Date: Tue, 22 Apr 2008 05:34:23 +0200
From: Nick Piggin <npiggin@suse.de>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix brd allocation flags
Message-ID: <20080422033423.GD21993@wotan.suse.de>
References: <1208466847.8398.4.camel@elijah.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208466847.8398.4.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 11:14:07PM +0200, Petr Tesarik wrote:
> Hello,
> 
> while looking at the implementation of the Ram backed block device
> driver, I stumbled across a write-only local variable, which makes
> little sense, so I assume it should actually work like this:

Right you are. Good catch, thanks Petr.

> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 8536480..7bd7663 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -108,7 +108,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
>  #ifndef CONFIG_BLK_DEV_XIP
>  	gfp_flags |= __GFP_HIGHMEM;
>  #endif
> -	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
> +	page = alloc_page(gfp_flags);
>  	if (!page)
>  		return NULL;
>  
