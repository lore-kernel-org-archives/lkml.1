Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbXKDBod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbXKDBod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 21:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXKDBoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 21:44:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54760 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755137AbXKDBoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 21:44:24 -0400
Date: Sun, 4 Nov 2007 02:44:01 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] x86: start unification of arch/x86/Kconfig.*
Message-ID: <20071104014401.GI12045@stusta.de>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11941338804007-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 12:51:12AM +0100, Sam Ravnborg wrote:
>...
> --- a/arch/x86/Kconfig.x86_64
> +++ b/arch/x86/Kconfig.x86_64
>...
>  # x86-64 doesn't support PCI BIOS access from long mode so always go direct.
>  config PCI_DIRECT
> @@ -737,36 +723,11 @@ config PCI_DIRECT
>  	depends on PCI
>  	default y
>  
> -config PCI_MMCONFIG
> -	bool "Support mmconfig PCI config space access"
> -	depends on PCI && ACPI
> -
>  config PCI_DOMAINS
>  	bool
>  	depends on PCI
>  	default y
>  
> -config DMAR
> -	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
> -	depends on PCI_MSI && ACPI && EXPERIMENTAL
> -	help
> -	  DMA remapping (DMAR) devices support enables independent address
> -	  translations for Direct Memory Access (DMA) from devices.
> -	  These DMA remapping devices are reported via ACPI tables
> -	  and include PCI device scope covered by these DMA
> -	  remapping devices.
> -
> -config DMAR_GFX_WA
> -	bool "Support for Graphics workaround"
> -	depends on DMAR
> -	default y
> -	help
> -	 Current Graphics drivers tend to use physical address
> -	 for DMA and avoid using DMA APIs. Setting this config
> -	 option permits the IOMMU driver to set a unity map for
> -	 all the OS-visible memory. Hence the driver can continue
> -	 to use physical addresses for DMA.
> -
>  config DMAR_FLOPPY_WA
>  	bool
>  	depends on DMAR
>...

In patch 8 the remaining PCI_* options and DMAR_FLOPPY_WA end in a 
completely different place in the Kconfig file than the options moved 
here.

Please keep options that belong together grouped together no matter 
whether all of them are user visible.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

