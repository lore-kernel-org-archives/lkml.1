Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbXHHHpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbXHHHpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbXHHHpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:45:06 -0400
Received: from gg.genua.de ([151.136.100.2]:48741 "EHLO gg.genua.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbXHHHpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:45:05 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 03:45:04 EDT
From: Christian Ehrhardt <Christian_Ehrhardt@genua.de>
Message-Id: <200708080738.l787c6gP007376@felsenbeisser.genua.de>
To: Dave Hansen <haveblue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC][PATCH 2/5] pagemap: use PAGE_MASK/PAGE_ALIGN()
In-Reply-To: <8PFSA-6mt-1@gated-at.bofh.it>
References: <8PFSA-6mt-3@gated-at.bofh.it> <8PFSA-6mt-1@gated-at.bofh.it>
Date: Wed, 8 Aug 2007 09:38:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In linux.kernel, you wrote:
>
> Use existing macros (PAGE_MASK/PAGE_ALIGN()) instead of
> open-coding them.
>
> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
> ---
>
>  lxc-dave/fs/proc/task_mmu.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN fs/proc/task_mmu.c~pagemap-use-PAGE_MASK fs/proc/task_mmu.c
> --- lxc/fs/proc/task_mmu.c~pagemap-use-PAGE_MASK	2007-08-07 15:30:52.000000000 -0700
> +++ lxc-dave/fs/proc/task_mmu.c	2007-08-07 15:30:52.000000000 -0700
> @@ -669,9 +669,9 @@ static ssize_t pagemap_read(struct file 
>  		goto out;
>  
>  	ret = -ENOMEM;
> -	uaddr = (unsigned long)buf & ~(PAGE_SIZE-1);
> +	uaddr = (unsigned long)buf & PAGE_MASK;
>  	uend = (unsigned long)(buf + count);
> -	pagecount = (uend - uaddr + PAGE_SIZE-1) / PAGE_SIZE;
> +	pagecount = (uend - PAGE_ALIGN(uaddr)) / PAGE_SIZE;

Unless I'm missing something the PAGE_ALIGN as ist stands is now a NOP
because uaddr is already page aligned. You probably wanted to
PAGE_ALIGN(uend). However, this will likely add an additional instruction
to the generated code.

    regards  Christian


