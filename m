Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYF0L4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYF0L4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYF0L4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:56:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45259 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYF0L4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:56:15 -0400
Date: Fri, 27 Jun 2008 12:55:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Johannes Weiner <hannes@saeurebad.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] Remove ->nopfn check from use_zero_page
In-Reply-To: <878wwryw64.fsf@skyscraper.fehenstaub.lan>
Message-ID: <Pine.LNX.4.64.0806271253320.16003@blonde.site>
References: <878wwryw64.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Johannes Weiner wrote:

> Hi Andrew,
> 
> The get_user_pages fix from Linus came to -mm through -next as it seems,
> but -mm has Nick's nopfn removal patches already and so use_zero_page
> checks for a non-existant vm_op.
> 
> This patch is needed to at least compile.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

Please try yesterday's .DATE=2008-06-26-14-32 mmotm,
I sent Andrew a similar fix and it should be okay now.
Also includes fix to endless bad page states once you boot.

Hugh

> ---
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 08cd653..5d7e705 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1082,11 +1082,10 @@ static inline int use_zero_page(struct vm_area_struct *vma)
>  	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
>  		return 0;
>  	/*
> -	 * And if we have a fault or a nopfn routine, it's not an
> -	 * anonymous region.
> +	 * And if we have a fault routine, it's not an anonymous
> +	 * region.
>  	 */
> -	return !vma->vm_ops ||
> -		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
> +	return !vma->vm_ops || !vma->vm_ops->fault;
>  }
>  
>  int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
