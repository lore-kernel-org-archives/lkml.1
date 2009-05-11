Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbZELAPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbZELAPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZELAPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:15:00 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:55981
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753174AbZELAO7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:14:59 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2009 20:14:59 EDT
X-BigFish: VPS-33(z1039oz542N1432R1805M936fJ8d0Q9371P655Nzz1202hzzz2dh6bh95n61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 12/12] microblaze: use generic dma-mapping-broken.h
Date: Mon, 11 May 2009 16:59:52 -0700
In-Reply-To: <20090511232345.859696820@arndb.de>>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 12/12] microblaze: use generic dma-mapping-broken.h
Thread-Index: AcnSk29mf66zVBKJTHmzv61JzNlg5AAAPHbg
References: <20090511232019.927138561@arndb.de>> <20090511232345.859696820@arndb.de>>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>, "Michal Simek" <monstr@monstr.eu>
CC: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 May 2009 23:59:50.0870 (UTC) FILETIME=[92535F60:01C9D294]
Message-ID: <20090511235954.A1CD414D0050@mail215-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gah... considering the ll_temac needs this, it should get implemented
ASAP...
(Yeah, I know... just not enough hours in the day.)

Steve

> -----Original Message-----
> From: owner-microblaze-uclinux@lists.itee.uq.edu.au
[mailto:owner-microblaze-
> uclinux@lists.itee.uq.edu.au] On Behalf Of Arnd Bergmann
> Sent: Monday, May 11, 2009 4:21 PM
> To: Michal Simek
> Cc: linux-kernel@vger.kernel.org; microblaze-uclinux@itee.uq.edu.au
> Subject: [microblaze-uclinux] [PATCH 12/12] microblaze: use generic
dma-mapping-broken.h
> 
> Microblaze does not support the Linux DMA mapping API
> at this point, so disable CONFIG_NO_DMA. This lets
> us use the generic dma-mapping-broken.h implementation
> instead of providing a different copy.
> 
> Any drivers that try to use DMA mapping now get
> omitted from Kconfig or produce a link error, rather
> than failing silently at run time.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/microblaze/Kconfig                   |    2 +-
>  arch/microblaze/include/asm/dma-mapping.h |  130
+----------------------------
>  2 files changed, 2 insertions(+), 130 deletions(-)
>  rewrite arch/microblaze/include/asm/dma-mapping.h (100%)
> 
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 8cc312b..0d837ee 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -55,7 +55,7 @@ config PCI
> 
>  config NO_DMA
>  	depends on !MMU
> -	def_bool n
> +	def_bool y
> 
>  source "init/Kconfig"
> 
> diff --git a/arch/microblaze/include/asm/dma-mapping.h
b/arch/microblaze/include/asm/dma-mapping.h
> dissimilarity index 100%
> index 1733625..d00e400 100644
> --- a/arch/microblaze/include/asm/dma-mapping.h
> +++ b/arch/microblaze/include/asm/dma-mapping.h
> @@ -1,129 +1 @@
> -/*
> - * Copyright (C) 2006 Atmark Techno, Inc.
> - *
> - * This file is subject to the terms and conditions of the GNU
General Public
> - * License. See the file "COPYING" in the main directory of this
archive
> - * for more details.
> - */
> -
> -#ifndef _ASM_MICROBLAZE_DMA_MAPPING_H
> -#define _ASM_MICROBLAZE_DMA_MAPPING_H
> -
> -#include <asm/cacheflush.h>
> -#include <linux/io.h>
> -#include <linux/bug.h>
> -
> -struct scatterlist;
> -
> -#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h,
f)
> -#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v,
h)
> -
> -/* FIXME */
> -static inline int
> -dma_supported(struct device *dev, u64 mask)
> -{
> -	return 1;
> -}
> -
> -static inline dma_addr_t
> -dma_map_page(struct device *dev, struct page *page,
> -	unsigned long offset, size_t size,
> -	enum dma_data_direction direction)
> -{
> -	BUG();
> -	return 0;
> -}
> -
> -static inline void
> -dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t
size,
> -	enum dma_data_direction direction)
> -{
> -	BUG();
> -}
> -
> -static inline int
> -dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> -	enum dma_data_direction direction)
> -{
> -	BUG();
> -	return 0;
> -}
> -
> -static inline void
> -dma_unmap_sg(struct device *dev, struct scatterlist *sg, int
nhwentries,
> -	enum dma_data_direction direction)
> -{
> -	BUG();
> -}
> -
> -static inline void
> -dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
size_t size,
> -			enum dma_data_direction direction)
> -{
> -	BUG();
> -}
> -
> -static inline void
> -dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
> -		size_t size, enum dma_data_direction direction)
> -{
> -	BUG();
> -}
> -
> -static inline void
> -dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int
nelems,
> -		enum dma_data_direction direction)
> -{
> -	BUG();
> -}
> -
> -static inline void
> -dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
int nelems,
> -		enum dma_data_direction direction)
> -{
> -	BUG();
> -}
> -
> -static inline int dma_mapping_error(struct device *dev, dma_addr_t
dma_addr)
> -{
> -	return 0;
> -}
> -
> -static inline void *dma_alloc_coherent(struct device *dev, size_t
size,
> -				dma_addr_t *dma_handle, int flag)
> -{
> -	return NULL; /* consistent_alloc(flag, size, dma_handle); */
> -}
> -
> -static inline void dma_free_coherent(struct device *dev, size_t size,
> -			void *vaddr, dma_addr_t dma_handle)
> -{
> -	BUG();
> -}
> -
> -static inline dma_addr_t
> -dma_map_single(struct device *dev, void *ptr, size_t size,
> -	enum dma_data_direction direction)
> -{
> -	BUG_ON(direction == DMA_NONE);
> -
> -	return virt_to_bus(ptr);
> -}
> -
> -static inline void dma_unmap_single(struct device *dev, dma_addr_t
dma_addr,
> -				    size_t size,
> -				    enum dma_data_direction direction)
> -{
> -	switch (direction) {
> -	case DMA_FROM_DEVICE:
> -		flush_dcache_range((unsigned)dma_addr,
> -			(unsigned)dma_addr + size);
> -			/* Fall through */
> -	case DMA_TO_DEVICE:
> -		break;
> -	default:
> -		BUG();
> -	}
> -}
> -
> -#endif /* _ASM_MICROBLAZE_DMA_MAPPING_H */
> +#include <asm-generic/dma-mapping-broken.h>
> --
> 1.6.0.4
> 
> --
> 
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page :
http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive :
http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


