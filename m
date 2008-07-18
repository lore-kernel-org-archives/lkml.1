Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbYGROse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbYGROse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYGROs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:48:26 -0400
Received: from gw.goop.org ([64.81.55.164]:48109 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbYGROs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:48:26 -0400
Message-ID: <4880AD2D.3050407@goop.org>
Date: Fri, 18 Jul 2008 07:48:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: reduce boot fixmap space
References: <4880A8AC.76E4.0078.0@novell.com>
In-Reply-To: <4880A8AC.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> As 256 entries are needed, aligning to a 256-entry boundary is
> sufficient and still guarantees the single pte table requirement.
>   

I unified 32 and 64-bit early_ioremap by making 64-bit use the 32-bit 
early_ioremap.  In the process I put a similar entry in fixmap_64.h.  
Would you mind looking to see if the same change is relevant there?

Thanks,
    J

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  include/asm-x86/fixmap_32.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- linux-2.6.26/include/asm-x86/fixmap_32.h	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-i386-btmap-fixmaps/include/asm-x86/fixmap_32.h	2008-07-18 13:51:16.000000000 +0200
> @@ -94,13 +94,13 @@ enum fixed_addresses {
>  	 * 256 temporary boot-time mappings, used by early_ioremap(),
>  	 * before ioremap() is functional.
>  	 *
> -	 * We round it up to the next 512 pages boundary so that we
> +	 * We round it up to the next 256 pages boundary so that we
>  	 * can have a single pgd entry and a single pte table:
>  	 */
>  #define NR_FIX_BTMAPS		64
>  #define FIX_BTMAPS_NESTING	4
> -	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
> -			(__end_of_permanent_fixed_addresses & 511),
> +	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
> +			(__end_of_permanent_fixed_addresses & 255),
>  	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
>  	FIX_WP_TEST,
>  #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

