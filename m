Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088Ab0A2QDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0A2QDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0A2QDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:03:18 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0A2QDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:03:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Q+Sk4IXm2NYPLpV2AgPv2FQHg17gyIlK+q29VyrCrRICtDRUCDwA0R7Z+GfGvDYI4k
         FEZMvabRyX48qA9MQspNe5y0xhiex5JI6JCSnal4YUqE0wZnsCRTyFhHjaooWwueqSXO
         vO7xD3f2QM9NanP1b/DCNmSspRxhuB2QUuVzA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:03:08 +0100
Message-Id: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 00/68] ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is a patchset (on top of atang-v3.1 tree) applying "out-of-the-box"
thinking to duplicated libata PATA and IDE subsystem host driver sets.
Namely, it modifies IDE API slightly to match libata's one more, adds
a tiny source-code level translation layer (ide2libata.h header file
which consists of only 17 lines of code) and then converts host drivers
to use shared source code for low-level operations (all drivers have
been carefully audited during porting to minimize the probability of
adding regressions accidentally).  As an end result it is much easier
to maintain both driver sets (differences between 'new'/'old' drivers
are now apparent and there is no longer a need to manually back-port
many classes of bugfixes) and over 2500 LOC are gone.


The following changes since commit 7a4716f9084b32e32511cdea64ba538ac11e2c90:
  Bartlomiej Zolnierkiewicz (1):
        ide: ide_timing_compute() fixup

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.0

