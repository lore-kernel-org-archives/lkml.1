Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZL1KYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZL1KYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZL1KYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:24:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41196 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZL1KYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KET6Z456XPXzs9iQUv1QfppMCSvl20IdvCLk+j3GVq/KbcTdIBOwW22uGbVTCHFbvB
         uw5Eh9GCoYd4Mhx9UlxID0y3jwpFASUozvZIUMFukDmSbyVCh/MNrsmOmjEds7Vaog9p
         0E32w2VLgADMAj5nbCEXVn/a8x4Y+AGKVWtQ4=
Message-ID: <4B38873B.8090704@gmail.com>
Date: Mon, 28 Dec 2009 19:23:55 +0900
From: Minchan Kim <minchan.kim@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 1/3 -mmotm-2009-12-10-17-19] Move functions related to
 zero page
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com>
In-Reply-To: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed Hugh.

Minchan Kim wrote:
> This patch moves is_zero_pfn and my_zero_pfn to mm.h
> for other use case.
> 
> This patch has no side effect and helps following patches.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  include/linux/mm.h |   15 +++++++++++++++
>  mm/memory.c        |   14 --------------
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index be7f851..71bacd1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -751,6 +751,21 @@ struct zap_details {
>  	unsigned long truncate_count;		/* Compare vm_truncate_count */
>  };
>  
> +#ifndef is_zero_pfn
> +extern unsigned long zero_pfn;
> +static inline int is_zero_pfn(unsigned long pfn)
> +{
> +	return pfn == zero_pfn;
> +}
> +#endif
> +
> +#ifndef my_zero_pfn
> +static inline unsigned long my_zero_pfn(unsigned long addr)
> +{
> +	return zero_pfn;
> +}
> +#endif
> +
>  struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  		pte_t pte);
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 09e4b1b..3743fb5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -457,20 +457,6 @@ static inline int is_cow_mapping(unsigned int flags)
>  	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
>  }
>  
> -#ifndef is_zero_pfn
> -static inline int is_zero_pfn(unsigned long pfn)
> -{
> -	return pfn == zero_pfn;
> -}
> -#endif
> -
> -#ifndef my_zero_pfn
> -static inline unsigned long my_zero_pfn(unsigned long addr)
> -{
> -	return zero_pfn;
> -}
> -#endif
> -
>  /*
>   * vm_normal_page -- This function gets the "struct page" associated with a pte.
>   *
