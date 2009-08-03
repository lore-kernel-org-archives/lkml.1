Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZHCRXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZHCRXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZHCRXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:23:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZHCRXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:23:08 -0400
Date: Mon, 3 Aug 2009 19:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drop superfluous casts in nr_free_pages() callers
Message-ID: <20090803172256.GA26766@elte.hu>
References: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Commit 96177299416dbccb73b54e6b344260154a445375 ("Drop free_pages()")
> modified nr_free_pages() to return 'unsigned long' instead of 'unsigned int'.
> This made the casts to 'unsigned long' in most callers superfluous, hence
> remove them.

> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 3cd7711..95e877f 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -892,7 +892,7 @@ void __init mem_init(void)
>  
>  	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
>  			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
> -		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
> +		nr_free_pages() << (PAGE_SHIFT-10),
>  		num_physpages << (PAGE_SHIFT-10),
>  		codesize >> 10,
>  		reservedpages << (PAGE_SHIFT-10),
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 6176fe8..44f82a6 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -687,7 +687,7 @@ void __init mem_init(void)
>  
>  	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
>  			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
> -		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
> +		nr_free_pages() << (PAGE_SHIFT-10),
>  		max_pfn << (PAGE_SHIFT-10),
>  		codesize >> 10,
>  		absent_pages << (PAGE_SHIFT-10),

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks Geert,

	Ingo
