Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZEKDl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZEKDl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZEKDls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:41:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:40164 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZEKDls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:41:48 -0400
Date: Mon, 11 May 2009 12:40:39 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 5/9] xen: enable swiotlb for xen domain 0.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241741842-7966-6-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
	<1241741842-7966-6-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090511123123C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 12:40:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 May 2009 17:17:18 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Impact: Xen DMA support
> 
> Enable swiotlb when running as a Xen dom0 domain.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb.c |    5 +++++
>  arch/x86/xen/Kconfig          |    1 +
>  drivers/pci/xen-iommu.c       |    5 +++++
>  include/xen/swiotlb.h         |    9 +++++++++
>  4 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 861c869..2d8dd35 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -11,6 +11,8 @@
>  #include <asm/swiotlb.h>
>  #include <asm/dma.h>
>  
> +#include <xen/swiotlb.h>
> +
>  int swiotlb __read_mostly;
>  
>  static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> @@ -49,6 +51,9 @@ void __init pci_swiotlb_init(void)
>  	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
>  	       swiotlb = 1;
>  #endif
> +	if (xen_wants_swiotlb())
> +		swiotlb = 1;
> +
>  	if (swiotlb_force)
>  		swiotlb = 1;
>  	if (swiotlb) {

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

I don't like the patch much though.

The x86 dma startup code is complicated and adding another hook makes
it more complicated.
