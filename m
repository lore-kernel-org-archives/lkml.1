Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXJJTWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXJJTWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXJJTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:21:53 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:48321 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXJJTVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:21:52 -0400
Date: Wed, 10 Oct 2007 21:21:49 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20071010212149.0073ee08@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

Lot's of changes in here. Mostly it is SDIO and SPI support, although there are things like removal of MMC layer specific error codes.

diffstat:

 MAINTAINERS                     |    8 +-
 arch/arm/mach-imx/mx1ads.c      |    2 +-
 drivers/mmc/card/Kconfig        |    7 +
 drivers/mmc/card/Makefile       |    2 +
 drivers/mmc/card/block.c        |   30 +-
 drivers/mmc/card/sdio_uart.c    | 1158 ++++++++++++++++++++++++++++++++
 drivers/mmc/core/Makefile       |    4 +-
 drivers/mmc/core/bus.c          |   67 ++-
 drivers/mmc/core/core.c         |  167 ++++--
 drivers/mmc/core/core.h         |    2 +
 drivers/mmc/core/host.c         |    8 +
 drivers/mmc/core/mmc.c          |  134 +++--
 drivers/mmc/core/mmc_ops.c      |  200 +++++--
 drivers/mmc/core/mmc_ops.h      |    3 +
 drivers/mmc/core/sd.c           |  126 +++--
 drivers/mmc/core/sd_ops.c       |  107 ++-
 drivers/mmc/core/sdio.c         |  395 +++++++++++
 drivers/mmc/core/sdio_bus.c     |  270 ++++++++
 drivers/mmc/core/sdio_bus.h     |   22 +
 drivers/mmc/core/sdio_cis.c     |  346 ++++++++++
 drivers/mmc/core/sdio_cis.h     |   23 +
 drivers/mmc/core/sdio_io.c      |  548 +++++++++++++++
 drivers/mmc/core/sdio_irq.c     |  267 ++++++++
 drivers/mmc/core/sdio_ops.c     |  176 +++++
 drivers/mmc/core/sdio_ops.h     |   22 +
 drivers/mmc/host/Kconfig        |   30 +
 drivers/mmc/host/Makefile       |    2 +
 drivers/mmc/host/at91_mci.c     |   25 +-
 drivers/mmc/host/au1xmmc.c      |   58 +-
 drivers/mmc/host/imxmmc.c       |   32 +-
 drivers/mmc/host/mmc_spi.c      | 1408 +++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/mmci.c         |   20 +-
 drivers/mmc/host/omap.c         |   12 +-
 drivers/mmc/host/pxamci.c       |   71 ++-
 drivers/mmc/host/pxamci.h       |    2 +
 drivers/mmc/host/ricoh_mmc.c    |  151 +++++
 drivers/mmc/host/sdhci.c        |  127 +++--
 drivers/mmc/host/sdhci.h        |    2 +-
 drivers/mmc/host/tifm_sd.c      |   31 +-
 drivers/mmc/host/wbsd.c         |   43 +-
 include/asm-arm/arch-imx/mmc.h  |    5 +-
 include/linux/mmc/card.h        |   32 +
 include/linux/mmc/core.h        |   63 ++-
 include/linux/mmc/host.h        |   39 +-
 include/linux/mmc/mmc.h         |   39 +-
 include/linux/mmc/sdio.h        |  159 +++++
 include/linux/mmc/sdio_func.h   |  153 +++++
 include/linux/mmc/sdio_ids.h    |   23 +
 include/linux/mod_devicetable.h |   11 +
 include/linux/pci_ids.h         |    2 +
 include/linux/spi/mmc_spi.h     |   33 +
 scripts/mod/file2alias.c        |   20 +
 52 files changed, 6257 insertions(+), 430 deletions(-)

Adrian Bunk (1):
      make struct sdio_dev_attrs[] static

Bridge Wu (3):
      mmc: pxamci: better pending IRQ determination
      mmc: pxamci: set proper buswidth capabilities according to PXA flavor
      mmc: pxamci: add SDIO card interrupt reporting capability

David Brownell (4):
      MMC headers learn about SPI
      MMC/SD card driver learns SPI
      MMC core learns about SPI
      mmc_spi host driver

David Vrabel (4):
      sdio: add SDIO_FBR_BASE(f) macro
      sdio: set the functions' block size
      sdio: extend sdio_readsb() and friends to handle any length of buffer
      sdio: add sdio_f0_readb() and sdio_f0_writeb()

Feng Tang (2):
      sdhci: remove DMA capability check from controller's PCI Class reg
      sdhci: add SDHCI_QUIRK_BROKEN_DMA quirk

Marc Pignat (1):
      mmc: at91_mci: disable handling of blocks with size not multiple of 4 bytes

Mariusz Kozlowski (1):
      sdio: kmalloc + memset conversion to kzalloc

Nicolas Pitre (16):
      sdio: initial CIS parsing code
      sdio: link unknown CIS tuples to the sdio_func structure
      mmc: initialize mmc subsystem with subsys_initcall()
      sdio: defines for some standard interface types
      sdio: allow for mmc_claim_host to be aborted
      sdio: core support for SDIO function interrupt
      sdio: UART/GPS driver
      sdio: add /proc interface to sdio_uart driver
      sdio: add interface for host side SDIO interrupt reporting
      sdio: add default c_ispeed/c_ospeed values to sdio_uart driver
      sdio: fix recursion issues between sdio-uart driver and tty layer
      mmc: pxamci: set proper block capabilities according to PXA flavor
      sdhci: fix a typo
      sdio: fix IRQ diagnostic message
      sdio: make the IRQ thread more resilient in the presence of bad states
      pxamci: support arbitrary block size

Pavel Pisa (1):
      arm: i.MX/MX1 SDHC implements SD cards read-only switch read-back

Philip Langdale (1):
      mmc: Disabler for Ricoh MMC controller

Pierre Ossman (32):
      mmc: remove custom error codes
      mmc: improve error code feedback
      mmc: read ext_csd version number
      mmc: mmc_set_data_timeout() parameter write is redundant
      mmc: remove BYTEBLOCK capability
      mmc: remove confusing flag
      mmc: add missing printk levels
      mmc: detect SDIO cards
      mmc: implement SDIO IO_RW_DIRECT operation
      mmc: basic SDIO device model
      mmc: add SDIO driver handling
      mmc: add basic SDIO I/O operations
      mmc: enable/disable functions for SDIO
      sdio: read and decode interesting parts of the CCCR
      sdio: basic parsing of FBR
      sdio: split up common and function CIS parsing
      sdio: add device id table and matching
      mmc: whip bus uevent handler into shape
      sdio: add modalias support
      sdio: add basic sysfs attributes
      sdio: support IO_RW_EXTENDED
      sdio: change clock speed
      sdio: enable wide bus mode
      mmc: fix incorrect divisor in debug output
      mmc: fix sdio timeout calculation
      mmc: replace BUG_ON with WARN_ON
      sdhci: sdio interrupt support
      mmc: increase power up delay
      sdio: store vendor strings
      mmc: add led trigger
      sdio: adaptive interrupt polling
      sdhci: remove old dma module params

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
