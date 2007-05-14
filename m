Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXENHQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXENHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbXENHQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:16:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760361AbXENHQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:16:37 -0400
Date: Mon, 14 May 2007 00:16:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add __vunmap prototype
Message-Id: <20070514001632.60421680.akpm@linux-foundation.org>
In-Reply-To: <20070514070732.B3796DDE44@ozlabs.org>
References: <20070514070732.B3796DDE44@ozlabs.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 17:07:03 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> __vunmap is not static but I couldn't find a prototype for it, so this
> adds it. I need to use it in some powerpc patch to come.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
>  include/linux/vmalloc.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-cell/include/linux/vmalloc.h
> ===================================================================
> --- linux-cell.orig/include/linux/vmalloc.h	2007-05-14 16:03:42.000000000 +1000
> +++ linux-cell/include/linux/vmalloc.h	2007-05-14 16:03:47.000000000 +1000
> @@ -50,6 +50,7 @@ extern void vfree(void *addr);
>  extern void *vmap(struct page **pages, unsigned int count,
>  			unsigned long flags, pgprot_t prot);
>  extern void vunmap(void *addr);
> +extern void __vunmap(void *addr, int deallocate_pages);
>  
>  extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
>  							unsigned long pgoff);

um, the only possible reason for wanting to access __vunmap() is that you
want to do vunmap() from interrupt context, which is deadlockable.

