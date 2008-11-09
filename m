Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYKIKvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYKIKvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYKIKvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:51:41 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:42965 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYKIKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:51:41 -0500
Date: Sun, 9 Nov 2008 11:51:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
       Mike Frysinger <vapier@gentoo.org>, Michael Buesch <mb@bu3sch.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SSB: make it depend on PCI
In-Reply-To: <8bd0f97a0811060315j7d11e1a7p257a4a1bea640f7b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811091149280.19341@anakin>
References: <1225965082-31462-1-git-send-email-vapier@gentoo.org>
 <1225969620.3619.204.camel@johannes.berg> <8bd0f97a0811060315j7d11e1a7p257a4a1bea640f7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Mike Frysinger wrote:
> On Thu, Nov 6, 2008 at 06:07, Johannes Berg wrote:
> > On Thu, 2008-11-06 at 04:51 -0500, Mike Frysinger wrote:
> >> Since the SSB code requires PCI, set the Kconfig dependencies accordingly.
> >> Also tweak the menu display so that the menu does not show up at all if
> >> SSB is not possible.
> >>
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >> ---
> >>  drivers/ssb/Kconfig |    7 ++++---
> >>  1 files changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> >> index 307b1f6..f0a176a 100644
> >> --- a/drivers/ssb/Kconfig
> >> +++ b/drivers/ssb/Kconfig
> >> @@ -1,10 +1,11 @@
> >> -menu "Sonics Silicon Backplane"
> >> -
> >>  config SSB_POSSIBLE
> >>       bool
> >> -     depends on HAS_IOMEM && HAS_DMA
> >> +     depends on HAS_IOMEM && HAS_DMA && PCI
> >
> > This is incorrect. SSB is also used on embedded systems that do not use
> > PCI at all.
> 
> while that may be the intent, it doesnt work today.
> 
> drivers/ssb/main.c always includes linux/ssb/ssb.h
> 
> linux/ssb/ssb.h always calls pci_dma_* functions
> 
> arches that do not support PCI fail to build:
>   CC      drivers/ssb/main.o
> In file included from drivers/ssb/ssb_private.h:5,
>                  from drivers/ssb/main.c:12:
> include/linux/ssb/ssb.h: In function 'ssb_dma_mapping_error':
> include/linux/ssb/ssb.h:430: error: implicit declaration of function
> 'pci_dma_mapping_error'
> include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_for_cpu':
> include/linux/ssb/ssb.h:475: error: implicit declaration of function
> 'pci_dma_sync_single_for_cpu'
> include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_for_device':
> include/linux/ssb/ssb.h:493: error: implicit declaration of function
> 'pci_dma_sync_single_for_device'
> include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_range_for_cpu':
> include/linux/ssb/ssb.h:517: error: implicit declaration of function
> 'dma_sync_single_range_for_cpu'
> include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_range_for_device':
> include/linux/ssb/ssb.h:538: error: implicit declaration of function
> 'dma_sync_single_range_for_device'
> drivers/ssb/main.c: In function 'ssb_dma_set_mask':
> drivers/ssb/main.c:1183: error: implicit declaration of function 'dma_set_mask'
> make[1]: *** [drivers/ssb/main.o] Error 1
> make: *** [drivers/ssb/main.o] Error 2

I had the same issue on m68k, not only with SSB but also with other legacy
drivers (hp100 Ethernet, AIC7xxx SCSI). It was fixed in commit
998aaf01c6f6f3dffc1ea9e7b20b131e38fdbc78 ("m68k: <asm/pci.h> needs
<asm-generic/pci-dma-compat.h>").

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
