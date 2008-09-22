Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYIVIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYIVIb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYIVIbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:31:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbYIVIbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:31:02 -0400
Date: Mon, 22 Sep 2008 01:30:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in
 /proc/pid/smaps
Message-Id: <20080922013053.39fd367a.akpm@linux-foundation.org>
In-Reply-To: <1222047492-27622-2-git-send-email-mel@csn.ul.ie>
References: <1222047492-27622-1-git-send-email-mel@csn.ul.ie>
	<1222047492-27622-2-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 02:38:11 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> +		   vma_page_size(vma) >> 10);
>  
>  	return ret;
>  }
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 32e0ef0..0c83445 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -231,6 +231,19 @@ static inline unsigned long huge_page_size(struct hstate *h)
>  	return (unsigned long)PAGE_SIZE << h->order;
>  }
>  
> +static inline unsigned long vma_page_size(struct vm_area_struct *vma)
> +{
> +	struct hstate *hstate;
> +
> +	if (!is_vm_hugetlb_page(vma))
> +		return PAGE_SIZE;
> +
> +	hstate = hstate_vma(vma);
> +	VM_BUG_ON(!hstate);
> +
> +	return 1UL << (hstate->order + PAGE_SHIFT);
> +}
> +

CONFIG_HUGETLB_PAGE=n?

What did you hope to gain by inlining this?
