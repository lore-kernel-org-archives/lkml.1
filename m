Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYG3O2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYG3O2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYG3O2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:28:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13362 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYG3O2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:28:40 -0400
Date: Wed, 30 Jul 2008 07:28:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, mingo@elte.hu
Subject: Re: dma-coherent: add documentation to new interfaces
Message-Id: <20080730072811.902b55e0.randy.dunlap@oracle.com>
In-Reply-To: <20080730104650.GA16416@doriath.ww600.siemens.net>
References: <200807290301.m6T317GG021226@hera.kernel.org>
	<20080729131757.16e721c5.randy.dunlap@oracle.com>
	<20080730104650.GA16416@doriath.ww600.siemens.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 14:46:50 +0400 Dmitry Baryshkov wrote:

> On Tue, Jul 29, 2008 at 01:17:57PM -0700, Randy Dunlap wrote:
> > On Tue, 29 Jul 2008 03:01:07 GMT Linux Kernel Mailing List wrote:
> > 
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b6d4f7e3ef25beb8c658c97867d98883e69dc544
> > > Commit:     b6d4f7e3ef25beb8c658c97867d98883e69dc544
> > > Parent:     8fa8b9fbab90c74139e8e868fe5b30b6a9f6be65
> > > Author:     Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > AuthorDate: Sun Jul 20 15:01:10 2008 +0400
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sun Jul 20 21:22:00 2008 +0200
> > > 
> > >     dma-coherent: add documentation to new interfaces
> > 
> > Hi,
> > Please fix these to be proper kernel-doc notation, as described in
> > Documentation/kernel-doc-nano-HOWTO.txt ...
> 
> Please consider this patch:

Looks good.  Thanks.

Jesse or Ingo:  will one of you merge this, please?


> >From 766159161001e2e118cc840e7aca4b8d500b1ebf Mon Sep 17 00:00:00 2001
> From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Date: Wed, 30 Jul 2008 01:41:58 +0400
> Subject: [PATCH] dma-coherent: fix kernel-doc comments
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  kernel/dma-coherent.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
> index 7517115..9ef28a0 100644
> --- a/kernel/dma-coherent.c
> +++ b/kernel/dma-coherent.c
> @@ -93,7 +93,7 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
>  EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
>  
>  /**
> - * Try to allocate memory from the per-device coherent area.
> + * dma_alloc_from_coherent() - try to allocate memory from the per-device coherent area
>   *
>   * @dev:	device from which we allocate memory
>   * @size:	size of requested memory area
> @@ -101,11 +101,11 @@ EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
>   * @ret:	This pointer will be filled with the virtual address
>   * 		to allocated area.
>   *
> - * This function should be only called from per-arch %dma_alloc_coherent()
> + * This function should be only called from per-arch dma_alloc_coherent()
>   * to support allocation from per-device coherent memory pools.
>   *
>   * Returns 0 if dma_alloc_coherent should continue with allocating from
> - * generic memory areas, or !0 if dma_alloc_coherent should return %ret.
> + * generic memory areas, or !0 if dma_alloc_coherent should return @ret.
>   */
>  int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  				       dma_addr_t *dma_handle, void **ret)
> @@ -127,7 +127,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  }
>  
>  /**
> - * Try to free the memory allocated from per-device coherent memory pool.
> + * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
>   * @dev:	device from which the memory was allocated
>   * @order:	the order of pages allocated
>   * @vaddr:	virtual address of allocated pages
> @@ -136,7 +136,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>   * coherent memory pool and if so, releases that memory.
>   *
>   * Returns 1 if we correctly released the memory, or 0 if
> - * %dma_release_coherent() should proceed with releasing memory from
> + * dma_release_coherent() should proceed with releasing memory from
>   * generic pools.
>   */
>  int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
> -- 

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
