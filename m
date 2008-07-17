Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYGQLig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYGQLig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYGQLi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:38:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55784 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751114AbYGQLi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:38:27 -0400
Date: Thu, 17 Jul 2008 06:38:26 -0500
From: Robin Holt <holt@sgi.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: cl@linux-foundation.org, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: SLUB: simplify re on_each_cpu()
Message-ID: <20080717113826.GG8534@sgi.com>
References: <20080716172902.GA5176@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716172902.GA5176@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 09:29:02PM +0400, Alexey Dobriyan wrote:
> on_each_cpu() expands to function call on UP, too.

It looks to me like on_each_cpu is a #define for !SMP.  Are you certain
of the need for this change?  Are you looking at a different tree than
Linus'?

Thanks,
Robin

> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  mm/slub.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1495,15 +1495,7 @@ static void flush_cpu_slab(void *d)
>  
>  static void flush_all(struct kmem_cache *s)
>  {
> -#ifdef CONFIG_SMP
>  	on_each_cpu(flush_cpu_slab, s, 1);
> -#else
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	flush_cpu_slab(s);
> -	local_irq_restore(flags);
> -#endif
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
