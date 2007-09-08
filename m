Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbXIHRmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbXIHRmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 13:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbXIHRl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 13:41:56 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59487 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXIHRlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 13:41:55 -0400
Date: Sat, 8 Sep 2007 13:41:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: What's in libata-dev.git?
Message-ID: <20070908174154.GA10305@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is the current contents of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
(recently rebased)

The 'upstream' branch is what I will push upstream for 2.6.24, once
the merge window opens.  I also have a pile in my inbox I need to go
over, while I was away at conference.  At least one fix still pending
for 2.6.23-rc that needs to go up.


list of branches
================
  ALL			contents of: upstream, sil680-mmio, new-eh
* master
  mv-ahci-pata		rough draft Marvell 6141 PATA support
  mv-ncq		rough draft sata_mv NCQ support
  new-eh		new EH conversion for sata_qstor, sata_sx4
  pmask			proto_mask implementation
  sii-lbt		SiI 311x large block transfer (LBT) support
  sil680-mmio		pata_sil680 MMIO support from benh
  upstream		queued for 2.6.24

Branch 'upstream' (queued for 2.6.24)
========================================
Alan Cox (11):
      libata: Correct IORDY handling
      libata-core: Document some limits/assumptions about ID_ATA
      libata: Note that our cache flush code needs fixing up
      pata_cmd64x: Set up MWDMA modes properly
      [libata] add ACPI cable detect API
      libata pata_amd: ACPI checks for 80wire cable
      libata pata_via: ACPI checks for 80wire cable
      libata: Switch most of the remaining SFF drivers to ata_sff_port_start
      libata-portmap: Remove unused definitions
      libata: Spot bridge chips
      libata: Strict checking for identify reporting

Albert Lee (2):
      libata: move ata_altstatus() to pio data xfer functions
      libata: pata_pdc2027x PLL detection minor cleanup

Andrew Morton (1):
      libata-add-irq_flags-to-struct-pata_platform_info-fix

Christian Lamparter (1):
      ata_piix: disallow UDMA 133 on ICH5 & ICH7

Jeff Garzik (4):
      [libata] pdc_adma: convert to new exception handling (EH) framework
      [libata] Remove ->irq_ack() hook, and ata_dummy_irq_on()
      [libata] Remove ->port_disable() hook
      [libata] ata_piix: Use more-robust form of array initialization

Kristen Carlson Accardi (3):
      [libata] check for SATA async notify support
      [libata] ahci: send event when AN received
      ahci: Store interrupt value

Kristoffer Nyborg Gregertsen (1):
      AVR32 PATA driver

Mark Lord (1):
      libata: add support for ATA_16 on ATAPI

Sonic Zhang (1):
      libata driver for bf548 on chip ATAPI controller.

