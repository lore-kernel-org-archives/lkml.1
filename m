Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbZD3JrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbZD3JrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZD3JrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:47:13 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38058 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZD3JrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:47:12 -0400
Message-ID: <49F973A0.8070106@in.ibm.com>
Date: Thu, 30 Apr 2009 15:17:12 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de> <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com> <20090430064127.GF23746@wotan.suse.de>
In-Reply-To: <20090430064127.GF23746@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hmm, forget that. Actually my last patch had a silly mistake because I
> forgot MAX_ORDER shift is applied to PAGE_SIZE, rather than 1. So
> kmalloc(PAGE_SIZE) was failing as too large.
>
> This patch should do the trick I hope.
>   
Yes this patch fixed the issue for me. Thanks Nick.

Regards
-Sachin
> Thanks,
> Nick
> ---
>  include/linux/slqb_def.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/include/linux/slqb_def.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slqb_def.h
> +++ linux-2.6/include/linux/slqb_def.h
> @@ -172,7 +172,8 @@ struct kmem_cache {
>  #endif
>
>  #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
> -#define KMALLOC_SHIFT_SLQB_HIGH (PAGE_SHIFT + 9)
> +#define KMALLOC_SHIFT_SLQB_HIGH (PAGE_SHIFT + 			\
> +				 ((9 <= (MAX_ORDER - 1)) ? 9 : (MAX_ORDER - 1)))
>
>  extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_SLQB_HIGH + 1];
>  extern struct kmem_cache kmalloc_caches_dma[KMALLOC_SHIFT_SLQB_HIGH + 1];
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

