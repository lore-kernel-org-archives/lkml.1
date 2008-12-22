Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYLVFfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYLVFfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 00:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYLVFf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 00:35:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:48773 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYLVFf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 00:35:28 -0500
Date: Mon, 22 Dec 2008 14:34:54 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 07 of 14] swiotlb: add arch hook to force mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <de816a2fdde6a5f940cd.1229458651@abulafia.goop.org>
References: <patchbomb.1229458644@abulafia.goop.org>
	<de816a2fdde6a5f940cd.1229458651@abulafia.goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081222140824U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 12:17:31 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Some architectures require special rules to determine whether a range
> needs mapping or not.  This adds a weak function for architectures to
> override.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  include/linux/swiotlb.h |    2 ++
>  lib/swiotlb.c           |   15 +++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -30,6 +30,8 @@
>  extern dma_addr_t swiotlb_phys_to_bus(phys_addr_t address);
>  extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
>  
> +extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
> +
>  extern void
>  *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  			dma_addr_t *dma_handle, gfp_t flags);
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -145,6 +145,11 @@
>  	return phys_to_virt(swiotlb_bus_to_phys(address));
>  }
>  
> +int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
> +{
> +	return 0;
> +}

Can't you simply make address_needs_mapping __weak as Becky does?
