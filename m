Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557Ab0ARRPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0ARRPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0ARRPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:15:08 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53275 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0ARRPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=CQ0UoPf9KNlqzLneOvXFnImGiqMzqiOmgvEKjT/PQho9wh6sLQvoP7C8jTooiqtbNA
         8zL1sdBTqtn9ML92PHkMyCWifU9ucn/95zGhh+KkA5bOn+FDKtFRpcCkOE7SqveDXDKz
         fW2urH/lvObwWR2MLLIeCP+AzXHBGlpgIYQSc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:13:49 +0100
Message-Id: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 00/64] more PATA fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is another set of PATA support improvements (on top of atang tree).

libata:
- fix handling of PIO timings for Compact Flash devices
- fix various issues for CMD64x chipsets
- fix secondary port support for Efar chipsets
- enable parallel scanning for ATi and Efar chipsets
- improve PIO performance for Cypress and VIA chipsets
- misc fixes/cleanups

IDE:
- fix timings calculations for ALi, CMD64x and Cypress chipsets
- add SATA cable detection support
- fix various issues for VIA chipsets
- add support for VIA VT6415, VT8261 and future chipsets
- fix pair device speed checking for chipsets that need it
- misc fixes/cleanups


The following changes since commit c527cc925f95a839583cd331f24445c6269446c0:
  Bartlomiej Zolnierkiewicz (1):
        add PATA host controller support for Cirrus Logic's EP93xx CPUs (v2)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v3.0

