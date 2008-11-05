Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYKEKW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYKEKW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYKEKWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:22:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45766 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754223AbYKEKWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:22:15 -0500
Date: Wed, 5 Nov 2008 11:21:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: Constantin Baranov <const@mimas.ru>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc3] x86: make CONFIG_SWIOTLB configurable
Message-ID: <20081105102126.GC1424@ucw.cz>
References: <49107844.8070509@mimas.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49107844.8070509@mimas.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-11-04 20:28:52, Constantin Baranov wrote:
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

Why experimental?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
