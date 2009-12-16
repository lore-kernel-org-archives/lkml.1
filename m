Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZLPIuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZLPIuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZLPIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:49:59 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:3076 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZLPIt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:49:58 -0500
X-Trace: 308091211/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQBAH8uKEtPRRyw/2dsb2JhbAAI1GCEKwSBYg
X-IronPort-AV: E=Sophos;i="4.47,405,1257120000"; 
   d="scan'208";a="308091211"
Date: Wed, 16 Dec 2009 08:49:36 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andi Kleen <andi@firstfloor.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: hwpoison tree build failure
In-Reply-To: <20091216172633.93c361ee.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0912160847270.14564@sister.anvils>
References: <20091216172633.93c361ee.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009, Stephen Rothwell wrote:

> Hi Andi,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> mm/memory-failure.c: In function 'soft_offline_page':
> mm/memory-failure.c:1266: error: too few arguments to function 'migrate_pages'
> 
> Caused by commit c71d409184af558ddac0fd0167061d6282428872 ("HWPOISON: Add
> soft page offline support") from the hwpoison tree interacting with
> commit 62b61f611eb5e20f7e9f8619bfd03bdfe8af6348 ("ksm: memory hotremove
> migration only") from Linus' tree.
> 
> I added the following merge fix for today (I don't know if it is correct)
> and can carry it for a while:

Yes, a 0 there is indeed the right fix: thanks, Stephen.

Hugh

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 16 Dec 2009 17:19:40 +1100
> Subject: [PATCH] hwpoison: fix for migrate_pages API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/memory-failure.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 7f3f627..bcce287 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1263,7 +1263,7 @@ int soft_offline_page(struct page *page, int flags)
>  		LIST_HEAD(pagelist);
>  
>  		list_add(&page->lru, &pagelist);
> -		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL);
> +		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
>  		if (ret) {
>  			pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
>  				pfn, ret, page->flags);
> -- 
> 1.6.5.4
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
