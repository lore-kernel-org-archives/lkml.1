Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXJaIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXJaIv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXJaIvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:51:20 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:41402 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753655AbXJaIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:51:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3Kp5/lnL9ylcQcGxNpgA/emzhYJyu+YM7QxB8aXbKMo2Lntx+bm7iMhMajpZsoqvP24KKxAkwad49pvZ/O3l/7cePjhWUmAVaR2t2UUcO/MkL7Qo3gz0BBjAX5ahDCz8df3A4b3rafJd8dzOwgC1HVCZIxQlzQxqr+YOEPGWb9A=  ;
X-YMail-OSG: 9M9O_ZcVM1kwDC0vfOZ71DJVFObcL8SN0PybKGrhWahunK3D2_ucyZuu1d7K3d5Gj1n36BYlOg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Swap delay accounting, include lock_page() delays
Date: Wed, 31 Oct 2007 18:41:53 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20071031075243.22225.53636.sendpatchset@balbir-laptop>
In-Reply-To: <20071031075243.22225.53636.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311841.53671.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 18:52, Balbir Singh wrote:
> Reported-by: Nick Piggin <nickpiggin@yahoo.com.au>
>
> The delay incurred in lock_page() should also be accounted in swap delay
> accounting
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Ah right, I forgot to resend this one, sorry. Thanks for remembering.


> ---
>
>  mm/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN mm/swapfile.c~fix-delay-accounting-swap-accounting mm/swapfile.c
> diff -puN mm/memory.c~fix-delay-accounting-swap-accounting mm/memory.c
> ---
> linux-2.6-latest/mm/memory.c~fix-delay-accounting-swap-accounting	2007-10-3
>1 12:58:05.000000000 +0530 +++
> linux-2.6-latest-balbir/mm/memory.c	2007-10-31 13:02:50.000000000 +0530 @@
> -2084,9 +2084,9 @@ static int do_swap_page(struct mm_struct
>  		count_vm_event(PGMAJFAULT);
>  	}
>
> -	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
>  	mark_page_accessed(page);
>  	lock_page(page);
> +	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
>
>  	/*
>  	 * Back out if somebody else already faulted in this pte.
> _
