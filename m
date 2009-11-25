Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbZKYRC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbZKYRC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZKYRC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:02:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZKYRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=bbatAFx3/GD4ANry1SlK75FlGuGOcCsjYIEsN8E6MWbuaeA0vwRgjWuqMZvip5nxWf
         Xuf8CGGItSS9vZAk/nIIYHPa0HKE+oCY4QMWSq+wbmeTlcsjnRv/J/c7lW9XwomuaB1x
         1ANRE9+SksYAQNRZrTZXiEWIbhYG/ounOMjI8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:02:18 +0100
Message-Id: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 00/86] PATA fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've been going through PATA drivers for the last few days to make
sure that we offer similar level of hardware support in the new PATA
drivers as with the old IDE subsystem and the following patchset is
the end result of said audit.


Inside:

- many bugfixes

  ( ata_piix, pata_artop, pata_atiixp, pata_efar, pata_cmd64x,
    pata_hpt3x3, pata_it8213, pata_legacy, pata_ns87415, pata_sis,
    pata_radisys, pata_rz1000 & pata_via )

- add Power Management support for more controllers

  ( pata_artop, pata_pdc2027x, pata_sl82c105 )

- add 32-bit PIO support for more controllers

  ( pata_artop, pata_atiixp, pata_efar, pata_cmd64x, pata_cs5520,
    pata_cs5530, pata_cs5535, pata_cypress, pata_hpt366, pata_hpt37x,
    pata_hpt3x2n, pata_it8213, pata_it821x, pata_jmicron, pata_ns87415,
    pata_opti, pata_pdc2027x, pata_pdc202xx_old, pata_rz1000,
    pata_sc1200, pata_scc, pata_sch, pata_serverworks, pata_sl82c105,
    pata_sis, pata_triflex & pata_via )

- fix QDI65x0 support in pata_legacy driver so pata_qdi driver can
  be finally removed

- remove pata_qdi and pata_winbond drivers resulting in 600 LOC gone

  (affected hardware is fully supported by pata_legacy driver now)

- unify code for programming PIO and MWDMA timings for 'PIIX-like'
  controllers resulting in 200 LOC gone

  ( ata_piix, pata_efar, pata_it8213, pata_oldpiix, pata_radisys &
    pata_rdc )

- add ->init_host method for abstracting host specific controller
  initialization and then use it to cleanup Power Managment code
  resulting in over 100 LOC gone

  ( pata_ali, pata_amd, pata_artop, pata_cmd640, pata_cmd64x,
    pata_cs5530, pata_hpt366, pata_hpt3x3, pata_it821x, pata_ninja32,
    pata_ns87415, pata_pdc2027x & sata_sil )

- misc fixes and cleanups


The following changes since commit 5c0e519edce8aa5c517e3b3e9a1fdf6fa0f3cf83:
  Christoph Hellwig (1):
        libata: add translation for SCSI WRITE SAME (aka TRIM support)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v1

