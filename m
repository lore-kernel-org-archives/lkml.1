Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbXKNAgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbXKNAgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbXKNAgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:36:04 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:33508 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759409AbXKNAgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:36:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tuQiJCjiGRc7nnAsJEwG+GigQd0TvqGVNstOLTAuMj6eNNQkV2NNEKnKpD6dg+nHJb7XDx9o6Feo3DHaZmJLpMibtCcJH2KjcasKR87yckk1qaq94luO8dYHGWZDmTTOdUtT2ODjCcdGjyQlfMpFWmpza1xCNqElrrV5ew6J6pE=  ;
X-YMail-OSG: 730N2v0VM1l4X0tVeTFZR64j7dowSCPwvYeALGYa8LKT8d6cjXv2IhkZyXWfJ5iyC9Dv2ViZhA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: schwidefsky@de.ibm.com
Subject: Re: [patch 3/3] arch_rebalance_pgtables call
Date: Tue, 13 Nov 2007 23:33:37 +1100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20071112143009.425807965@de.ibm.com> <20071112144010.052155135@de.ibm.com>
In-Reply-To: <20071112144010.052155135@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132333.38086.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 01:30, schwidefsky@de.ibm.com wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> In order to change the layout of the page tables after an mmap has
> crossed the adress space limit of the current page table layout a
> architecture hook in get_unmapped_area is needed. The arguments
> are the address of the new mapping and the length of it.

Can you comment what this is supposed to be fore somewhere?


> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>
>  mm/mmap.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/mm/mmap.c
> ===================================================================
> --- linux-2.6.orig/mm/mmap.c
> +++ linux-2.6/mm/mmap.c
> @@ -36,6 +36,10 @@
>  #define arch_mmap_check(addr, len, flags)	(0)
>  #endif
>
> +#ifndef arch_rebalance_pgtables
> +#define arch_rebalance_pgtables(addr, len)		(addr)
> +#endif
> +
>  static void unmap_region(struct mm_struct *mm,
>  		struct vm_area_struct *vma, struct vm_area_struct *prev,
>  		unsigned long start, unsigned long end);
> @@ -1436,7 +1440,7 @@ get_unmapped_area(struct file *file, uns
>  	if (addr & ~PAGE_MASK)
>  		return -EINVAL;
>
> -	return addr;
> +	return arch_rebalance_pgtables(addr, len);
>  }
>
>  EXPORT_SYMBOL(get_unmapped_area);
