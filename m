Return-Path: <linux-kernel-owner+w=401wt.eu-S965015AbXAXH0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015AbXAXH0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933173AbXAXH0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:26:45 -0500
Received: from havoc.gtf.org ([69.61.125.42]:55419 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXAXH0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:26:44 -0500
Date: Wed, 24 Jan 2007 02:26:43 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: What's in libata-dev.git
Message-ID: <20070124072643.GA32298@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a summary and diffstat of all the changes pending in branch
libata-dev.git#upstream for kernel 2.6.21.  Items of note:

* major sata_promise improvements, including PATA and ATAPI support
* new drivers sata_inic162x, pata_it8213, MPC52xx
* sata_via PATA port support
* other minor improvements

Patchsets ACK'd and about to be merged:

* Tejun's devres stuff
* Cell ATA driver
* sata_sis PATA port support


Adrian Bunk (1):
      drivers/ata/: make 4 functions static

Alan (5):
      pata_it8213: Add new driver for the IT8213 card
      sata_via: PATA support
      libata-sff: Don't try and activate channels which are not in use
      ahci: Remove jmicron fixup
      libata: PIIX3 support

Alan Cox (1):
      pci: Move PCI_VDEVICE from libata to core

Andrew Morton (1):
      libata piix3 support warning fix

Arjan van de Ven (1):
      user of the jiffies rounding patch: ATA subsystem

Conke Hu (1):
      Add pci class code for SATA & AHCI, and replace some magic numbers.

Dan Wolstenholme (1):
      [libata] sata_vsc: support PCI MSI

J J (1):
      ata_piix: add ICH7 on Acer 3682WLMi to laptop list

Jakub W. Jozwicki J (1):
      pata_sis: implement laptop list and add ASUS A6K/A6U

Jeff Garzik (2):
      [libata] trim trailing whitespace
      [libata] sata_vsc: build fix after PCI MSI feature addition

Mikael Pettersson (5):
      sata_promise: TX2plus PATA support
      sata_promise: ATAPI support
      sata_promise: ATAPI cleanup
      sata_promise: issue ATAPI commands as normal packets
      sata_promise: handle ATAPI_NODATA ourselves

Robert Hancock (1):
      sata_nv: add suspend/resume support v3 (Resubmit)

Sylvain Munaut (1):
      libata: Add support for the MPC52xx ATA controller

Tejun Heo (6):
      libata: straighten out ATA_ID_* constants
      libata: use ata_id_c_string()
      libata: handle pci_enable_device() failure while resuming
      libata: kill qc->nsect and cursect
      sata_inic162x: finally, driver for initio 162x SATA controllers, take #2
      sata_promise: kill qc->nsect

Uwe Koziolek (1):
      sata_sis: support SiS966/966L

 drivers/ata/Kconfig             |   26 +
 drivers/ata/Makefile            |    3 
 drivers/ata/ahci.c              |   20 
 drivers/ata/ata_piix.c          |   23 -
 drivers/ata/libata-core.c       |   81 +---
 drivers/ata/libata-eh.c         |    7 
 drivers/ata/libata-scsi.c       |   52 +-
 drivers/ata/libata-sff.c        |   22 +
 drivers/ata/pata_ali.c          |    8 
 drivers/ata/pata_cs5520.c       |    2 
 drivers/ata/pata_cs5530.c       |    8 
 drivers/ata/pata_hpt366.c       |   20 
 drivers/ata/pata_hpt37x.c       |   23 -
 drivers/ata/pata_hpt3x3.c       |    2 
 drivers/ata/pata_it8213.c       |  354 +++++++++++++++++
 drivers/ata/pata_it821x.c       |   20 
 drivers/ata/pata_jmicron.c      |    2 
 drivers/ata/pata_marvell.c      |    4 
 drivers/ata/pata_mpc52xx.c      |  563 +++++++++++++++++++++++++++
 drivers/ata/pata_pdc202xx_old.c |    5 
 drivers/ata/pata_serverworks.c  |   19 
 drivers/ata/pata_sil680.c       |    2 
 drivers/ata/pata_sis.c          |   34 +
 drivers/ata/pata_via.c          |   10 
 drivers/ata/pata_winbond.c      |   16 
 drivers/ata/sata_inic162x.c     |  809 ++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_nv.c           |  239 ++++++++---
 drivers/ata/sata_promise.c      |  226 ++++++++++-
 drivers/ata/sata_qstor.c        |    2 
 drivers/ata/sata_sil.c          |   10 
 drivers/ata/sata_sil24.c        |    5 
 drivers/ata/sata_sis.c          |   79 ++-
 drivers/ata/sata_via.c          |  110 +++++
 drivers/ata/sata_vsc.c          |   44 ++
 drivers/pci/quirks.c            |    2 
 include/linux/ata.h             |   11 
 include/linux/libata.h          |   14 
 include/linux/pci_ids.h         |    3 
 38 files changed, 2554 insertions(+), 326 deletions(-)
