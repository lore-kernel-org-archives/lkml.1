Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYG3KgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYG3KgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbYG3KgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:36:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759607AbYG3KgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:36:06 -0400
Date: Wed, 30 Jul 2008 03:35:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Message-Id: <20080730033523.0f38f7e4.akpm@linux-foundation.org>
In-Reply-To: <200807301438.55941.rusty@rustcorp.com.au>
References: <200807301438.55941.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 14:38:55 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> After all, it was made for lguest wasn't it?  Still think it should be
> called get_current_pages() though.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/mm/gup.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -r cb465381f6d5 arch/x86/mm/gup.c
> --- a/arch/x86/mm/gup.c	Wed Jul 30 10:18:44 2008 +1000
> +++ b/arch/x86/mm/gup.c	Wed Jul 30 14:22:53 2008 +1000
> @@ -8,6 +8,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmstat.h>
>  #include <linux/highmem.h>
> +#include <linux/module.h>
>  
>  #include <asm/pgtable.h>
>  
> @@ -296,3 +303,4 @@ slow_irqon:
>  		return ret;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(get_user_pages_fast);

A regularly-occurring problem with an export like this is that someone
writes a driver and tests it on x86, then the driver explodes on an
architecture which didn't export the same symbol.

So a better implementation might be to put

#ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
EXPORT_SYMBOL_GPL(get_user_pages_fast);
#endif

into generic code somewhere.