Bartlomiej Zolnierkiewicz (68):
      piix: add new short cable IDs
      libata: CodingStyle fixes for ATA timings code
      libata: move ATA timings code to ata-timings.c
      ata: make ATA timings code independent of libata
      ata: enable XFER_PIO_SLOW mode in ata_timing table
      ide: switch to generic ATA timings code
      pata_pcmcia: move IDs table to pata_pcmcia.h
      ide-cs: use pata_pcmcia.h
      ata_piix: factor out short cable detection code to ich_short_ata40()
      ata_piix: move short cable handling to ata_piix.h
      piix: use ata_piix.h
      pata_ali: move short cable handling to pata_ali.h
      alim15x3: use pata_ali.h
      pata_sis: move short cable handling to pata_sis.h
      sis5513: use pata_sis.h
      pata_via: move short cable handling to pata_via.h
      via82cxxx: use pata_via.h
      ide: split host->dev table
      ide: add hwif->port_no field
      ide: add hwif->udma_mask field
      ide: add hwif->private_data field
      ide: add drive->devno field
      ide: add drive->class field
      ide: change ->cable_detect method return type to 'int'
      it8213: always program control bits
      piix: always program control bits
      slc90e66: always program control bits
      add ide2libata header file
      ata_piix: move code to be re-used by ide2libata to ata_piix.h
      piix: convert to ide2libata
      pata_ali: move code to be re-used by ide2libata to pata_ali.h
      alim15x3: convert to ide2libata
      pata_amd: move code to be re-used by ide2libata to pata_amd.h
      amd74xx: convert to ide2libata
      pata_artop: move code to be re-used by ide2libata to pata_artop.h
      aec62xx: convert to ide2libata
      pata_atiixp: move code to be re-used by ide2libata to pata_atiixp.h
      atiixp: convert to ide2libata
      pata_cmd64x: documentation fix
      pata_cmd64x: move code to be re-used by ide2libata to pata_cmd64x.h
      pata_cmd64x: convert to ide2libata
      pata_cs5520: move code to be re-used by ide2libata to pata_cs5520.h
      cs5520: convert to ide2libata
      pata_cs5530: move code to be re-used by ide2libata to pata_cs5530.h
      cs5530: convert to ide2libata
      pata_cs5535: move code to be re-used by ide2libata to pata_cs5535.h
      cs5535: convert to ide2libata
      pata_cypress: move code to be re-used by ide2libata to pata_cypress.h
      cy82c693: convert to ide2libata
      pata_efar: move code to be re-used by ide2libata to pata_efar.h
      slc90e66: convert to ide2libata
      pata_it8213: move code to be re-used by ide2libata to pata_it8213.h
      it8213: convert to ide2libata
      pata_it821x: move code to be re-used by ide2libata to pata_it821x.h
      it821x: convert to ide2libata
      pata_pdc202xx_old: move code to be re-used by ide2libata to pata_pdc202xx_old.h
      pdc202xx_old: convert to ide2libata
      pata_sc1200: move code to be re-used by ide2libata to pata_sc1200.h
      sc1200: convert to ide2libata
      pata_serverworks: move cable handling to pata_serverworks.h
      serverworks: convert to ide2libata
      pata_sl82c105: move code to be re-used by ide2libata to pata_sl82c105.h
      sl82c105: convert to ide2libata
      pata_triflex: move code to be re-used by ide2libata to pata_triflex.h
      triflex: convert to ide2libata
      pata_via: factor out code for finding ISA bridge
      pata_via: move code to be re-used by ide2libata to pata_via.h
      via82cxxx: convert to ide2libata

 drivers/ata/Kconfig             |    4 +
 drivers/ata/Makefile            |    2 +
 drivers/ata/ata-timings.c       |  178 ++++++++++++++++++
 drivers/ata/ata_piix.c          |  263 +---------------------------
 drivers/ata/ata_piix.h          |  278 +++++++++++++++++++++++++++++
 drivers/ata/libata-core.c       |  162 -----------------
 drivers/ata/pata_ali.c          |  270 +----------------------------
 drivers/ata/pata_ali.h          |  326 ++++++++++++++++++++++++++++++++++
 drivers/ata/pata_amd.c          |   89 +---------
 drivers/ata/pata_amd.h          |   94 ++++++++++
 drivers/ata/pata_artop.c        |  232 +------------------------
 drivers/ata/pata_artop.h        |  293 ++++++++++++++++++++++++++++++
 drivers/ata/pata_at32.c         |    8 +-
 drivers/ata/pata_at91.c         |   18 +--
 drivers/ata/pata_atiixp.c       |  114 +------------
 drivers/ata/pata_atiixp.h       |  116 ++++++++++++
 drivers/ata/pata_atp867x.c      |    5 +-
 drivers/ata/pata_cmd640.c       |    9 +-
 drivers/ata/pata_cmd64x.c       |  216 +----------------------
 drivers/ata/pata_cmd64x.h       |  246 +++++++++++++++++++++++++
 drivers/ata/pata_cs5520.c       |   60 +------
 drivers/ata/pata_cs5520.h       |   60 ++++++
 drivers/ata/pata_cs5530.c       |  178 +------------------
 drivers/ata/pata_cs5530.h       |  185 +++++++++++++++++++
 drivers/ata/pata_cs5535.c       |  113 +------------
 drivers/ata/pata_cs5535.h       |  114 ++++++++++++
 drivers/ata/pata_cypress.c      |   91 +----------
 drivers/ata/pata_cypress.h      |  108 +++++++++++
 drivers/ata/pata_efar.c         |  151 +----------------
 drivers/ata/pata_efar.h         |  161 +++++++++++++++++
 drivers/ata/pata_icside.c       |    4 +-
 drivers/ata/pata_it8213.c       |  150 +----------------
 drivers/ata/pata_it8213.h       |  157 ++++++++++++++++
 drivers/ata/pata_it821x.c       |  319 +---------------------------------
 drivers/ata/pata_it821x.h       |  337 +++++++++++++++++++++++++++++++++++
 drivers/ata/pata_legacy.c       |   32 ++--
 drivers/ata/pata_ns87410.c      |    7 +-
 drivers/ata/pata_ns87415.c      |    2 +-
 drivers/ata/pata_octeon_cf.c    |    4 +-
 drivers/ata/pata_pcmcia.c       |   67 +-------
 drivers/ata/pata_pcmcia.h       |   66 +++++++
 drivers/ata/pata_pdc202xx_old.c |  109 +-----------
 drivers/ata/pata_pdc202xx_old.h |  121 +++++++++++++
 drivers/ata/pata_sc1200.c       |  108 +-----------
 drivers/ata/pata_sc1200.h       |  112 ++++++++++++
 drivers/ata/pata_serverworks.c  |  282 +-----------------------------
 drivers/ata/pata_serverworks.h  |  303 +++++++++++++++++++++++++++++++
 drivers/ata/pata_sis.c          |   30 +---
 drivers/ata/pata_sis.h          |   30 +++
 drivers/ata/pata_sl82c105.c     |  106 +-----------
 drivers/ata/pata_sl82c105.h     |  110 ++++++++++++
 drivers/ata/pata_triflex.c      |   72 +--------
 drivers/ata/pata_triflex.h      |   69 +++++++
 drivers/ata/pata_via.c          |  255 +--------------------------
 drivers/ata/pata_via.h          |  269 ++++++++++++++++++++++++++++
 drivers/ide/Kconfig             |    1 +
 drivers/ide/Makefile            |    1 -
 drivers/ide/aec62xx.c           |  172 +-----------------
 drivers/ide/ali14xx.c           |    2 +-
 drivers/ide/alim15x3.c          |  295 ++-----------------------------
 drivers/ide/amd74xx.c           |   90 +++-------
 drivers/ide/at91_ide.c          |    9 +-
 drivers/ide/atiixp.c            |  126 +-------------
 drivers/ide/cmd640.c            |    4 +-
 drivers/ide/cmd64x.c            |  196 +-------------------
 drivers/ide/cs5520.c            |   44 +----
 drivers/ide/cs5530.c            |  149 ++--------------
 drivers/ide/cs5535.c            |  141 +--------------
 drivers/ide/cs5536.c            |    2 +-
 drivers/ide/cy82c693.c          |  132 +-------------
 drivers/ide/hpt366.c            |    8 +-
 drivers/ide/ht6560b.c           |    3 +-
 drivers/ide/ide-cs.c            |   68 +-------
 drivers/ide/ide-probe.c         |    3 +-
 drivers/ide/ide-timings.c       |  217 ----------------------
 drivers/ide/ide-xfer-mode.c     |   25 +++
 drivers/ide/ide.c               |    4 +-
 drivers/ide/it8213.c            |  140 +--------------
 drivers/ide/it821x.c            |  375 +--------------------------------------
 drivers/ide/jmicron.c           |    2 +-
 drivers/ide/palm_bk3710.c       |    9 +-
 drivers/ide/pdc202xx_new.c      |    4 +-
 drivers/ide/pdc202xx_old.c      |   80 +--------
 drivers/ide/piix.c              |  226 ++----------------------
 drivers/ide/pmac.c              |    8 +-
 drivers/ide/qd65xx.c            |    2 +-
 drivers/ide/sc1200.c            |  113 +-----------
 drivers/ide/scc_pata.c          |    2 +-
 drivers/ide/serverworks.c       |  281 ++---------------------------
 drivers/ide/setup-pci.c         |    6 +-
 drivers/ide/siimage.c           |    2 +-
 drivers/ide/sis5513.c           |   27 +---
 drivers/ide/sl82c105.c          |  105 +----------
 drivers/ide/slc90e66.c          |  117 +------------
 drivers/ide/tc86c001.c          |    2 +-
 drivers/ide/triflex.c           |   57 +------
 drivers/ide/tx4938ide.c         |    2 +-
 drivers/ide/tx4939ide.c         |    2 +-
 drivers/ide/via82cxxx.c         |  290 +++---------------------------
 include/linux/ata.h             |   43 +++++
 include/linux/ide.h             |   66 +++----
 include/linux/ide2libata.h      |   17 ++
 include/linux/libata.h          |   37 ----
 103 files changed, 4147 insertions(+), 6825 deletions(-)
 create mode 100644 drivers/ata/ata-timings.c
 create mode 100644 drivers/ata/ata_piix.h
 create mode 100644 drivers/ata/pata_ali.h
 create mode 100644 drivers/ata/pata_amd.h
 create mode 100644 drivers/ata/pata_artop.h
 create mode 100644 drivers/ata/pata_atiixp.h
 create mode 100644 drivers/ata/pata_cmd64x.h
 create mode 100644 drivers/ata/pata_cs5520.h
 create mode 100644 drivers/ata/pata_cs5530.h
 create mode 100644 drivers/ata/pata_cs5535.h
 create mode 100644 drivers/ata/pata_cypress.h
 create mode 100644 drivers/ata/pata_efar.h
 create mode 100644 drivers/ata/pata_it8213.h
 create mode 100644 drivers/ata/pata_it821x.h
 create mode 100644 drivers/ata/pata_pcmcia.h
 create mode 100644 drivers/ata/pata_pdc202xx_old.h
 create mode 100644 drivers/ata/pata_sc1200.h
 create mode 100644 drivers/ata/pata_serverworks.h
 create mode 100644 drivers/ata/pata_sis.h
 create mode 100644 drivers/ata/pata_sl82c105.h
 create mode 100644 drivers/ata/pata_triflex.h
 create mode 100644 drivers/ata/pata_via.h
 delete mode 100644 drivers/ide/ide-timings.c
 create mode 100644 include/linux/ide2libata.h
