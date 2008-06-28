Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbYF1RzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbYF1RzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYF1RzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:55:03 -0400
Received: from colo.lackof.org ([198.49.126.79]:43184 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYF1RzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:55:01 -0400
Date: Sat, 28 Jun 2008 11:54:49 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Julia Lawall <julia@diku.dk>
Cc: akinobu.mita@gmail.com, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/14] arch/parisc: Eliminate NULL test and memset after
	alloc_bootmem
Message-ID: <20080628175449.GB12265@colo.lackof.org>
References: <Pine.LNX.4.64.0806241023080.26777@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806241023080.26777@ask.diku.dk>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 10:23:28AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
> alloc_bootmem and related functions never return NULL and always return a
> zeroed region of memory.  Thus a NULL test or memset after calls to these
> functions is unnecessary.
> 
>  arch/parisc/mm/init.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> This was fixed using the following semantic patch.
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression E;
> statement S;
> @@
> 
> E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
> ... when != E
> (
> - BUG_ON (E == NULL);
> |
> - if (E == NULL) S
> )
> 
> @@
> expression E,E1;
> @@
> 
> E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
> ... when != E
> - memset(E,0,E1);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
> 
> diff -u -p a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -765,7 +765,6 @@ static void __init pagetable_init(void)
>  #endif
>  
>  	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
> -	memset(empty_zero_page, 0, PAGE_SIZE);
>  }
>  
>  static void __init gateway_init(void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
