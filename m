Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYAWMUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYAWMUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYAWMU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:20:29 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53974 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbYAWMU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:20:29 -0500
Date: Wed, 23 Jan 2008 13:20:10 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] fix variable use in AVR32 pte_alloc_one
Message-ID: <20080123132010.266eccb8@dhcp-252-066.norway.atmel.com>
In-Reply-To: <47972BAE.70902@niasdigital.com>
References: <47972BAE.70902@niasdigital.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 22:57:34 +1100
Ben Nizette <bn@niasdigital.com> wrote:

> 
> Some parts of this function use 'page', some 'pte'.  As such, an AVR32
> -mm build fails with an undefined reference to 'page'.
> 
> Signed-Off-By: Ben Nizette <bn@niasdigital.com>
> 
> ---
> Index: linux-2.6.24-rc8-mm1/include/asm-avr32/pgalloc.h
> ===================================================================
> --- linux-2.6.24-rc8-mm1.orig/include/asm-avr32/pgalloc.h
> +++ linux-2.6.24-rc8-mm1/include/asm-avr32/pgalloc.h
> @@ -52,9 +52,9 @@ static inline struct page *pte_alloc_one
>  	struct page *pte;
>  
>  	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
> -	if (!page)
> +	if (!pte)
>  		return NULL;
> -	pgtable_page_ctor(page);
> +	pgtable_page_ctor(pte);
>  	return pte;
>  }

Hmm...I can't see anything like this on my current avr32-arch branch,
but I think I mistakenly pushed out some unfinished code about a week
ago and rewound it shortly afterwards. If Andrew pulled during that
window, I guess it must have made it into -mm :-(

But thanks for testing and for providing a fix. I'll check the code
that I was working on and apply the patch if it's still broken.

Haavard
