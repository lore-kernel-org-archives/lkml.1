Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYCKSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYCKSrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYCKSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:47:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYCKSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:47:31 -0400
Date: Tue, 11 Mar 2008 19:49:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080311184926.GI27593@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307175148.3a49d8d3@mandriva.com.br> <20080308004654.GQ7365@one.firstfloor.org> <20080310150316.752e4489@mandriva.com.br> <20080310180843.GC28780@one.firstfloor.org> <20080311142624.1dbd3af5@mandriva.com.br> <20080311173540.GG27593@one.firstfloor.org> <20080311150048.4376c73a@mandriva.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311150048.4376c73a@mandriva.com.br>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | Oops. Thanks. I'll double check that. mask allocator indeed doesn't
> | handle __GFP_COMP and nobody should be passing that into dma_alloc_coherent
> | anyways. But the bug you got was for the small size wasn't it?
> 
>  No, it triggers the BUG_ON() which checks the gfp, not the one
> which checks MASK_MIN_SIZE.

I see. I misdiagnosed your original problem then. But fixing the 
size < 16 bytes case was a good idea anyways, someone else would
have triggered that.

> 
>  On the other hand I'm not sure whether it does the right thing
> (ie, pass size in bytes instead of order) it does:

> 
> """
> pg = get_order(size);
> [...]
> res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);

With the mask allocator it can be changed to pass size directly
and save some memory. Before that it didn't make any difference.

Can you perhaps send me a complete patch fixing that for sound and the 
__GFP_COMP with description and Signed-off-by etc.? I can add it to my 
patchkit then and you would be correctly attributed. Otherwise I can do it 
myself too if you prefer. I'll also do a grep over the tree for other
such bogus __GFP_COMP users. That was an issue I hadn't considered before.

> if (res != NULL)
> 	inc_snd_pages(pg);
> """
> 
>  Maybe it could be changed to:

Agreed.

-Andi

