Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYGOOEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYGOOEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYGOOEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:04:47 -0400
Received: from server.drzeus.cx ([85.8.24.28]:35987 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbYGOOEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:04:46 -0400
Date: Tue, 15 Jul 2008 16:04:36 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates for 2.6.26
Message-ID: <20080715160436.0f6ac19e@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-17110-1216130681-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-17110-1216130681-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 MAINTAINERS                               |   17 +-
 arch/avr32/boards/atngw100/setup.c        |    7 +
 arch/avr32/boards/atstk1000/atstk1002.c   |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c       |   30 +-
 drivers/mmc/card/block.c                  |   60 +-
 drivers/mmc/card/mmc_test.c               |  569 ++++++++----
 drivers/mmc/card/sdio_uart.c              |    9 +-
 drivers/mmc/core/core.c                   |   41 +-
 drivers/mmc/core/mmc.c                    |    2 +-
 drivers/mmc/core/sd.c                     |    6 +-
 drivers/mmc/core/sdio_cis.c               |    6 +
 drivers/mmc/core/sdio_io.c                |  167 +++-
 drivers/mmc/host/Kconfig                  |   50 +-
 drivers/mmc/host/Makefile                 |    4 +
 drivers/mmc/host/at91_mci.c               |  257 ++++-
 drivers/mmc/host/atmel-mci-regs.h         |   91 ++
 drivers/mmc/host/atmel-mci.c              |  981 +++++++++++++++++++
 drivers/mmc/host/au1xmmc.c                |  792 ++++++++++-------
 drivers/mmc/host/au1xmmc.h                |   96 --
 drivers/mmc/host/imxmmc.c                 |    9 +-
 drivers/mmc/host/mmc_spi.c                |   33 +-
 drivers/mmc/host/mmci.c                   |    1 -
 drivers/mmc/host/omap.c                   |    2 +-
 drivers/mmc/host/pxamci.c                 |    9 +-
 drivers/mmc/host/s3cmci.c                 | 1446 +++++++++++++++++++++++++=
++++
 drivers/mmc/host/s3cmci.h                 |   70 ++
 drivers/mmc/host/sdhci-pci.c              |  732 +++++++++++++++
 drivers/mmc/host/sdhci.c                  |  994 +++++++++++---------
 drivers/mmc/host/sdhci.h                  |  120 ++-
 drivers/mmc/host/sdricoh_cs.c             |  575 ++++++++++++
 drivers/mmc/host/tifm_sd.c                |    2 +-
 drivers/mmc/host/wbsd.c                   |   38 +-
 drivers/net/wireless/libertas/if_sdio.c   |   20 +-
 include/asm-arm/arch-at91/at91_mci.h      |    4 +
 include/asm-arm/arch-s3c2410/regs-sdi.h   |   20 +-
 include/asm-arm/plat-s3c24xx/mci.h        |   15 +
 include/asm-avr32/arch-at32ap/board.h     |    6 +-
 include/asm-avr32/atmel-mci.h             |    9 +
 include/asm-mips/mach-au1x00/au1100_mmc.h |   16 +-
 include/linux/mmc/core.h                  |    1 +
 include/linux/mmc/host.h                  |   32 +-
 include/linux/mmc/mmc.h                   |    1 -
 include/linux/mmc/sdio_func.h             |   21 +-
 include/linux/pci_ids.h                   |    1 +
 include/linux/spi/mmc_spi.h               |    9 +
 45 files changed, 6054 insertions(+), 1320 deletions(-)

Adrian Bunk (1):
      include/linux/mmc/mmc.h: remove CVS tags

Andres Salomon (1):
      mmc: OLPC: update vdd/powerup quirk comment

Anton Vorontsov (3):
      mmc: add support for card-detection polling
      mmc_spi: add support for card-detection polling
      mmc: change .get_ro() callback semantics

Ben Dooks (11):
      MMC: S3C24XX: Add platform data for MMC/SD driver
      MMC: S3C24XX: Add support to invert write protect line
      MMC: S3C24XX: Ensure host->mrq->data is valid
      MMC: S3C24XX: Allow card-detect on non-IRQ capable pin
      MMC: S3C24XX: Fix s3c2410_dma_request() return code check.
      MMC: S3C24XX: Add MODULE_ALIAS() entries for the platform devices
      MMC: S3C24XX: Fix use of msecs where jiffies are needed
      MMC: S3C24XX: Add media presence test to request handling.
      MMC: S3C24XX: Update error debugging.
      MMC: S3C24XX: Add maintainer entry
      MMC: S3C24XX: Refuse incorrectly aligned transfers

Benzi Zbit (1):
      sdio: fix the use of hard coded timeout value.

David Howells (1):
      sdio_uart: Fix SDIO break control to now return success or an error

Deepak Saxena (1):
      MMC: Trivial comment cleanup

Eric Benard (1):
      mmc: at91_mci: add sdio irq management

Haavard Skinnemoen (1):
      atmel-mci: Driver for Atmel on-chip MMC controllers

Harald Welte (2):
      MMC: S3C24XX MMC/SD driver write fixes
      MMC: DMA free fix for S3C24XX SD/MMC driver

Manuel Lauss (7):
      au1xmmc: remove db1200 board code, rewrite probe.
      au1xmmc: enable 4 bit transfer mode
      au1xmmc: SDIO IRQ support.
      au1xmmc: codingstyle tidying.
      au1xmmc: abort requests early if no card is present.
      au1xmmc: new maintainer.
      au1xmmc: remove custom carddetect poll implementation.

Marc Pignat (3):
      mmc: at91_mci: support for block size not modulo 4
      mmc: at91_mci: show timeouts
      mmc: at91_mci: avoid timeouts

Nicolas Ferre (4):
      mmc: at91_mci: update bytes_xfered value once xfer done
      mmc: at91_mci: add multiwrite switch
      mmc: at91_mci: do not read irq status twice as it will forget some er=
rors
      at91_mci: manage cmd error and data error independently

Pierre Ossman (20):
      sdhci: don't check block count for progress
      sdhci: move pci stuff to separate module
      sdhci: remove forced dma quirks
      sdhci: more complex quirks handling
      sdhci: make workaround for timeout bug more general
      sdhci: toggle JMicron PMOS setting
      sdhci: support JMicron secondary interface
      sdhci: handle hot-remove
      mmc_test: add test case control
      sdhci-pci: unaligned data with ricoh controllers
      mmc,sdio: helper function for transfer padding
      sdio: clean up handling of byte mode transfer size
      mmc_test: only bind to supported cards
      sdhci-pci: don't penalize newer jmicron chips
      sdhci: scatter-gather (ADMA) support
      mmc_block: wait for card even on failures
      mmc_test: cleanup
      sdhci: graceful handling of bad addresses
      wbsd: fix bad dma_addr_t conversion
      mmc: remove multiwrite capability

Roman Moracik (1):
      MMC: Fix S3C24XX IRQ enable during PIO transfers

Sascha Sommer (1):
      mmc: host driver for Ricoh Bay1Controllers

Thomas Kleffel (2):
      MMC: S3C24XX MMC/SD driver.
      Fix the request finalisation by ensuring the controller

Tomas Winkler (4):
      mmc: wbsd.c fix shadowing of 'dma' variable
      mmc: fix sdio_io sparse errors
      mmc: fix spares errors of sdhci.c
      sdio: sdio_io.c Fix sparse warnings

Ville Syrjala (3):
      at91_mci: AT91SAM9260/9263 12 byte write erratum (v2)
      at91_mci: Cover more AT91RM9200 and AT91SAM9261 errata.
      at91_mci: Fix byte mode transitions.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-17110-1216130681-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkh8rncACgkQ7b8eESbyJLiSlwCfQjL6m3OMS0pgsu8sq5IACiEm
WNUAoJ0CCtdDcMG9adLfg1m35pF64boh
=5yIX
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-17110-1216130681-0001-2--
