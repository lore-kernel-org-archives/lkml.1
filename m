Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZBTIdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZBTIdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZBTIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:33:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbZBTIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:33:10 -0500
Date: Fri, 20 Feb 2009 00:32:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: Subject: [PATCH 08/10 UPDATED] vmalloc: add
 un/map_kernel_range_noflush()
Message-Id: <20090220003229.c3f3abfe.akpm@linux-foundation.org>
In-Reply-To: <499E589B.6060707@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	<1234958676-27618-9-git-send-email-tj@kernel.org>
	<499E589B.6060707@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 16:15:39 +0900 Tejun Heo <tj@kernel.org> wrote:

> +/**
> + * map_kernel_range_noflush - map kernel VM area with the specified pages
> + * @addr: start of the VM area to map
> + * @size: size of the VM area to map
> + * @prot: page protection flags to use
> + * @pages: pages to map
> + *
> + * Map PFN_UP(@size) pages at @addr.  The VM area @addr and @size
> + * specify should have been allocated using get_vm_area() and its
> + * friends.
> + *
> + * NOTE:
> + * This function does NOT do any cache flushing.  The caller is
> + * responsible for calling flush_cache_vmap() on to-be-mapped areas
> + * before calling this function.
> + *
> + * RETURNS:
> + * The number of pages mapped on success, -errno on failure.
> + */
> +int map_kernel_range_noflush(unsigned long addr, unsigned long size,
> +			     pgprot_t prot, struct page **pages)
> +{
> +	return vmap_page_range_noflush(addr, addr + size, prot, pages);
> +}
> +
> +/**
> + * unmap_kernel_range_noflush - unmap kernel VM area
> + * @addr: start of the VM area to unmap
> + * @size: size of the VM area to unmap
> + *
> + * Unmap PFN_UP(@size) pages at @addr.  The VM area @addr and @size
> + * specify should have been allocated using get_vm_area() and its
> + * friends.
> + *
> + * NOTE:
> + * This function does NOT do any cache flushing.  The caller is
> + * responsible for calling flush_cache_vunmap() on to-be-mapped areas
> + * before calling this function and flush_tlb_kernel_range() after.
> + */
> +void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
> +{
> +	vunmap_page_range(addr, addr + size);
> +}

Should these be called
vmap_kernel_range_noflush/vunmap_kernel_range_noflush?

<avoids pointing out the 2 gigapage limit>
