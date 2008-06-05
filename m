Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYFEP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYFEP1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYFEP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:27:41 -0400
Received: from gw.goop.org ([64.81.55.164]:50805 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYFEP1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:27:40 -0400
Message-ID: <484805C4.7030809@goop.org>
Date: Thu, 05 Jun 2008 16:27:00 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 1/1] x86 atomic operations: atomic_or_long atomic_inc_short
References: <E1K3zfZ-0002Bj-8P@eag09.americas.sgi.com>
In-Reply-To: <E1K3zfZ-0002Bj-8P@eag09.americas.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
>
> Provide atomic operations for increment of a 16-bit integer and
> logical OR into a 64-bit integer.
>
> [ This patch was split off of patch:
>     SGI UV: TLB shootdown using broadcast assist unit
>   and improved with advice from Jeremy Fitzhardinge <jeremy@goop.org> ]
>
> Diffed against 2.6.26-rc4
>
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
>   
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>

> ---
>  include/asm-x86/atomic_64.h |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> Index: linux/include/asm-x86/atomic_64.h
> ===================================================================
> --- linux.orig/include/asm-x86/atomic_64.h
> +++ linux/include/asm-x86/atomic_64.h
> @@ -431,6 +431,32 @@ static inline int atomic64_add_unless(at
>  	return c != (u);
>  }
>  
> +/**
> + * atomic_inc_short - increment of a short integer
> + * @v: pointer to type int
> + *
> + * Atomically adds 1 to @v
> + * Returns the new value of @u
> + */
> +static inline short int atomic_inc_short(short int *v)
> +{
> +	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
> +	return *v;
> +}
> +
> +/**
> + * atomic_or_long - OR of two long integers
> + * @v1: pointer to type unsigned long
> + * @v2: pointer to type unsigned long
> + *
> + * Atomically ORs @v1 and @v2
> + * Returns the result of the OR
> + */
> +static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
> +{
> +	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
> +}
> +
>  #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
>  
>  /* These are x86-specific, used by some header files */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

