Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZLCXIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZLCXIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZLCXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:08:51 -0500
Received: from havoc.gtf.org ([69.61.125.42]:36434 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZLCXIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:08:50 -0500
Date: Thu, 3 Dec 2009 18:08:56 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: What's in libata-dev.git? (v2)
Message-ID: <20091203230856.GA20980@havoc.gtf.org>
References: <20091203075653.GA30612@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203075653.GA30612@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the contents of the recently-rebased "upstream" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

This is what will get sent RSN for 2.6.33.

v2: added a bunch of PATA stuff from Bart, and a couple TRIM-related
    patches from mkp.

Alan Cox (6):
      pata_via: Blacklist some combinations of Transcend Flash and via
      pata_sis: Implement MWDMA for the UDMA 133 capable chips
      pata_cmd64x: implement serialization as per notes
      [libata] PATA: Update experimental tags
      pata_ali: Fix regression with old devices
      pata_piccolo: Driver for old Toshiba chipsets

Bartlomiej Zolnierkiewicz (28):
      pata_hpt37x: add proper cable detection methods
      pata_hpt37x: unify ->pre_reset methods
      pata_hpt3x2n: fix cable detection
      pata_hpt{37x,3x2n}: add debounce delay to cable detection methods
      libata: add comment documenting PIO latency issues on UP
      libata: add private driver field to struct ata_device
      ata_piix: fix MWDMA handling on PIIX3
      pata_efar: fix wrong PIO timings being programmed
      pata_efar: fix wrong MWDMA timings being programmed
      pata_cs5520: remove dead VDMA support
      pata_hpt3x3: Power Management fix
      pata_it8213: fix UDMA handling
      pata_it8213: fix wrong PIO timings being programmed
      pata_it8213: fix PIO2 underclocking
      pata_it8213: fix wrong MWDMA timings being programmed
      pata_it8213: fix it8213_pre_reset() documentation
      pata_legacy: fix QDI6580DP support
      pata_legacy: fix access to control register for QDI6580
      pata_legacy: add pointers to QDI65x0 documentation
      pata_marvell: fix marvell_pre_reset() documentation
      pata_ns87415: Power Management fix
      pata_radisys: fix UDMA handling
      pata_rz1000: Power Management fix
      pata_sis: Power Management fix
      pata_via: clear UDMA transfer mode bit for PIO and MWDMA
      [libata] MWDMA0 is unsupported on PIIX-like PATA controllers
      pata_it8213: MWDMA0 is unsupported
      pata_hpt3x2n: fix overclocked MWDMA0 timing

Benjamin Herrenschmidt (1):
      libata/sff: Use ops->bmdma_stop instead of ata_bmdma_stop()

Christoph Hellwig (1):
      libata: add translation for SCSI WRITE SAME (aka TRIM support)

Jiri Slaby (1):
      pata_via: fix double put on isa bridge

Krzysztof Halasa (1):
      pata_cs5536: use 32-bit BM DMA template instead of 16-bit.

Mark Nelson (1):
      ahci: let users know that Promise PDC42819 support is limited to SATA devices

Martin K. Petersen (2):
      libata: Report zeroed read after TRIM and max discard size
      libata: Clarify ata_set_lba_range_entries function

Matthew Garrett (1):
      ata: Don't require newlines for link_power_management_policy

Otavio Salvador (1):
      pata-it821x: use PCI_DEVICE_ID_RDC_D1010 define

Robert Hancock (1):
      libata: remove experimental tag on PATA drivers

Sergei Shtylyov (3):
      pata_hpt{37x|3x2n}: fix timing register masks (take 2)
      pata_hpt366: fix timing register documentation
      ata: use pci_dev->revision

Shaohua Li (1):
      ahci: disable SNotification capability for ich8

Tejun Heo (2):
      libata-acpi: missing _SDD is not an error
      libata: retry failed FLUSH if device didn't fail it

Thiago Farina (1):
      sata_mv: Clean up hard coded array size calculation.

Vivek Mahajan (1):
      sata_sil24: MSI support, disabled by default

ashish kalra (1):
      sata_fsl: Add asynchronous notification support

 drivers/ata/Kconfig           |   41 +++++++-----
 drivers/ata/Makefile          |    1 
 drivers/ata/ahci.c            |   28 +++++++-
 drivers/ata/ata_generic.c     |    5 +
 drivers/ata/ata_piix.c        |    6 -
 drivers/ata/libata-acpi.c     |   15 ++--
 drivers/ata/libata-core.c     |    7 ++
 drivers/ata/libata-eh.c       |   94 ++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c     |  107 +++++++++++++++++++++++++++++++-
 drivers/ata/libata-sff.c      |    2 
 drivers/ata/pata_ali.c        |    4 -
 drivers/ata/pata_cmd64x.c     |  125 +++++++++++++++++++++++++++++++++----
 drivers/ata/pata_cs5520.c     |   39 -----------
 drivers/ata/pata_cs5536.c     |    2 
 drivers/ata/pata_efar.c       |    9 +-
 drivers/ata/pata_hpt366.c     |   38 ++++-------
 drivers/ata/pata_hpt37x.c     |  137 +++++++++++++++++++++--------------------
 drivers/ata/pata_hpt3x2n.c    |   40 +++++-------
 drivers/ata/pata_hpt3x3.c     |   11 +++
 drivers/ata/pata_it8213.c     |   27 +++-----
 drivers/ata/pata_it821x.c     |    2 
 drivers/ata/pata_legacy.c     |   14 +++-
 drivers/ata/pata_marvell.c    |    2 
 drivers/ata/pata_ns87415.c    |   32 ++++++++-
 drivers/ata/pata_oldpiix.c    |    2 
 drivers/ata/pata_piccolo.c    |  140 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_radisys.c    |    4 -
 drivers/ata/pata_rdc.c        |    2 
 drivers/ata/pata_rz1000.c     |   11 +++
 drivers/ata/pata_sil680.c     |    6 -
 drivers/ata/pata_sis.c        |  112 ++++++++++++++++++++++++++-------
 drivers/ata/pata_via.c        |   56 +++++++++++++---
 drivers/ata/sata_fsl.c        |   18 +++--
 drivers/ata/sata_mv.c         |    2 
 drivers/ata/sata_sil24.c      |    9 ++
 drivers/ide/ide-pci-generic.c |    3 
 include/linux/ata.h           |   44 ++++++++++---
 include/linux/libata.h        |    3 
 include/linux/pci_ids.h       |    7 +-
 39 files changed, 913 insertions(+), 294 deletions(-)
