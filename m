Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753092AbZALGUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZALGUp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Mon, 12 Jan 2009 01:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZALGUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:20:33 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:33585 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471AbZALGUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:20:32 -0500
Message-ID: <48E9AE16.2000002@snapgear.com>
Date: Mon, 06 Oct 2008 16:20:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-m68k@vger.kernel.org, stable@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig
 can't build
References: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosako,

KOSAKI Motohiro wrote:
> I guess nobody don't test m68knommu at all last three month.
> Do we still need to maintain this architecture?

Yes, we do.

Regards
Greg



> ==
> Currently, m68knommu defconfig can't build. it cause following error.
> 
> net/built-in.o: In function `skb_dma_map':
> : undefined reference to `dma_mapping_error'
> net/built-in.o: In function `skb_dma_unmap':
> : undefined reference to `dma_unmap_single'
> net/built-in.o: In function `skb_dma_unmap':
> : undefined reference to `dma_unmap_page'
> net/built-in.o: In function `skb_dma_map':
> : undefined reference to `dma_map_single'
> net/built-in.o: In function `skb_dma_map':
> : undefined reference to `dma_map_page'
> net/built-in.o: In function `skb_dma_map':
> : undefined reference to `dma_unmap_page'
> net/built-in.o: In function `skb_dma_map':
> : undefined reference to `dma_unmap_single'
> 
> because
>  - CONFIG_DMA depend on !NO_DMA
>  - m68knommu always doesn't turn on NO_DMA
>  - if CONFIG_PCI=n, m68knommu/include/asm/dma-magging.h include
>     asm-generic/dma-mapping-broken.h
>  - dma-mapping-broken.h generate link time error.
>  - m68knommu defconfig doesn't have CONFIG_PCI
>  - On the other hand, net/core/skb_dma_map.c assume CONFIG_DMA=y mean
>    dma related function is callable
> 
> So, we want to turn on CONFIG_DMA if CONFIG_PCI=y only.
> 
> 
> CC: David S. Miller <davem@davemloft.net>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Roman Zippel <zippel@linux-m68k.org>
> CC: Greg Ungerer <gerg@uclinux.org>
> CC: linux-m68k@lists.linux-m68k.org
> ---
>  arch/m68knommu/Kconfig |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: b/arch/m68knommu/Kconfig
> ===================================================================
> --- a/arch/m68knommu/Kconfig	2008-12-25 08:26:37.000000000 +0900
> +++ b/arch/m68knommu/Kconfig	2008-12-28 21:09:58.000000000 +0900
> @@ -73,6 +73,9 @@ config GENERIC_CLOCKEVENTS
>  config NO_IOPORT
>  	def_bool y
>  
> +config NO_DMA
> +	def_bool !PCI
> +
>  source "init/Kconfig"
>  
>  source "kernel/Kconfig.freezer"
> 
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
