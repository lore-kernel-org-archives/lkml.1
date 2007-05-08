Return-Path: <linux-kernel-owner+w=401wt.eu-S970195AbXEHXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970195AbXEHXel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967967AbXEHXeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:34:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967842AbXEHXe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:34:28 -0400
Date: Tue, 8 May 2007 16:33:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable()
 etc.
Message-Id: <20070508163358.9cc482a8.akpm@linux-foundation.org>
In-Reply-To: <20070508103348.GC1772@ff.dom.local>
References: <20070508103348.GC1772@ff.dom.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 12:33:48 +0200
Jarek Poplawski <jarkao2@o2.pl> wrote:

> 
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> 
> ---
> 
> diff -Nurp 2.6.21-mm1-/kernel/timer.c 2.6.21-mm1/kernel/timer.c
> --- 2.6.21-mm1-/kernel/timer.c	2007-05-08 11:54:48.000000000 +0200
> +++ 2.6.21-mm1/kernel/timer.c	2007-05-08 12:05:11.000000000 +0200
> @@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
>  /* Functions below help us manage 'deferrable' flag */
>  static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
>  {
> -	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
> +	return (unsigned int)((unsigned long)base & TBASE_DEFERRABLE_FLAG);
>  }
>  
>  static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
>  {
> -	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
> +	return (tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG);
>  }
>  
>  static inline void timer_set_deferrable(struct timer_list *timer)
>  {
> -	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
> -	                               TBASE_DEFERRABLE_FLAG));
> +	timer->base = (tvec_base_t *)((unsigned long)timer->base |
> +	                               TBASE_DEFERRABLE_FLAG);
>  }
>  
>  static inline void
>  timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
>  {
> -	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
> +	timer->base = (tvec_base_t *)((unsigned long)new_base |
>  	                              tbase_get_deferrable(timer->base));
>  }
>  

The change makes sense, but does it actually "fix" anything?
