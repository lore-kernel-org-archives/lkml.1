Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYHSOdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYHSOdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYHSOct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:32:49 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42363 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYHSOcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:32:48 -0400
Date: Tue, 19 Aug 2008 17:32:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: gerg@uclinux.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [2.6 patch] m68knommu: let PCI depend on BROKEN
Message-ID: <20080819143238.GK8852@cs181140183.pp.htv.fi>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0808191613100.9575@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808191613100.9575@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:13:33PM +0200, Geert Uytterhoeven wrote:
> On Tue, 19 Aug 2008, Adrian Bunk wrote:
> > There exists blackfin hardware with PCI support, but the support
> > currently in the kernel fails to build starting with:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      init/main.o
> > In file included from dma-mapping.h:5,
> >                  from dma-mapping.h:52,
> >                  from dmaengine.h:29,
> >                  from skbuff.h:29,
> >                  from netlink.h:155,
> >                  from genetlink.h:4,
> >                  from genetlink.h:4,
> >                  from taskstats_kern.h:12,
> >                  from main.c:46:
> > dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: 
> > error: implicit declaration of function 'pci_dma_supported'
> > ...
> > make[2]: *** [init/main.o] Error 1
> > 
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 3bdc07c86b6fd5fc18b7676a75c3ff907e00e807 
> > diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
> > index 2e7515e..77a5bdf 100644
> > --- a/arch/m68knommu/Kconfig
> > +++ b/arch/m68knommu/Kconfig
> > @@ -702,6 +702,7 @@ menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
> >  
> >  config PCI
> >  	bool "PCI support"
> > +	depends on BROKEN
> >  	help
> >  	  Support for PCI bus.
> 
> blackfin != m68knommu

s/blackfin/m68knommu/ in the patch description (relict from copying it 
from the other similar patch, see http://lkml.org/lkml/2008/8/19/196).

The error message and the patch are for m68knommu.

> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

