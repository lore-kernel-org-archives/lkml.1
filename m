Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXISGdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXISGdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 02:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXISGdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 02:33:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXISGdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 02:33:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=GuIS09vO/XZoppuhzoQkfwbclL1LH58DycWR7GEdPdjzFTa4mxB+tjuNTcjB46L8l
	Ebi2AlSjisKBWiSRxkBHw==
Date: Tue, 18 Sep 2007 23:32:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the
 vmalloc boundaries
In-Reply-To: <20070919033641.009931707@sgi.com>
Message-ID: <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Christoph Lameter wrote:

> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h	2007-09-17 21:46:06.000000000 -0700
> +++ linux-2.6/include/linux/mm.h	2007-09-17 23:56:54.000000000 -0700
> @@ -1158,6 +1158,14 @@ static inline unsigned long vma_pages(st
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +/* Determine if an address is within the vmalloc range */
> +static inline int is_vmalloc_addr(const void *x)
> +{
> +	unsigned long addr = (unsigned long)x;
> +
> +	return addr >= VMALLOC_START && addr < VMALLOC_END;
> +}

This breaks on i386 because VMALLOC_END is defined in terms of PKMAP_BASE 
in the CONFIG_HIGHMEM case.

This function should probably be in include/linux/vmalloc.h instead since 
all callers already include it anyway.
