Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXD2IVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXD2IVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXD2ITv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:19:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932812AbXD2ITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:19:49 -0400
Date: Sun, 29 Apr 2007 01:19:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
 spinlock. was: Re: 2.6.21-rc7-mm2
Message-Id: <20070429011909.032a125d.akpm@linux-foundation.org>
In-Reply-To: <20070429065049.GB4446@gollum.tnic>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070426182519.GA4532@gollum.tnic>
	<20070427172230.94b82829.akpm@linux-foundation.org>
	<4633DD55.1020006@shadowen.org>
	<20070429065049.GB4446@gollum.tnic>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 08:50:49 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:

> 
> Introduce a macro for suppressing gcc from generating a warning about a probable
> unitialized state of a variable.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> ---
> 
> Index: linux-mm/include/linux/compiler.h
> ===================================================================
> --- linux-mm.orig/include/linux/compiler.h
> +++ linux-mm/include/linux/compiler.h
> @@ -109,6 +109,10 @@ extern int do_check_likely(struct likeli
>      (typeof(ptr)) (__ptr + (off)); })
>  #endif
>  
> +#ifndef unitialized_var
> +# define unitialized_var(x) x = x
> +#endif
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* __ASSEMBLY__ */
> Index: linux-mm/mm/memory.c
> ===================================================================
> --- linux-mm.orig/mm/memory.c
> +++ linux-mm/mm/memory.c
> @@ -1488,7 +1488,7 @@ static int apply_to_pte_range(struct mm_
>  	pte_t *pte;
>  	int err;
>  	struct page *pmd_page;
> -	spinlock_t *ptl;
> +	spinlock_t *unitialized_var(ptl);
> 
>  	pte = (mm == &init_mm) ?
>  		pte_alloc_kernel(pmd, addr) :

Ho hum.  I guess I'll slide this over to Linus if there's not too much
howling, and unless someone can come up with anything better.

I will, however, fix the spelling to "uninitialized" ;)

