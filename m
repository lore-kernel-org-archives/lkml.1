Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYHYGQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYHYGQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYHYGQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:16:21 -0400
Received: from hosted05.westnet.com.au ([203.10.1.219]:54766 "EHLO
	hosted05.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYHYGQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:16:20 -0400
Message-ID: <48B24E2C.9060703@snapgear.com>
Date: Mon, 25 Aug 2008 16:16:12 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: gerg@uclinux.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [2.6 patch] m68knommu: let PCI depend on BROKEN
References: <20080819134718.GH8852@cs181140183.pp.htv.fi>
In-Reply-To: <20080819134718.GH8852@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Adrian,

Adrian Bunk wrote:
> There exists blackfin hardware with PCI support, but the support
> currently in the kernel fails to build starting with:
> 
> <--  snip  -->
> 
> ...
>   CC      init/main.o
> In file included from dma-mapping.h:5,
>                  from dma-mapping.h:52,
>                  from dmaengine.h:29,
>                  from skbuff.h:29,
>                  from netlink.h:155,
>                  from genetlink.h:4,
>                  from genetlink.h:4,
>                  from taskstats_kern.h:12,
>                  from main.c:46:
> dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: 
> error: implicit declaration of function 'pci_dma_supported'
> ...
> make[2]: *** [init/main.o] Error 1

I think we should just remove the underlying comempci access
code which is the only user of this (arch/m68knommu/kernel/comempci.c).
Nobody has used it in a very long time. And the hardware itself is
old, and completely brain-damaged by design.

Regards
Greg



> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 3bdc07c86b6fd5fc18b7676a75c3ff907e00e807 
> diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
> index 2e7515e..77a5bdf 100644
> --- a/arch/m68knommu/Kconfig
> +++ b/arch/m68knommu/Kconfig
> @@ -702,6 +702,7 @@ menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
>  
>  config PCI
>  	bool "PCI support"
> +	depends on BROKEN
>  	help
>  	  Support for PCI bus.
>  
> 
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
