Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYG2USm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYG2USm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYG2USd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:18:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48905 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYG2USc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:18:32 -0400
Date: Tue, 29 Jul 2008 13:17:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dbaryshkov@gmail.com, jbarnes@virtuousgeek.org, mingo@elte.hu
Subject: Re: dma-coherent: add documentation to new interfaces
Message-Id: <20080729131757.16e721c5.randy.dunlap@oracle.com>
In-Reply-To: <200807290301.m6T317GG021226@hera.kernel.org>
References: <200807290301.m6T317GG021226@hera.kernel.org>
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

On Tue, 29 Jul 2008 03:01:07 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b6d4f7e3ef25beb8c658c97867d98883e69dc544
> Commit:     b6d4f7e3ef25beb8c658c97867d98883e69dc544
> Parent:     8fa8b9fbab90c74139e8e868fe5b30b6a9f6be65
> Author:     Dmitry Baryshkov <dbaryshkov@gmail.com>
> AuthorDate: Sun Jul 20 15:01:10 2008 +0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun Jul 20 21:22:00 2008 +0200
> 
>     dma-coherent: add documentation to new interfaces

Hi,
Please fix these to be proper kernel-doc notation, as described in
Documentation/kernel-doc-nano-HOWTO.txt ...

>     Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>     Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/dma-coherent.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
> index 56dff5c..7517115 100644
> --- a/kernel/dma-coherent.c
> +++ b/kernel/dma-coherent.c
> @@ -92,6 +92,21 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
>  }
>  EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
>  
> +/**
> + * Try to allocate memory from the per-device coherent area.

Missing function name -

> + *
> + * @dev:	device from which we allocate memory
> + * @size:	size of requested memory area
> + * @dma_handle:	This will be filled with the correct dma handle
> + * @ret:	This pointer will be filled with the virtual address
> + * 		to allocated area.
> + *
> + * This function should be only called from per-arch %dma_alloc_coherent()
> + * to support allocation from per-device coherent memory pools.
> + *
> + * Returns 0 if dma_alloc_coherent should continue with allocating from
> + * generic memory areas, or !0 if dma_alloc_coherent should return %ret.

'%' is a constant-value prefix in kernel-doc.

> + */
>  int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  				       dma_addr_t *dma_handle, void **ret)
>  {
> @@ -111,6 +126,19 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  	return (mem != NULL);
>  }
>  
> +/**
> + * Try to free the memory allocated from per-device coherent memory pool.

Missing function name -

> + * @dev:	device from which the memory was allocated
> + * @order:	the order of pages allocated
> + * @vaddr:	virtual address of allocated pages
> + *
> + * This checks whether the memory was allocated from the per-device
> + * coherent memory pool and if so, releases that memory.
> + *
> + * Returns 1 if we correctly released the memory, or 0 if
> + * %dma_release_coherent() should proceed with releasing memory from

Drop the '%'.

> + * generic pools.
> + */
>  int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
>  {
>  	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
> --


Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
