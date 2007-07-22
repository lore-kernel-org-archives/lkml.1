Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXGVGEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXGVGEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXGVGEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:04:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbXGVGEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:04:40 -0400
Date: Sat, 21 Jul 2007 23:04:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Charlie Shepherd <masterdriverz@gentoo.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Remove unused variable 'start'.
Message-Id: <20070721230424.dc0cf5ab.akpm@linux-foundation.org>
In-Reply-To: <11850424083434-git-send-email-masterdriverz@gentoo.org>
References: <11850424083434-git-send-email-masterdriverz@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 20:26:47 +0200 Charlie Shepherd <masterdriverz@gentoo.org> wrote:

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 3cee76a..5e7daea 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -72,7 +72,6 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
>  {
>  	pgd_t *pgd;
>  	unsigned long next;
> -	unsigned long start = addr;
>  	unsigned long end = addr + size;
>  
>  	BUG_ON(addr >= end);
> @@ -84,7 +83,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
>  			continue;
>  		vunmap_pud_range(pgd, addr, next);
>  	} while (pgd++, addr = next, addr != end);
> -	flush_tlb_kernel_range(start, end);
> +	flush_tlb_kernel_range(addr, end);
>  }
>  
>  static void unmap_vm_area(struct vm_struct *area)

err, no.  addr has a different value here.

There's a patch in Andi's tree which fixes the compile warning.
