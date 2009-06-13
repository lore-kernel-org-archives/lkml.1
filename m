Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbZFMVDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbZFMVDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932557AbZFMVDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:03:07 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36599 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550AbZFMVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:03:06 -0400
Date: Sat, 13 Jun 2009 23:02:59 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@openedhand.com>
Subject: [GIT PULL] MMC updates for 2.6.31-rc1
Message-ID: <20090613230259.387dfe4d@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29752-1244926986-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29752-1244926986-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive:

	- A new host driver for the ENE CB710 proprietary interface

	- A platform interface for sdhci. There are no users of this
	  interface yet, but they are on the way.

	- Initial merging work of atmel-mci and at91_mci

	- A whole bunch of fixes for the recently added tmio_mmc driver

	- The ability for the MMC layer to detect a removal and insertion
	  in one detection pass (needed on systems which use a "cover"
	  approach like Nokia 770/810/etc.)

and a whole bunch of other minor bug fixes.

There will (hopefully) be another pull for the MMC stuff during this
merge window with two more drivers, one for a new Via chip and one for
Samsung's newer SoCs.

 MAINTAINERS                       |    9 +
 drivers/mfd/t7l66xb.c             |    5 +
 drivers/mfd/tc6387xb.c            |    5 +
 drivers/mfd/tc6393xb.c            |    5 +
 drivers/misc/Kconfig              |    1 +
 drivers/misc/Makefile             |    1 +
 drivers/misc/cb710/Kconfig        |   25 ++
 drivers/misc/cb710/Makefile       |    8 +
 drivers/misc/cb710/core.c         |  357 ++++++++++++++++
 drivers/misc/cb710/debug.c        |  119 ++++++
 drivers/misc/cb710/sgbuf2.c       |  150 +++++++
 drivers/mmc/card/block.c          |   16 +-
 drivers/mmc/core/core.c           |  107 +++--
 drivers/mmc/host/Kconfig          |   28 ++-
 drivers/mmc/host/Makefile         |    5 +
 drivers/mmc/host/atmel-mci-regs.h |   33 ++
 drivers/mmc/host/cb710-mmc.c      |  804 +++++++++++++++++++++++++++++++++=
++++
 drivers/mmc/host/cb710-mmc.h      |  104 +++++
 drivers/mmc/host/mmc_spi.c        |   23 +-
 drivers/mmc/host/mxcmmc.c         |    2 -
 drivers/mmc/host/omap.c           |    3 +-
 drivers/mmc/host/pxamci.c         |   46 ++-
 drivers/mmc/host/sdhci-pltfm.c    |  168 ++++++++
 drivers/mmc/host/sdhci.c          |   58 ++--
 drivers/mmc/host/sdhci.h          |    2 +-
 drivers/mmc/host/tmio_mmc.c       |  180 ++++-----
 drivers/mmc/host/tmio_mmc.h       |   77 ++++-
 include/linux/cb710.h             |  231 +++++++++++
 include/linux/mfd/tmio.h          |    7 +
 include/linux/pci_ids.h           |    1 +
 30 files changed, 2377 insertions(+), 203 deletions(-)
 create mode 100644 drivers/misc/cb710/Kconfig
 create mode 100644 drivers/misc/cb710/Makefile
 create mode 100644 drivers/misc/cb710/core.c
 create mode 100644 drivers/misc/cb710/debug.c
 create mode 100644 drivers/misc/cb710/sgbuf2.c
 create mode 100644 drivers/mmc/host/cb710-mmc.c
 create mode 100644 drivers/mmc/host/cb710-mmc.h
 create mode 100644 drivers/mmc/host/sdhci-pltfm.c
 create mode 100644 include/linux/cb710.h

Ben Dooks (2):
      sdhci: Print ADMA status and pointer on debug
      mmc_block: do not DMA to stack

Daniel Ribeiro (1):
      pxamci: add regulator support.

Ian Molton (1):
      tmio_mmc: fix clock setup

Jorg Schummer (1):
      mmc: mmc_rescan detects card change in one run

Micha=C5=82 Miros=C5=82aw (2):
      mmc: Driver for CB710/720 memory card reader (MMC part)
      cb710: more cleanup for the DEBUG case.

Nicolas Ferre (2):
      atmel-mci: Integrate AT91 specific definition in header file
      atmel-mci: add MCI2 register definitions

Philipp Zabel (6):
      MFD,mmc: tmio_mmc: make HCLK configurable
      tmio_mmc: add bus_shift support
      tmio_mmc: don't use set_irq_type
      tmio_mmc: correct probe return value for num_resources !=3D 3
      tmio_mmc: map SD control registers after enabling the MFD cell
      tmio_mmc: allow compilation for ASIC3

Pierre Ossman (5):
      sdhci: avoid changing voltage needlessly
      cb710: fix printk format string
      cb710: add missing parenthesis
      cb710: handle DEBUG define in Makefile
      mxcmmc: remove frequency workaround

Richard R=C3=B6jfors (1):
      sdhci: platform driver for SDHCI

Sascha Hauer (1):
      MMC core: limit minimum initialization frequency to 400kHz

Uwe Kleine-K=C3=B6nig (1):
      mmc/omap: make mmci-omap using platform_driver_probe

Wolfgang Muees (2):
      mmc_spi: speedup for slow cards, less wear-out
      mmc_spi: don't use EINVAL for possible transmission errors



--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-29752-1244926986-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko0FAkACgkQ7b8eESbyJLjJWgCglz5yHK6A/EYY0xeaS/uqHP4o
uZkAn2M5cN149HWePkgmvua7kWqAKbuk
=ymeI
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29752-1244926986-0001-2--
