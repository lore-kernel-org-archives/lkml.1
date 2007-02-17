Return-Path: <linux-kernel-owner+w=401wt.eu-S1946369AbXBQCT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946369AbXBQCT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946360AbXBQCT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:19:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:4160 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946313AbXBQCT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:19:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=APr0rNk1DRQbAZQRhel9ZiFdqN7s6dz5ejBEfEviF8D/FZjIkp8yQr1Sbb+ot3CXHv0kln8MQI08tCcBAZEctmQNwspY4bW/ydlNjsJeJ0U8qS5mcbgRBTeM3JfsAaosZc/qrKVvuMNMgaAkpoGFAWPbIqoVeutgzItgvh7NJpc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] more IDE updates
Date: Sat, 17 Feb 2007 03:25:02 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702170325.02337.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Contains: IRQ-ack fix for ICH chipsets (Albert Lee), ide-floppy unformatted
media fix (Alan Cox), more fixes for IDE PCI drivers (Sergei Shtylyov),
new driver for Toshiba Cell Reference Board (Kou Ishizaki <kou.ishizaki
at toshiba.co.jp>) and a bunch of rather obvious cleanups/improvements (me).

There are still some bugfix patches in my tree which should go into 2.6.21
but since they are quite fresh and there have already been a lot of IDE
changes since the merge window was opened I will wait for -rc1 to push
them upstream.

[ Andrew, IDE quilt tree has already been updated wrt to this update ]

Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |    8 
 drivers/ide/Makefile           |    1 
 drivers/ide/arm/icside.c       |   25 -
 drivers/ide/arm/rapide.c       |    2 
 drivers/ide/cris/ide-cris.c    |   34 -
 drivers/ide/h8300/ide-h8300.c  |    4 
 drivers/ide/ide-cd.c           |   44 --
 drivers/ide/ide-disk.c         |   14 
 drivers/ide/ide-dma.c          |  105 +++--
 drivers/ide/ide-floppy.c       |   29 -
 drivers/ide/ide-io.c           |   15 
 drivers/ide/ide-iops.c         |   34 -
 drivers/ide/ide-lib.c          |   20 
 drivers/ide/ide-probe.c        |    4 
 drivers/ide/ide-tape.c         |   12 
 drivers/ide/ide.c              |   24 -
 drivers/ide/legacy/buddha.c    |    2 
 drivers/ide/legacy/gayle.c     |    2 
 drivers/ide/legacy/ht6560b.c   |   14 
 drivers/ide/legacy/macide.c    |    2 
 drivers/ide/legacy/q40ide.c    |    2 
 drivers/ide/mips/au1xxx-ide.c  |   41 --
 drivers/ide/mips/swarm.c       |    2 
 drivers/ide/pci/aec62xx.c      |   32 -
 drivers/ide/pci/alim15x3.c     |   15 
 drivers/ide/pci/amd74xx.c      |    5 
 drivers/ide/pci/atiixp.c       |   41 --
 drivers/ide/pci/cmd64x.c       |   47 --
 drivers/ide/pci/cs5520.c       |    5 
 drivers/ide/pci/cs5530.c       |   41 --
 drivers/ide/pci/cs5535.c       |   19 
 drivers/ide/pci/cy82c693.c     |   33 -
 drivers/ide/pci/hpt34x.c       |   42 --
 drivers/ide/pci/hpt366.c       |   24 -
 drivers/ide/pci/it8213.c       |   14 
 drivers/ide/pci/it821x.c       |   14 
 drivers/ide/pci/jmicron.c      |   14 
 drivers/ide/pci/ns87415.c      |   13 
 drivers/ide/pci/opti621.c      |   63 +--
 drivers/ide/pci/pdc202xx_new.c |   28 -
 drivers/ide/pci/pdc202xx_old.c |  104 +----
 drivers/ide/pci/piix.c         |  119 +++--
 drivers/ide/pci/sc1200.c       |   11 
 drivers/ide/pci/serverworks.c  |   59 --
 drivers/ide/pci/sgiioc4.c      |  125 ++----
 drivers/ide/pci/siimage.c      |  113 ++---
 drivers/ide/pci/sis5513.c      |   59 --
 drivers/ide/pci/sl82c105.c     |   39 -
 drivers/ide/pci/slc90e66.c     |   22 -
 drivers/ide/pci/tc86c001.c     |   46 --
 drivers/ide/pci/triflex.c      |   24 -
 drivers/ide/pci/trm290.c       |   42 --
 drivers/ide/pci/via82cxxx.c    |    5 
 drivers/ide/ppc/pmac.c         |   16 
 drivers/ide/ppc/scc_pata.c     |  831 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ide-scsi.c        |    8 
 include/linux/ide.h            |   28 -
 57 files changed, 1523 insertions(+), 1018 deletions(-)

Alan Cox (1):
      ide-floppy: Fix unformatted media crash

Albert Lee (2):
      ide: clear bmdma status in ide_intr() for ICHx controllers (revised #4)
      ide: remove clearing bmdma status from cdrom_decode_status() (rev #4)

Bartlomiej Zolnierkiewicz (23):
      hpt34x: hpt34x_tune_chipset() (->speedproc) fix
      atiixp/jmicron/triflex: fix PIO fallback
      pdc202xx_old: remove dead code
      au1xxx-ide: remove dead code
      trm290: remove redundant CONFIG_BLK_DEV_IDEDMA #ifdef-s
      hpt366: remove redundant check from init_dma_hpt366()
      cs5530: small cleanup
      svwks: small cleanup
      piix: cleanup
      sis5513: sis5513_config_xfer_rate() cleanup
      ide: remove write-only ide_pio_data_t.blacklisted
      ide: remove write-only ide_hwif_t.no_dsc flag
      ide: remove ide_pci_device_t tables with only one entry
      ide: remove ide_drive_t.usage
      ide: unexport ide_set_xfer_rate() (v2)
      ide: add ide_use_fast_pio() helper (v3)
      ide: use PIO/MMIO operations directly where possible (v2)
      ide: convert ide_hwif_t.mmio into flag (v2)
      ide: disable DMA in ->ide_dma_check for "no IORDY" case (v2)
      sgiioc4: fix sgiioc4_ide_dma_check() to enable/disable DMA properly
      ide: add ide_set_dma() helper (v2)
      ide: make ide_hwif_t.ide_dma_{host_off,off_quietly} void (v2)
      ide: make ide_hwif_t.ide_dma_host_on void (v2)

Kou Ishizaki (1):
      drivers/ide: PATA driver for Celleb

Sergei Shtylyov (3):
      siimage: PIO1/2 taskfile transfer overclocking fix
      pdc202xx_old: fix PIO mode setup
      sl82c105: DMA support fixes

...and once again patch is too big for the mailing list
