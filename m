Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYDDOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYDDOng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYDDOn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:43:26 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:62053 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbYDDOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QXeI+Q22H/sClVneQY4MCxg827wRJgxjo3yyQ8qPRseZ80hQ3EQOTPaVA5uoLHkZI6u+2y7GnjjvqEgK3CcQCa4P029nzg20St2cgZTC0KP69ImVPib0xYqvWAEZH8dJituRYKnHQ5PmRJVb1zAHBaMCowkPrX9wX+i5ZT+bBFc=
Message-ID: <386072610804040743t162cce4ap5ef6ec178374ce0e@mail.gmail.com>
Date: Fri, 4 Apr 2008 07:43:18 -0700
From: "Bryan Wu" <cooloney@kernel.org>
To: hannes@saeurebad.de
Subject: Re: [patch 05/22 -v2] blackfin: Use generic show_mem()
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080404115231.308257293@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
	 <20080404115231.308257293@skyscraper.fehenstaub.lan>
X-Google-Sender-Auth: 992f15598c71cdeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 4:51 AM,  <hannes@saeurebad.de> wrote:
> Remove arch-specific show_mem() in favor of the generic version.
>
>  This also removes the following redundant information display:
>
>         - free pages, printed by show_free_areas()
>         - pages in swapcache, printed by show_swap_cache_info()
>
>  where show_mem() calls show_free_areas(), which calls
>  show_swap_cache_info().
>
>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  CC: Bryan Wu <cooloney@kernel.org>
>  ---
>
>  Index: tree-linus/arch/blackfin/Kconfig
>  ===================================================================
>  --- tree-linus.orig/arch/blackfin/Kconfig
>  +++ tree-linus/arch/blackfin/Kconfig
>  @@ -26,7 +26,6 @@ config BLACKFIN
>         default y
>         select HAVE_IDE
>         select HAVE_OPROFILE
>  -       select HAVE_ARCH_SHOW_MEM
>
>   config ZONE_DMA
>         bool
>  Index: tree-linus/arch/blackfin/mm/init.c
>  ===================================================================
>  --- tree-linus.orig/arch/blackfin/mm/init.c
>  +++ tree-linus/arch/blackfin/mm/init.c
>  @@ -53,33 +53,6 @@ static unsigned long empty_bad_page;
>
>   unsigned long empty_zero_page;
>
>  -void show_mem(void)
>  -{
>  -       unsigned long i;
>  -       int free = 0, total = 0, reserved = 0, shared = 0;
>  -
>  -       int cached = 0;
>  -       printk(KERN_INFO "Mem-info:\n");
>  -       show_free_areas();
>  -       i = max_mapnr;
>  -       while (i-- > 0) {
>  -               total++;
>  -               if (PageReserved(mem_map + i))
>  -                       reserved++;
>  -               else if (PageSwapCache(mem_map + i))
>  -                       cached++;
>  -               else if (!page_count(mem_map + i))
>  -                       free++;
>  -               else
>  -                       shared += page_count(mem_map + i) - 1;
>  -       }
>  -       printk(KERN_INFO "%d pages of RAM\n", total);
>  -       printk(KERN_INFO "%d free pages\n", free);
>  -       printk(KERN_INFO "%d reserved pages\n", reserved);
>  -       printk(KERN_INFO "%d pages shared\n", shared);
>  -       printk(KERN_INFO "%d pages swap cached\n", cached);
>  -}
>  -
>   /*
>   * paging_init() continues the virtual memory environment setup which
>   * was begun by the code in arch/head.S.
>

Thanks
Acked-by: Bryan Wu <cooloney@kernel.org>

-Bryan
