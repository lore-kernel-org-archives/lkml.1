Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZCXUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZCXUqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZCXUqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:46:47 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40259 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZCXUqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:46:46 -0400
Date: Tue, 24 Mar 2009 21:46:37 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates for 2.6.30-rc1
Message-ID: <20090324214637.18a0523d@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-19228-1237927600-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-19228-1237927600-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive two new MMC host drivers and a bucket load of fixes for the
others. Particularly mmc_spi has gotten a lot of attention and now
contains a lot of workarounds for buggy cards.

 MAINTAINERS                               |   20 +-
 arch/arm/plat-orion/include/plat/mvsdio.h |   21 +
 drivers/mmc/card/block.c                  |    2 +
 drivers/mmc/core/bus.c                    |    8 +
 drivers/mmc/core/core.c                   |   18 +
 drivers/mmc/core/debugfs.c                |   67 +++
 drivers/mmc/core/sdio_cis.c               |    8 +
 drivers/mmc/core/sdio_ops.c               |    8 +
 drivers/mmc/host/Kconfig                  |   29 +
 drivers/mmc/host/Makefile                 |    2 +
 drivers/mmc/host/atmel-mci.c              |    4 +-
 drivers/mmc/host/mmc_spi.c                |   40 ++-
 drivers/mmc/host/mvsdio.c                 |  885 +++++++++++++++++++++++++=
++++
 drivers/mmc/host/mvsdio.h                 |  190 ++++++
 drivers/mmc/host/of_mmc_spi.c             |    2 +-
 drivers/mmc/host/omap_hsmmc.c             |  355 +++++++-----
 drivers/mmc/host/sdhci-of.c               |  309 ++++++++++
 drivers/mmc/host/sdhci.c                  |  317 +++++++----
 drivers/mmc/host/sdhci.h                  |  112 ++++
 drivers/mmc/host/tmio_mmc.c               |    6 +-
 drivers/mmc/host/tmio_mmc.h               |    3 +
 21 files changed, 2132 insertions(+), 274 deletions(-)
 create mode 100644 arch/arm/plat-orion/include/plat/mvsdio.h
 create mode 100644 drivers/mmc/host/mvsdio.c
 create mode 100644 drivers/mmc/host/mvsdio.h
 create mode 100644 drivers/mmc/host/sdhci-of.c

Adrian Hunter (6):
      mmc: Add Extended CSD register to debugfs
      omap_hsmmc: do not re-power when powering off MMC
      omap_hsmmc: Fix response type for busy after response
      omap_hsmmc: Allow cover switch to cause rescan
      omap_hsmmc: Do not prefix slot name
      omap_hsmmc: Wait for SDBP

Alexander Beregalov (1):
      MMC: tmio_mmc.h: fix build problem

Andy Whitcroft (1):
      mmc: add MODALIAS linkage for MMC/SD devices

Anton Vorontsov (10):
      sdhci: Add support for bus-specific IO memory accessors
      sdhci: Split card-detection IRQs management from sdhci_init()
      sdhci: Enable only relevant (DMA/PIO) interrupts during transfers
      sdhci: Add support for card-detection polling
      sdhci: Add support for hosts reporting inverted write-protect state
      sdhci: Add set_clock callback and a quirk for nonstandard clocks
      sdhci: Add quirk for controllers that need small delays for PIO
      sdhci: Add quirk for controllers that need IRQ re-init after reset
      sdhci: Add quirk for forcing maximum block size to 2048 bytes
      mmc: Add OpenFirmware bindings for SDHCI driver

Balaji Rao (1):
      mmc: During unsafe resume, select the right volatge for the card

Ben Dooks (1):
      sdhci: Add get_{max,timeout}_clock callbacks

Grazvydas Ignotas (1):
      omap_hsmmc: Fix MMC3 dma

Hans-Christian Egtvedt (1):
      atmel-mci: fix sdc_reg typo

Jarkko Lavinen (3):
      omap_hsmmc: Do dma cleanup also with data CRC errors
      omap_hsmmc: Add 8-bit bus width mode support
      omap_hsmmc: Disable SDBP at suspend

Jorg Schummer (1):
      mmc: delayed_work was never cancelled

Juha Yrjola (1):
      omap_hsmmc: Implement scatter-gather emulation

Kay Sievers (1):
      mmc: struct device - replace bus_id with dev_name(), dev_set_name()

Kim Kyuwon (1):
      omap_hsmmc: Initialize hsmmc controller registers when resuming

Maen Suleiman (1):
      mmc: SDIO driver for Marvell SoCs

Magnus Damm (2):
      tmio_mmc: Fix one off, use resource_size() in probe()
      tmio_mmc: Fix use after free in remove()

Pierre Ossman (6):
      sdio: handle cis end marker in link field
      sdio: handle null tuples
      sdio: check that addresses are within the address space
      sdhci: change list address
      mmc: add maintainer for mvsdio driver
      tmio_mmc: add maintainer

Wolfgang Muees (4):
      mmc_spi: allow setting of spi mode 3
      mmc_spi: wait more bytes for card response
      mmc_spi: allow higher timeouts for SPI mode
      mmc_spi: adjust for delayed data token response


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-19228-1237927600-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJRrEACgkQ7b8eESbyJLiE9wCgsGqlWTelvzsD0Z9mBhD+iHFe
3kwAoN3EQHzkk3TXBlfa+wjDSdPBBzO9
=fTLD
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-19228-1237927600-0001-2--
