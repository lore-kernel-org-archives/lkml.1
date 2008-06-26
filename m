Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbYFZNYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbYFZNYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbYFZNXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:23:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59175 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYFZNXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:23:51 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, shannon.nelson@intel.com,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v4 0/6] dmaengine/mmc: DMA slave interface and two new drivers
Date: Thu, 26 Jun 2008 15:23:17 +0200
Message-Id: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 26 Jun 2008 13:23:06.0541 (UTC) FILETIME=[C4FF25D0:01C8D78F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, I'm sorry it went so much time between v3 and v4 of this
patchset. I was hoping to finish this stuff up before all kinds of
other tasks started demanding my attention, but I didn't, so I had to
put it on hold for a while. Let's try again...

This patchset extends the DMA engine API to allow drivers to offer DMA
to and from I/O registers with hardware handshaking, aka slave DMA.
Such functionality is very common in DMA controllers integrated on SoC
devices, and it's typically used to do DMA transfers to/from other
on-SoC peripherals, but it can often do DMA transfers to/from
externally connected devices as well (e.g. IDE hard drives).

The main differences from v3 of this patchset are:
  * A DMA descriptor can hold a whole scatterlist. This means that
    clients using slave DMA can submit large requests in a single call
    to the driver, and they only need to keep track of a single
    descriptor.
  * The dma_slave_descriptor struct is gone since clients no longer
    need to keep track of multiple descriptors.
  * The drivers perform better and are more stable.

The dw_dmac driver depends on this patch:

	http://lkml.org/lkml/2008/6/25/148

and the atmel-mci driver depends on this series:

	http://lkml.org/lkml/2008/6/26/158

as well as all preceding patches in this series, of course.

Comments are welcome, as usual! Shortlog and diffstat follow.

Haavard Skinnemoen (6):
      dmaengine: Add dma_client parameter to device_alloc_chan_resources
      dmaengine: Add dma_chan_is_in_use() function
      dmaengine: Add slave DMA interface
      dmaengine: Make DMA Engine menu visible for AVR32 users
      dmaengine: Driver for the Synopsys DesignWare DMA controller
      Atmel MCI: Driver for Atmel on-chip MMC controllers

 arch/avr32/boards/atngw100/setup.c         |    7 +
 arch/avr32/boards/atstk1000/atstk1002.c    |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c        |   73 ++-
 drivers/dma/Kconfig                        |   11 +-
 drivers/dma/Makefile                       |    1 +
 drivers/dma/dmaengine.c                    |   31 +-
 drivers/dma/dw_dmac.c                      | 1105 +++++++++++++++++++++
 drivers/dma/dw_dmac_regs.h                 |  224 +++++
 drivers/dma/ioat_dma.c                     |    5 +-
 drivers/dma/iop-adma.c                     |    7 +-
 drivers/mmc/host/Kconfig                   |   10 +
 drivers/mmc/host/Makefile                  |    1 +
 drivers/mmc/host/atmel-mci-regs.h          |  194 ++++
 drivers/mmc/host/atmel-mci.c               | 1428 ++++++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/at32ap700x.h |   16 +
 include/asm-avr32/arch-at32ap/board.h      |    6 +-
 include/asm-avr32/atmel-mci.h              |   12 +
 include/linux/dmaengine.h                  |   73 ++-
 include/linux/dw_dmac.h                    |   62 ++
 19 files changed, 3229 insertions(+), 40 deletions(-)
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac_regs.h
 create mode 100644 drivers/mmc/host/atmel-mci-regs.h
 create mode 100644 drivers/mmc/host/atmel-mci.c
 create mode 100644 include/asm-avr32/atmel-mci.h
 create mode 100644 include/linux/dw_dmac.h

Haavard
