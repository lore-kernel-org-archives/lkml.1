Return-Path: <linux-kernel-owner+w=401wt.eu-S935123AbXFFTLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbXFFTLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765728AbXFFTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:11:47 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:52934 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761375AbXFFTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:11:46 -0400
Date: Wed, 6 Jun 2007 21:11:44 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-dvb@linuxtv.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: drivers/media/dvb/b2c2/flexcop-dma.c uses PCI DMA API
Message-ID: <Pine.LNX.4.64.0706062106150.30244@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

drivers/media/dvb/b2c2/flexcop-dma.c uses the PCI DMA API, but DVB_B2C2_FLEXCOP
doesn't depend on PCI, causing the following problem on PCI-less systems:

| linux/drivers/media/dvb/b2c2/flexcop-dma.c:20: warning: implicit declaration of function 'pci_alloc_consistent'
| linux/drivers/media/dvb/b2c2/flexcop-dma.c:20: warning: implicit declaration of function 'pci_alloc_consistent'

Apparently this is the flexcop DMA core, which is used by both
DVB_B2C2_FLEXCOP_PCI and DVB_B2C2_FLEXCOP_USB.

DVB_B2C2_FLEXCOP_PCI depends on PCI.
DVB_B2C2_FLEXCOP_USB depends on USB.

Perhaps the flexcop DMA core should use the generic DMA API instead?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