Tejun Heo (18):
      libata-link: introduce ata_link
      libata-link: implement and use link/device iterators
      libata-link: linkify PHY-related functions
      libata-link: linkify EH action helpers
      libata-link: linkify reset
      libata-link: linkify config/EH related functions
      libata-link: make two port flags HRST_TO_RESUME and SKIP_D2H_BSY link flags
      libata-link: separate out link initialization functions
      libata-link: implement ata_link_abort()
      libata-link: add PMP links
      libata-link: update ata_scsi_error() to handle PMP links
      libata-link: update EH to deal with PMP links
      libata-link: update hotplug to handle PMP links
      libata-link: update Power Management to handle PMP links
      libata: use ata_port_printk() in ata_wait_idle()
      libata: add printf format attribute to ehi desc functions
      libata: implement and use ata_port_desc() to report port configuration
      libata: move EH repeat reporting into ata_eh_report()

 drivers/ata/Kconfig                  |   25 
 drivers/ata/Makefile                 |    2 
 drivers/ata/ahci.c                   |  109 +-
 drivers/ata/ata_generic.c            |   16 
 drivers/ata/ata_piix.c               |   52 -
 drivers/ata/libata-acpi.c            |   63 +
 drivers/ata/libata-core.c            |  669 ++++++++------
 drivers/ata/libata-eh.c              |  647 +++++++++----
 drivers/ata/libata-scsi.c            |  258 +++--
 drivers/ata/libata-sff.c             |   69 -
 drivers/ata/libata.h                 |    7 
 drivers/ata/pata_ali.c               |   17 
 drivers/ata/pata_amd.c               |   43 
 drivers/ata/pata_artop.c             |   20 
 drivers/ata/pata_at32.c              |  441 +++++++++
 drivers/ata/pata_atiixp.c            |    9 
 drivers/ata/pata_bf54x.c             | 1627 +++++++++++++++++++++++++++++++++++
 drivers/ata/pata_cmd640.c            |    4 
 drivers/ata/pata_cmd64x.c            |   43 
 drivers/ata/pata_cs5520.c            |   27 
 drivers/ata/pata_cs5530.c            |    4 
 drivers/ata/pata_cs5535.c            |    4 
 drivers/ata/pata_cypress.c           |    4 
 drivers/ata/pata_efar.c              |   11 
 drivers/ata/pata_hpt366.c            |    4 
 drivers/ata/pata_hpt37x.c            |   28 
 drivers/ata/pata_hpt3x2n.c           |   11 
 drivers/ata/pata_hpt3x3.c            |   10 
 drivers/ata/pata_icside.c            |   39 
 drivers/ata/pata_isapnp.c            |    8 
 drivers/ata/pata_it8213.c            |   11 
 drivers/ata/pata_it821x.c            |   17 
 drivers/ata/pata_ixp4xx_cf.c         |   24 
 drivers/ata/pata_jmicron.c           |   11 
 drivers/ata/pata_legacy.c            |   27 
 drivers/ata/pata_marvell.c           |   12 
 drivers/ata/pata_mpc52xx.c           |    9 
 drivers/ata/pata_mpiix.c             |   25 
 drivers/ata/pata_netcell.c           |    5 
 drivers/ata/pata_ns87410.c           |   11 
 drivers/ata/pata_oldpiix.c           |   11 
 drivers/ata/pata_opti.c              |   11 
 drivers/ata/pata_optidma.c           |   26 
 drivers/ata/pata_pcmcia.c            |   16 
 drivers/ata/pata_pdc2027x.c          |   58 -
 drivers/ata/pata_pdc202xx_old.c      |    8 
 drivers/ata/pata_platform.c          |   16 
 drivers/ata/pata_qdi.c               |   15 
 drivers/ata/pata_radisys.c           |    4 
 drivers/ata/pata_rz1000.c            |   13 
 drivers/ata/pata_sc1200.c            |    4 
 drivers/ata/pata_scc.c               |   41 
 drivers/ata/pata_serverworks.c       |    8 
 drivers/ata/pata_sil680.c            |   11 
 drivers/ata/pata_sis.c               |   33 
 drivers/ata/pata_sl82c105.c          |   11 
 drivers/ata/pata_triflex.c           |   11 
 drivers/ata/pata_via.c               |   16 
 drivers/ata/pata_winbond.c           |   13 
 drivers/ata/pdc_adma.c               |  103 +-
 drivers/ata/sata_inic162x.c          |   34 
 drivers/ata/sata_mv.c                |   66 -
 drivers/ata/sata_nv.c                |   52 -
 drivers/ata/sata_promise.c           |   27 
 drivers/ata/sata_qstor.c             |   17 
 drivers/ata/sata_sil.c               |   53 -
 drivers/ata/sata_sil24.c             |   56 -
 drivers/ata/sata_sis.c               |    2 
 drivers/ata/sata_svw.c               |   14 
 drivers/ata/sata_sx4.c               |   25 
 drivers/ata/sata_uli.c               |   16 
 drivers/ata/sata_via.c               |   19 
 drivers/ata/sata_vsc.c               |   16 
 drivers/scsi/ipr.c                   |   19 
 drivers/scsi/libsas/sas_ata.c        |   11 
 include/asm-generic/libata-portmap.h |    5 
 include/linux/ata.h                  |  107 ++
 include/linux/libata.h               |  201 +++-
 78 files changed, 4143 insertions(+), 1449 deletions(-)


Branch 'sil680-mmio'
========================================
Benjamin Herrenschmidt (1):
      [libata] pata_sil680: Add MMIO support

 drivers/ata/pata_sil680.c |   61 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 4 deletions(-)


Branch 'sii-lbt'
========================================
Jeff Garzik (1):
      [libata] sata_sil: Turn on Large Block Transfer (LBT) feature

 drivers/ata/sata_sil.c |  106 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 98 insertions(+), 8 deletions(-)


