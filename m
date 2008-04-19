Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYDSRNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYDSRNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 13:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYDSRNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 13:13:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36362 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYDSRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 13:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=xsqAiwzdAzIfLBc6eM1M4uZHOkckLezHV7vmdn2291wJLaS0mBjYKuU4UMj98xzm3BV56izPgAU/2SMilxgIzJtOb3lsHGhThujUln6cVNlK15Kf2CPxiFLbNVATP2TTg/eRj0174SO1yS8o4ixDDmAflRLFfESIC/I357LBbbI=
Message-ID: <480A281C.7030501@gmail.com>
Date: Sat, 19 Apr 2008 21:13:00 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, dev-etrax@axis.com,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH][trivial][2/2] cris: add constfy to pgd_offset()
References: <20080419185723.A8F1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080419190442.A8F4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080419190710.A8F7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080419190710.A8F7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro пишет:
> add constfy to pgd_offset() for avoid following warnings.
>  
>   CC      mm/pagewalk.o
> mm/pagewalk.c: In function 'walk_page_range':
> mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
> ointer target type
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Matt Mackall <mpm@selenic.com>
> CC: "Vegard Nossum" <vegard.nossum@gmail.com>
> CC: Mikael Starvik <starvik@axis.com>
> CC: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  include/asm-cris/pgtable.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/include/asm-cris/pgtable.h
> ===================================================================
> --- a/include/asm-cris/pgtable.h        2008-04-19 19:25:50.000000000 +0900
> +++ b/include/asm-cris/pgtable.h        2008-04-19 19:27:31.000000000 +0900
> @@ -229,7 +229,7 @@ static inline void pmd_set(pmd_t * pmdp,
>  #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
> 
>  /* to find an entry in a page-table-directory */
> -static inline pgd_t * pgd_offset(struct mm_struct * mm, unsigned long address)
> +static inline pgd_t * pgd_offset(const struct mm_struct * mm, unsigned long address)
                        ^                                   ^
I think that while at it, you could also delete these superfluous spaces
after the asterisks thereby making the code conform to the kernel coding style.

Dmitri

>  {
>         return mm->pgd + pgd_index(address);
>  }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

