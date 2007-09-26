Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbXIZM3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbXIZM3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 08:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXIZM3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 08:29:07 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4444 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbXIZM3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 08:29:06 -0400
Date: Wed, 26 Sep 2007 13:28:56 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Badari Pulavarty <pbadari@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc8-mm1
Message-ID: <20070926122856.GA10088@shadowen.org>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <1190757954.13955.44.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190757954.13955.44.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 03:05:53PM -0700, Badari Pulavarty wrote:
> Hi Andy,
> 
> One the patch you created in -mm is causing compile warning.
> Here is the fix. Please verify.
> 
> Thanks,
> Badari
> 
> arch/powerpc/mm/init_64.c: In function `vmemmap_populated':
> arch/powerpc/mm/init_64.c:211: warning: passing arg 1 of `vmemmap_section_start' makes pointer from integer without a cast
> 
> vmemmap_section_start() gets called with an argument which is unsigned long.
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

Clearly correct.  

Acked-by: Andy Whitcroft <apw@shadowen.org>

> Index: linux-2.6.23-rc8/arch/powerpc/mm/init_64.c
> ===================================================================
> --- linux-2.6.23-rc8.orig/arch/powerpc/mm/init_64.c	2007-09-25 09:18:13.000000000 -0700
> +++ linux-2.6.23-rc8/arch/powerpc/mm/init_64.c	2007-09-25 14:50:44.000000000 -0700
> @@ -189,10 +189,9 @@ void pgtable_cache_init(void)
>   * do this by hand as the proffered address may not be correctly aligned.
>   * Subtraction of non-aligned pointers produces undefined results.
>   */
> -unsigned long __meminit vmemmap_section_start(struct page *page)
> +unsigned long __meminit vmemmap_section_start(unsigned long page)
>  {
> -	unsigned long offset = ((unsigned long)page) -
> -						((unsigned long)(vmemmap));
> +	unsigned long offset = page - ((unsigned long)(vmemmap));
>  
>  	/* Return the pfn of the start of the section. */
>  	return (offset / sizeof(struct page)) & PAGE_SECTION_MASK;

-apw