Bartlomiej Zolnierkiewicz (86):
      ata_piix: fix MWDMA handling on PIIX3
      ata_piix: unify code for programming PIO and MWDMA timings
      pata_artop: add 32-bit PIO support
      pata_artop: fix chipsets naming
      pata_artop: add Power Management support
      pata_artop: unify ->prereset methods
      pata_artop: remove dead 34MHz PCI clock support
      pata_atiixp: add 32-bit PIO support
      pata_atiixp: no need to program PIO timings for MWDMA
      pata_atiixp: add MWDMA0 support
      pata_atiixp: remove custom BMDMA methods
      pata_atiixp: add proper ->prereset method
      pata_efar: add 32-bit PIO support
      pata_efar: fix wrong PIO timings being programmed
      pata_efar: fix wrong MWDMA timings being programmed
      pata_efar: MWDMA0 is unsupported
      pata_efar: fix register naming used in efar_set_piomode()
      pata_efar: unify code for programming PIO and MWDMA timings
      pata_cmd640: document known issues
      pata_cmd64x: add 32-bit PIO support
      pata_cmd64x: add enablebits checking
      pata_cmd64x: add cmd64x_fixup()
      pata_cs5520: add 32-bit PIO support
      pata_cs5520: remove dead VDMA support
      pata_cs5530: add 32-bit PIO support
      pata_cs5535: add 32-bit PIO support
      pata_cs5535: no need to program PIO0 timings during device init
      pata_cypress: add 32-bit PIO support
      pata_cypress: document known issues
      pata_hpt366: add 32-bit PIO support
      pata_hpt37x: add 32-bit PIO support
      pata_hpt3x2n: add 32-bit PIO support
      pata_hpt3x3: Power Management fix
      pata_it8213: add 32-bit PIO support
      pata_it8213: fix UDMA handling
      pata_it8213: add UDMA100 and UDMA133 support
      pata_it8213: fix wrong PIO timings being programmed
      pata_it8213: fix PIO2 underclocking
      pata_it8213: fix wrong MWDMA timings being programmed
      pata_it8213: fix register naming used in it8213_set_piomode()
      pata_efar: unify code for programming PIO and MWDMA timings
      pata_it8213: fix it8213_pre_reset() documentation
      pata_it821x: add 32-bit PIO support
      pata_jmicron: add 32-bit PIO support
      pata_legacy: do not probe extra ports automatically if PCI is not present
      pata_legacy: fix QDI6580DP support
      pata_legacy: fix access to control register for QDI6580
      pata_legacy: add pointers to QDI65x0 documentation
      pata_legacy: unify QDI ->set_piomode methods
      pata_legacy: use PIO mask defines
      libata: remove no longer needed pata_qdi driver
      libata: remove no longer needed pata_winbond driver
      pata_marvell: fix marvell_pre_reset() documentation
      pata_ns87415: add 32-bit PIO support
      pata_ns87415: Power Management fix
      pata_oldpiix: unify code for programming PIO and MWDMA timings
      pata_opti: add 32-bit PIO support
      pata_pdc2027x: add 32-bit PIO support
      pata_pdc2027x: add Power Management support
      pata_pdc202xx_old: add 32-bit PIO support
      pata_sis: Power Management fix
      pata_pdc202xx_old: document known issues
      pata_radisys: fix UDMA handling
      pata_radisys: unify code for programming PIO and MWDMA timings
      pata_rdc: unify code for programming PIO and MWDMA timings
      pata_rz1000: add 32-bit PIO support
      pata_rz1000: Power Management fix
      pata_sc1200: add 32-bit PIO support
      pata_scc: add 32-bit PIO support
      pata_scc: add proper cable detection method
      pata_sch: add 32-bit PIO support
      pata_serverworks: add 32-bit PIO support
      pata_serverworks: use standard cable detection methods
      pata_serverworks: add serverworks_fixup()
      pata_sl82c105: add 32-bit PIO support
      pata_sl82c105: add Power Management support
      pata_sis: add 32-bit PIO support
      pata_sis: Power Management fix
      pata_triflex: add 32-bit PIO support
      libata: make ata_sff_data_xfer_noirq() work with 32-bit PIO
      pata_via: add 32-bit PIO support
      pata_via: clear UDMA transfer mode bit for PIO and MWDMA
      pata_via: add via_fixup()
      libata: add ata_mwdma_to_pio() inline helper
      libata: add ->init_host method
      libata: add private driver field to struct ata_device

 drivers/ata/Kconfig             |   16 ++-
 drivers/ata/Makefile            |    2 -
 drivers/ata/ata_piix.c          |  113 ++++---------
 drivers/ata/libata-core.c       |   14 ++-
 drivers/ata/libata-sff.c        |   12 +-
 drivers/ata/pata_ali.c          |   29 +--
 drivers/ata/pata_amd.c          |   45 ++---
 drivers/ata/pata_artop.c        |  224 ++++++++++++-------------
 drivers/ata/pata_atiixp.c       |  112 ++++---------
 drivers/ata/pata_cmd640.c       |   27 +--
 drivers/ata/pata_cmd64x.c       |  100 +++++++-----
 drivers/ata/pata_cs5520.c       |   41 +----
 drivers/ata/pata_cs5530.c       |   33 +---
 drivers/ata/pata_cs5535.c       |   14 +--
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |  121 +++++---------
 drivers/ata/pata_hpt366.c       |   32 ++---
 drivers/ata/pata_hpt37x.c       |    4 +-
 drivers/ata/pata_hpt3x2n.c      |    2 +-
 drivers/ata/pata_hpt3x3.c       |   23 ++--
 drivers/ata/pata_it8213.c       |  136 ++++++---------
 drivers/ata/pata_it821x.c       |   39 ++---
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_legacy.c       |  156 +++++++----------
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_ninja32.c      |   30 ++--
 drivers/ata/pata_ns87415.c      |   22 ++-
 drivers/ata/pata_oldpiix.c      |   95 +++-------
 drivers/ata/pata_opti.c         |    2 +
 drivers/ata/pata_pdc2027x.c     |   24 ++-
 drivers/ata/pata_pdc202xx_old.c |   37 ++++-
 drivers/ata/pata_qdi.c          |  366 ---------------------------------------
 drivers/ata/pata_radisys.c      |   78 +++------
 drivers/ata/pata_rdc.c          |  106 ++++--------
 drivers/ata/pata_rz1000.c       |   13 ++-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_scc.c          |   16 +--
 drivers/ata/pata_sch.c          |    2 +-
 drivers/ata/pata_serverworks.c  |  104 +++++-------
 drivers/ata/pata_sis.c          |   25 +++-
 drivers/ata/pata_sl82c105.c     |   28 +++-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |   74 ++++----
 drivers/ata/pata_winbond.c      |  282 ------------------------------
 drivers/ata/sata_sil.c          |   33 +---
 include/linux/ata.h             |   11 ++
 include/linux/libata.h          |   15 ++-
 47 files changed, 854 insertions(+), 1814 deletions(-)
 delete mode 100644 drivers/ata/pata_qdi.c
 delete mode 100644 drivers/ata/pata_winbond.c