Branch 'pmask'
========================================
Jeff Garzik (4):
      [libata] Introduce per-port taskfile protocol masks
      [libata] Fill in ->proto_mask setting for all drivers
      [libata] Use ->proto_mask to replace NCQ and NO_ATAPI flags
      [libata #pmask] add proto_mask to ipr, libsas

 drivers/ata/ahci.c              |    8 +++++++-
 drivers/ata/ata_generic.c       |   13 +++++++------
 drivers/ata/ata_piix.c          |   12 ++++++++++++
 drivers/ata/libata-core.c       |    5 ++++-
 drivers/ata/libata-scsi.c       |    3 ++-
 drivers/ata/pata_ali.c          |    7 +++++++
 drivers/ata/pata_amd.c          |   10 ++++++++++
 drivers/ata/pata_artop.c        |    3 +++
 drivers/ata/pata_atiixp.c       |    1 +
 drivers/ata/pata_cmd640.c       |    1 +
 drivers/ata/pata_cmd64x.c       |    6 ++++++
 drivers/ata/pata_cs5520.c       |    1 +
 drivers/ata/pata_cs5530.c       |    2 ++
 drivers/ata/pata_cs5535.c       |    1 +
 drivers/ata/pata_cypress.c      |    1 +
 drivers/ata/pata_efar.c         |    1 +
 drivers/ata/pata_hpt366.c       |    1 +
 drivers/ata/pata_hpt37x.c       |    6 ++++++
 drivers/ata/pata_hpt3x2n.c      |    1 +
 drivers/ata/pata_hpt3x3.c       |    3 +++
 drivers/ata/pata_icside.c       |    4 ++++
 drivers/ata/pata_isapnp.c       |    1 +
 drivers/ata/pata_it8213.c       |    1 +
 drivers/ata/pata_it821x.c       |    2 ++
 drivers/ata/pata_ixp4xx_cf.c    |    3 ++-
 drivers/ata/pata_jmicron.c      |    1 +
 drivers/ata/pata_legacy.c       |    1 +
 drivers/ata/pata_marvell.c      |    2 ++
 drivers/ata/pata_mpc52xx.c      |    1 +
 drivers/ata/pata_mpiix.c        |    1 +
 drivers/ata/pata_netcell.c      |    1 +
 drivers/ata/pata_ns87410.c      |    1 +
 drivers/ata/pata_oldpiix.c      |    1 +
 drivers/ata/pata_opti.c         |    1 +
 drivers/ata/pata_optidma.c      |    2 ++
 drivers/ata/pata_pcmcia.c       |    1 +
 drivers/ata/pata_pdc2027x.c     |    2 ++
 drivers/ata/pata_pdc202xx_old.c |    3 +++
 drivers/ata/pata_platform.c     |    1 +
 drivers/ata/pata_qdi.c          |    2 ++
 drivers/ata/pata_radisys.c      |    1 +
 drivers/ata/pata_rz1000.c       |    1 +
 drivers/ata/pata_sc1200.c       |    1 +
 drivers/ata/pata_scc.c          |    1 +
 drivers/ata/pata_serverworks.c  |    4 ++++
 drivers/ata/pata_sil680.c       |    2 ++
 drivers/ata/pata_sis.c          |   10 +++++++++-
 drivers/ata/pata_sl82c105.c     |    2 ++
 drivers/ata/pata_triflex.c      |    1 +
 drivers/ata/pata_via.c          |    6 ++++++
 drivers/ata/pata_winbond.c      |    1 +
 drivers/ata/pdc_adma.c          |    1 +
 drivers/ata/sata_inic162x.c     |    1 +
 drivers/ata/sata_mv.c           |   12 ++++++++++--
 drivers/ata/sata_nv.c           |    6 +++++-
 drivers/ata/sata_promise.c      |    7 +++++++
 drivers/ata/sata_qstor.c        |    1 +
 drivers/ata/sata_sil.c          |    4 ++++
 drivers/ata/sata_sil24.c        |    5 ++++-
 drivers/ata/sata_sis.c          |    1 +
 drivers/ata/sata_svw.c          |    2 ++
 drivers/ata/sata_sx4.c          |    4 +++-
 drivers/ata/sata_uli.c          |    1 +
 drivers/ata/sata_via.c          |    3 +++
 drivers/ata/sata_vsc.c          |    1 +
 drivers/scsi/ipr.c              |    1 +
 drivers/scsi/libsas/sas_ata.c   |    3 ++-
 include/linux/ata.h             |   22 ++++++++++++++++++++++
 include/linux/libata.h          |    9 +++++++--
 69 files changed, 213 insertions(+), 19 deletions(-)


Branch 'new-eh'
========================================
Jeff Garzik (3):
      [libata] sata_qstor: rough draft conversion to new libata EH
      [libata] sata_sx4: convert to new EH
      [libata] sata_qstor: ata_link new EH build fixes

 drivers/ata/sata_qstor.c |   66 +++++++++++++++++++++++---------
 drivers/ata/sata_sx4.c   |   96 +++++++++++++++++++++++++++++------------------
 2 files changed, 108 insertions(+), 54 deletions(-)


Branch 'mv-ncq'
========================================
Jeff Garzik (2):
      [libata mv-ncq] sata_mv: Add NCQ support
      [libata #mv-ncq] sata_mv: ata_link build fix

 drivers/ata/sata_mv.c |   71 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 21 deletions(-)


Branch 'mv-ahci-pata'
========================================
Jeff Garzik (4):
      [libata] AHCI: Add support for Marvell 6121/6141 PATA port
      [libata mv-ahci-pata] ahci: fix merge mistakes
      [libata #mv-ahci-pata] ahci: ata_link build fixes
      [libata #mv-ahci-pata] ahci: build fixes

 drivers/ata/ahci.c |  416 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 381 insertions(+), 35 deletions(-)


