Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZHMUaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZHMUaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbZHMUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:30:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZHMUaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:30:01 -0400
Date: Thu, 13 Aug 2009 22:29:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] arch-x86-pci-swiotlb-cleanup-patch
Message-ID: <20090813202948.GA20829@elte.hu>
References: <200908131718.04623.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908131718.04623.mitov@issp.bas.bg>
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


* Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi all,
> 
> This is a simple cleanup patch for arch/x86/kernel/pci-swiotlb.c 
> file.
> 
> Deleted functions are already in lib/swiotlb.c, so no need to be 
> duplicated.
> 
> The patch is against linux-2.6.31-rc5, compile/run tested on 
> x86_64.
> 
> Best regards,
> 
> Marin Mitov
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> 
> =====================================================
> --- a/arch/x86/kernel/pci-swiotlb.c	2009-08-13 16:05:28.000000000 +0300
> +++ b/arch/x86/kernel/pci-swiotlb.c	2009-08-13 16:13:09.000000000 +0300
> @@ -13,31 +13,6 @@
>  
>  int swiotlb __read_mostly;
>  
> -void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> -{
> -	return alloc_bootmem_low_pages(size);
> -}
> -
> -void *swiotlb_alloc(unsigned order, unsigned long nslabs)
> -{
> -	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
> -}
> [...]

Fujita Tomonori has already done this in these swiotlb commits:

  bb52196: swiotlb: remove unused swiotlb_alloc()
  3885123: swiotlb: remove unused swiotlb_alloc_boot()

about a month ago. You can find those changes in -tip:

  http://people.redhat.com/mingo/tip.git/README

and in linux-next as well.

	Ingo
