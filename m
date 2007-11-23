Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXKWMVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXKWMVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbXKWMVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:21:17 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55149 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756066AbXKWMVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:21:16 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC 0/4] dmaengine: Slave DMA interface and example users
Date: Fri, 23 Nov 2007 13:20:09 +0100
Message-Id: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds the necessary interfaces to the DMA Engine
framework to use functionality found on most embedded DMA controllers:
DMA from and to I/O registers with hardware handshaking.

In this context, hardware hanshaking means that the peripheral that
owns the I/O registers in question is able to tell the DMA controller
when more data is available for reading, or when there is room for
more data to be written. This usually happens internally on the chip,
but these signals may also be exported outside the chip for things
like IDE DMA, etc.

I'd really like some feedback on the first patch in the series,
particularly from people using other platforms than AVR32 and people
who use or want to use the DW DMAC controller for other things than
what the Atmel-provided drivers do. The three other patches in the
series are provided mostly for context, although I do want to get them
merged into mainline eventually. This should happen after the basic
interfaces have been properly worked out though.

I've tested everything together and it seems to work most of the time;
I can insert an MMC card and mount a partition with an ext3 filesystem
on it, but I get some ext3 errors from time to time, so there are
still some issues to be worked out.

Haavard
Haavard Skinnemoen (4):
      dmaengine: Add slave DMA interface
      dmaengine: Make DMA Engine menu visible for AVR32 users
      dmaengine: Driver for the Synopsys DesignWare DMA controller
      Atmel MCI: Driver for Atmel on-chip MMC controllers

 arch/avr32/boards/atngw100/setup.c         |    6 +
 arch/avr32/boards/atstk1000/atstk1002.c    |    3 +
 arch/avr32/mach-at32ap/at32ap7000.c        |   60 +-
 drivers/dma/Kconfig                        |   11 +-
 drivers/dma/Makefile                       |    1 +
 drivers/dma/dmaengine.c                    |    6 +
 drivers/dma/dw_dmac.c                      | 1180 ++++++++++++++++++++++++++++
 drivers/dma/dw_dmac.h                      |  257 ++++++
 drivers/mmc/host/Kconfig                   |   10 +
 drivers/mmc/host/Makefile                  |    1 +
 drivers/mmc/host/atmel-mci.c               | 1170 +++++++++++++++++++++++++++
 drivers/mmc/host/atmel-mci.h               |  192 +++++
 include/asm-avr32/arch-at32ap/at32ap7000.h |   16 +
 include/asm-avr32/arch-at32ap/board.h      |   10 +-
 include/linux/dmaengine.h                  |   55 ++-
 15 files changed, 2957 insertions(+), 21 deletions(-)
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac.h
 create mode 100644 drivers/mmc/host/atmel-mci.c
 create mode 100644 drivers/mmc/host/atmel-mci.h
