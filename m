Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZHBSMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZHBSMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZHBSMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:12:08 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47804 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292AbZHBSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:12:07 -0400
Message-ID: <4A75D702.6010804@vmware.com>
Date: Sun, 02 Aug 2009 20:12:18 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] ttm: Fix a potential comparison of structs.
References: <1249030071-17763-1-git-send-email-thellstrom@vmware.com> <20090802203643.5b638eb6@iki.fi>
In-Reply-To: <20090802203643.5b638eb6@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen skrev:
> From 5e2851952729b287a82efa002b28a2095404d44d Mon Sep 17 00:00:00 2001
> From: Thomas Hellstrom <thellstrom@vmware.com>
> Date: Fri, 31 Jul 2009 10:47:51 +0200
> Subject: [PATCH] ttm: Fix a potential comparison of structs.
>
> On some architectures the comparison may cause a compilation failure.
>
> Original partial fix Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
>
> Thomas, you forgot two more of these :-)
> Here's a patch that actually compiles on x86_64.
>   

Pekka,
Thanks for fixing this! (Just for clarity, i assume you mean that the 
non-x86 part now compiles on x86?)

Dave, is there a chance to have this in 2.6.31? Compilation errors are 
bad, although probably nobody has been hitting this yet..

/Thomas

>  drivers/gpu/drm/ttm/ttm_bo_util.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
> index f4e2eba..999fbe7 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> @@ -151,7 +151,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
>  #ifdef CONFIG_X86
>  	dst = kmap_atomic_prot(d, KM_USER0, prot);
>  #else
> -	if (prot != PAGE_KERNEL)
> +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
>  		dst = vmap(&d, 1, 0, prot);
>  	else
>  		dst = kmap(d);
> @@ -164,7 +164,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
>  #ifdef CONFIG_X86
>  	kunmap_atomic(dst, KM_USER0);
>  #else
> -	if (prot != PAGE_KERNEL)
> +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
>  		vunmap(dst);
>  	else
>  		kunmap(d);
> @@ -187,7 +187,7 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
>  #ifdef CONFIG_X86
>  	src = kmap_atomic_prot(s, KM_USER0, prot);
>  #else
> -	if (prot != PAGE_KERNEL)
> +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
>  		src = vmap(&s, 1, 0, prot);
>  	else
>  		src = kmap(s);
> @@ -200,7 +200,7 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
>  #ifdef CONFIG_X86
>  	kunmap_atomic(src, KM_USER0);
>  #else
> -	if (prot != PAGE_KERNEL)
> +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
>  		vunmap(src);
>  	else
>  		kunmap(s);
>   

