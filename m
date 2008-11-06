Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYKFAy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYKFAy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYKFAyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:54:18 -0500
Received: from sh.osrg.net ([192.16.179.4]:60478 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbYKFAyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:54:17 -0500
Date: Thu, 6 Nov 2008 09:53:49 +0900
To: const@mimas.ru
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc3] x86: make CONFIG_SWIOTLB configurable
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49107844.8070509@mimas.ru>
References: <49107844.8070509@mimas.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081106095402X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 20:28:52 +0400
Constantin Baranov <const@mimas.ru> wrote:

> Make it possible to enable individually the CONFIG_SWIOTLB option.
> This is useful for Intel x86_64 systems without DMAR support.
> 
> Signed-off-by: Constantin Baranov <const@mimas.ru>
> ---
> Tested on my system based on Gigabyte GA-EP45-DS3 mainboard
> (P45 chipset) with 8 GiB of RAM.
> Currently I need to enable either CONFIG_GART_IOMMU or
> CONFIG_AMD_IOMMU for proper work. Both are AMD specific.
> When the patch applied, just CONFIG_SWIOTLB is sufficient.
> 
>  arch/x86/Kconfig |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.28-rc3/arch/x86/Kconfig	2008-11-04 17:32:29.846408880 +0400
> +++ linux-2.6.28-rc3-swiotlb/arch/x86/Kconfig	2008-11-04 18:11:47.796408084 +0400
> @@ -566,7 +566,9 @@ config AMD_IOMMU
>  
>  # need this always selected by IOMMU for the VIA workaround
>  config SWIOTLB
> -	bool
> +	bool "Support for software bounce buffers"
> +	depends on X86_64 && EXPERIMENTAL
> +	default n
>  	help
>  	  Support for software bounce buffers used on x86-64 systems
>  	  which don't have a hardware IOMMU (e.g. the current generation

IMHO, it's better to always enable SWIOTLB for X86_64 (the description
is a bit misleading; even with a hardware IOMMU, SWIOTLB is
necessary).
