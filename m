Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXJWPf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXJWPf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXJWPfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:35:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:34066 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXJWPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:35:50 -0400
Message-ID: <fa686aa40710230835t5c2a3a37yf70104c7b5042f79@mail.gmail.com>
Date: Tue, 23 Oct 2007 09:35:49 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>,
       linuxppc-dev@ozlabs.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>, paulus@samba.org
Subject: Re: [PATCH] Bugfix to commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15
In-Reply-To: <20071023151929.12090.3835.stgit@trillian.cg.shawcable.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071023151929.12090.3835.stgit@trillian.cg.shawcable.net>
X-Google-Sender-Auth: 0d64900784ab99df
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Grant Likely <grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Fixup for commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15.  Changes to
> dma_map_sg where done in asm-x86/dma-mapping_32.h, but were not mirrored
> in include/asm-powerpc/dma-mapping.h
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
> Linus, I cannot build an arch/powerpc kernel without this patch.

Oops, ignore this patch.  It's doesn't change all the references, it
uses the wrong method for calculating dma_address and 2 other people
have already sent the fix for this.

/me puts on a paper bag
g.

>
> Cheers,
> g.
>
>  include/asm-powerpc/dma-mapping.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
> index 65be95d..fd33ce4 100644
> --- a/include/asm-powerpc/dma-mapping.h
> +++ b/include/asm-powerpc/dma-mapping.h
> @@ -285,9 +285,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
>         BUG_ON(direction == DMA_NONE);
>
>         for_each_sg(sgl, sg, nents, i) {
> -               BUG_ON(!sg->page);
> +               BUG_ON(!sg_page(sg));
>                 __dma_sync_page(sg->page, sg->offset, sg->length, direction);
> -               sg->dma_address = page_to_bus(sg->page) + sg->offset;
> +               sg->dma_address = sg_phys(sg);
>         }
>
>         return nents;
>
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
