Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZAKG0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZAKG0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZAKG0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:26:17 -0500
Received: from sh.osrg.net ([192.16.179.4]:45346 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZAKG0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:26:12 -0500
Date: Sun, 11 Jan 2009 15:25:47 +0900
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 02/16] dma-debug: add header file and core data
 structures
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1231517970-20288-3-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	<1231517970-20288-3-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090111152412V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 17:19:16 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Impact: add groundwork for DMA-API debugging
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  include/linux/dma-debug.h |   25 +++++++++++++++++++++++++
>  lib/Makefile              |    2 ++
>  lib/dma-debug.c           |   39 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/dma-debug.h
>  create mode 100644 lib/dma-debug.c
> 
> diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
> new file mode 100644
> index 0000000..ce4ace7
> --- /dev/null
> +++ b/include/linux/dma-debug.h
> @@ -0,0 +1,25 @@
> +/*
> + * Copyright (C) 2008 Advanced Micro Devices, Inc.
> + *
> + * Author: Joerg Roedel <joerg.roedel@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +
> +#ifndef __DMA_DEBUG_H
> +#define __DMA_DEBUG_H
> +
> +struct device;
> +
> +#endif /* __DMA_DEBUG_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index 32b0e64..50b48cf 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -84,6 +84,8 @@ obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
>  
>  obj-$(CONFIG_DYNAMIC_PRINTK_DEBUG) += dynamic_printk.o
>  
> +obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
> +
>  hostprogs-y	:= gen_crc32table
>  clean-files	:= crc32table.h
>  
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> new file mode 100644
> index 0000000..d04f8b6
> --- /dev/null
> +++ b/lib/dma-debug.c
> @@ -0,0 +1,39 @@
> +/*
> + * Copyright (C) 2008 Advanced Micro Devices, Inc.
> + *
> + * Author: Joerg Roedel <joerg.roedel@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +
> +#include <linux/dma-debug.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +
> +enum {
> +	dma_debug_single,
> +	dma_debug_sg,
> +	dma_debug_coherent,
> +};
> +
> +struct dma_debug_entry {
> +	struct list_head list;
> +	struct device    *dev;
> +	int              type;
> +	void             *cpu_addr;

I don't think that cpu addresses are appropriate here.
