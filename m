Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbYKSFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbYKSFoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYKSFoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:44:04 -0500
Received: from sh.osrg.net ([192.16.179.4]:33403 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYKSFoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:44:02 -0500
Date: Wed, 19 Nov 2008 14:41:53 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, hawk@pld-linux.org, stable@kernel.org
Subject: Re: [PATCH] x86: always select SWIOTLB on x86_64
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1227008661-1609-1-git-send-email-joerg.roedel@amd.com>
References: <1227008661-1609-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119144238W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 12:44:21 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Impact: fixes korg bugzilla 11980
> 
> A kernel for a 64bit x86 system should always contain the swiotlb code
> in case it is booted on a machine without any hardware IOMMU supported
> by the kernel and more than 4GB of RAM. This patch changes Kconfig to
> always compile swiotlb into the kernel for x86_64.

Yeah, as I wrote in a different thread, I think that it makes sense to
enable SWIOTLB at all times:

http://marc.info/?l=linux-kernel&m=122593287501949&w=2

An option asking an user if he has more than 4GB RAM or not, doesn't
make sense much.

BTW, you can also remove the help description, right?
 
> ---
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 93224b5..669c6d5 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -566,7 +566,7 @@ config AMD_IOMMU
>  
>  # need this always selected by IOMMU for the VIA workaround
>  config SWIOTLB
> -	bool
> +	def_bool y if X86_64
>  	help
>  	  Support for software bounce buffers used on x86-64 systems
>  	  which don't have a hardware IOMMU (e.g. the current generation
> -- 
> 1.5.6.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