Bartlomiej Zolnierkiewicz (64):
      libata: fix CFA handling in ide_timing_compute()
      pata_ali: documentation fixes
      pata_ali: cleanup ali_set_piomode()
      pata_amd: remove bogus code from timing_setup()
      pata_atiixp: remove superfluous wrapper function
      pata_atiixp: add locking for parallel scanning
      pata_atiixp: enable parallel scan
      pata_cmd64x: fix PIO setup
      pata_cmd64x: fix handling of address setup timings
      pata_cmd64x: cmd648_bmdma_stop() fix
      pata_cmd64x: remove unused definitions
      pata_cs5520: convert to use ->init_host method
      pata_cs5535: use correct values for PIO1 and PIO2 data timings
      pata_cypress: fix PIO timings underclocking
      pata_efar: always program master_data before slave_data
      pata_efar: fix secondary port support
      pata_efar: add locking for parallel scanning
      pata_efar: enable parallel scan
      pata_serverworks: fix PIO setup for the second channel
      pata_serverworks: fix error message
      pata_serverworks: cleanup cable detection
      pata_via: fix address setup timings underlocking
      pata_via: store UDMA masks in via_isa_bridges table
      ide: fix for ide_timing quantisation errors
      ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
      alim15x3: fix PIO timings calculations
      alim15x3: add ali_fifo_control() helper
      alim15x3: remove superfluous locking from ali_set_pio_mode()
      alim15x3: cleanup ali_cable_detect()
      amd74xx: don't change UDMA settings when programming PIO timings
      cmd64x: fix PIO and MWDMA timings calculations
      cmd64x: remove superfluous checks from cmd64x_set_dma_mode()
      cy82c693: fix PIO timings calculations
      cy82c693: remove stale driver history
      opti621: remove stale driver history
      pdc202xx_old: add ->init_hwif method
      serverworks: cleanup svwks_udma_filter()
      serverworks: add missing pci_dev_put() call
      via82cxxx: vx855 is a single channel controller
      ide: add SATA cable detection support
      via82cxxx: fix SATA cable detection
      via82cxxx: workaround h/w bugs
      via82cxxx: add support for vt8261 and future chips
      via82cxxx: add support for VT6415 PCIE PATA IDE Host Controller
      via82cxxx: fix UDMA settings programming
      ide: add drive->pio_mode field
      ide: add drive->dma_mode field
      ide: change ->set_pio_mode method parameters
      ide: change ->set_dma_mode method parameters
      ide-timings: use ->pio_mode value to determine fastest PIO speed
      alim15x3: fix handling of address setup timings
      alim15x3: fix handling of command timings
      alim15x3: fix handling of DMA timings
      alim15x3: fix handling of UDMA enable bit
      amd74xx: use ->pio_mode value to determine pair device speed
      cmd64x: fix handling of address setup timings
      cs5535: use ->pio_mode value to determine pair device speed
      cs5536: use ->pio_mode value to determine pair device speed
      it821x: use ->pio_mode value to determine pair device speed
      palm_bk3710: use ->pio_mode value to determine pair device speed
      siimage: use ->pio_mode value to determine pair device speed
      tx493xide: use ->pio_mode value to determine pair device speed
      via82cxxx: use ->pio_mode value to determine pair device speed
      ide: make ide_get_best_pio_mode() static

 drivers/ata/libata-core.c      |   17 ++-
 drivers/ata/pata_ali.c         |   15 +--
 drivers/ata/pata_amd.c         |    5 -
 drivers/ata/pata_atiixp.c      |   58 +++++++-----
 drivers/ata/pata_cmd64x.c      |   26 +++---
 drivers/ata/pata_cs5520.c      |   55 +++++-------
 drivers/ata/pata_cs5535.c      |    2 +-
 drivers/ata/pata_cypress.c     |   10 +-
 drivers/ata/pata_efar.c        |   58 +++++++++---
 drivers/ata/pata_serverworks.c |   42 ++-------
 drivers/ata/pata_via.c         |  202 +++++++++++++++++++---------------------
 drivers/ide/aec62xx.c          |   13 ++-
 drivers/ide/ali14xx.c          |    3 +-
 drivers/ide/alim15x3.c         |  171 ++++++++++++++++++----------------
 drivers/ide/amd74xx.c          |   18 ++--
 drivers/ide/at91_ide.c         |    5 +-
 drivers/ide/atiixp.c           |   14 ++-
 drivers/ide/au1xxx-ide.c       |    9 +-
 drivers/ide/cmd640.c           |    3 +-
 drivers/ide/cmd64x.c           |  114 +++++++++--------------
 drivers/ide/cs5520.c           |    9 +-
 drivers/ide/cs5530.c           |   13 ++-
 drivers/ide/cs5535.c           |   14 ++--
 drivers/ide/cs5536.c           |   16 ++--
 drivers/ide/cy82c693.c         |  146 +++++------------------------
 drivers/ide/dtc2278.c          |    4 +-
 drivers/ide/hpt366.c           |    9 +-
 drivers/ide/ht6560b.c          |    3 +-
 drivers/ide/icside.c           |    3 +-
 drivers/ide/ide-devsets.c      |    6 +-
 drivers/ide/ide-iops.c         |    2 +-
 drivers/ide/ide-probe.c        |    2 +
 drivers/ide/ide-timings.c      |   22 +++--
 drivers/ide/ide-xfer-mode.c    |   18 ++--
 drivers/ide/it8172.c           |   14 ++--
 drivers/ide/it8213.c           |   20 ++--
 drivers/ide/it821x.c           |   14 ++-
 drivers/ide/jmicron.c          |    6 +-
 drivers/ide/opti621.c          |   77 +---------------
 drivers/ide/palm_bk3710.c      |   12 ++-
 drivers/ide/pdc202xx_new.c     |    8 +-
 drivers/ide/pdc202xx_old.c     |   27 +++---
 drivers/ide/piix.c             |   20 ++--
 drivers/ide/pmac.c             |    9 +-
 drivers/ide/qd65xx.c           |   10 +-
 drivers/ide/sc1200.c           |    8 +-
 drivers/ide/scc_pata.c         |   12 +-
 drivers/ide/serverworks.c      |   50 ++++-------
 drivers/ide/sgiioc4.c          |    2 +-
 drivers/ide/siimage.c          |   14 ++--
 drivers/ide/sis5513.c          |    8 +-
 drivers/ide/sl82c105.c         |    8 +-
 drivers/ide/slc90e66.c         |   17 ++--
 drivers/ide/tc86c001.c         |    9 +-
 drivers/ide/triflex.c          |   10 +-
 drivers/ide/tx4938ide.c        |    7 +-
 drivers/ide/tx4939ide.c        |   10 +-
 drivers/ide/umc8672.c          |    5 +-
 drivers/ide/via82cxxx.c        |  132 +++++++++++++++++++++-----
 include/linux/ide.h            |    7 +-
 60 files changed, 768 insertions(+), 855 deletions(-)
