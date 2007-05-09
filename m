Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXEIWfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXEIWfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXEIWfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:35:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:44656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXEIWfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YpPSqpKASpQUxHxb/JKYQDNF3zgLCJsuAYfskiq3arBnj3zqGb0VifWHFhg2Qf0oY5WmPW2tW73zB3NfJodPsKmQDkU94Smdrt+qpNyg6dtHVL5Ow9acqrWL9uKnmr74GBPmskc3H16S+j/qh4mAFd8RP14/5qQxhl9bFxnluN0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git patches] IDE update
Date: Thu, 10 May 2007 00:46:05 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705100046.05280.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ I've sent it to Linus a moment ago, here is a copy for linux-{ide,kernel} ]


Highlights of this update:

* the code for selecting and programming the best DMA transfer mode
  has been reworked to be cleaner, more generic and more libata-like,
  (> 500 LOCs gone and this change allows the change described below)

* more cable detection fixes, also be more user-friendly [+ developer
  friendly when it comes to debugging problems :) ] and inform user about
  limiting DMA speed to UDMA/33 if the 40-wire cable was detected instead
  of 80-wire one

* make /proc/ide interface optional (but enabled by default) as all
  important functionality should be now available through sysfs (+ ioctls),
  while at it do some cleanup/fixes of IDE procfs code


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |   14 ++
 drivers/ide/Makefile           |    2 +-
 drivers/ide/arm/bast-ide.c     |    2 +-
 drivers/ide/arm/icside.c       |    9 +-
 drivers/ide/arm/ide_arm.c      |    2 +-
 drivers/ide/arm/rapide.c       |    2 +-
 drivers/ide/cris/ide-cris.c    |    4 +-
 drivers/ide/h8300/ide-h8300.c  |    2 +-
 drivers/ide/ide-cd.c           |   20 +-
 drivers/ide/ide-disk.c         |  101 +++++++--
 drivers/ide/ide-dma.c          |   94 ++++++++
 drivers/ide/ide-floppy.c       |   30 ++--
 drivers/ide/ide-generic.c      |    2 -
 drivers/ide/ide-io.c           |   17 +-
 drivers/ide/ide-iops.c         |   55 +++---
 drivers/ide/ide-lib.c          |  132 ++---------
 drivers/ide/ide-pnp.c          |    2 +-
 drivers/ide/ide-probe.c        |    3 +
 drivers/ide/ide-proc.c         |  344 +++++++++++++++++++++++++++--
 drivers/ide/ide-tape.c         |   49 ++--
 drivers/ide/ide.c              |  470 ++++++++--------------------------------
 drivers/ide/legacy/ali14xx.c   |    3 +-
 drivers/ide/legacy/buddha.c    |    2 +-
 drivers/ide/legacy/dtc2278.c   |    3 +-
 drivers/ide/legacy/falconide.c |    2 +-
 drivers/ide/legacy/gayle.c     |    2 +-
 drivers/ide/legacy/ht6560b.c   |    3 +-
 drivers/ide/legacy/ide-cs.c    |    2 +-
 drivers/ide/legacy/macide.c    |    6 +-
 drivers/ide/legacy/q40ide.c    |    2 +-
 drivers/ide/legacy/qd65xx.c    |    7 +-
 drivers/ide/legacy/umc8672.c   |    3 +-
 drivers/ide/mips/au1xxx-ide.c  |    3 +
 drivers/ide/mips/swarm.c       |    3 +
 drivers/ide/pci/aec62xx.c      |   62 ++----
 drivers/ide/pci/alim15x3.c     |   97 +++------
 drivers/ide/pci/amd74xx.c      |    6 +-
 drivers/ide/pci/atiixp.c       |   40 +----
 drivers/ide/pci/cmd64x.c       |   90 +++------
 drivers/ide/pci/cs5520.c       |   20 ++-
 drivers/ide/pci/cs5535.c       |   33 +---
 drivers/ide/pci/delkin_cb.c    |    2 +-
 drivers/ide/pci/hpt34x.c       |   27 +--
 drivers/ide/pci/hpt366.c       |   85 +++-----
 drivers/ide/pci/it8213.c       |   39 +---
 drivers/ide/pci/it821x.c       |   20 +--
 drivers/ide/pci/jmicron.c      |   40 +----
 drivers/ide/pci/pdc202xx_new.c |   40 +---
 drivers/ide/pci/pdc202xx_old.c |   54 +----
 drivers/ide/pci/piix.c         |  163 +++-----------
 drivers/ide/pci/scc_pata.c     |   21 +--
 drivers/ide/pci/serverworks.c  |   31 ++-
 drivers/ide/pci/sgiioc4.c      |    2 +-
 drivers/ide/pci/siimage.c      |   45 ++--
 drivers/ide/pci/sis5513.c      |   44 +---
 drivers/ide/pci/slc90e66.c     |   24 +--
 drivers/ide/pci/tc86c001.c     |   20 +--
 drivers/ide/pci/triflex.c      |   15 +-
 drivers/ide/ppc/pmac.c         |    2 +
 drivers/ide/setup-pci.c        |   27 ++-
 drivers/macintosh/mediabay.c   |    2 +-
 drivers/scsi/ide-scsi.c        |   30 ++-
 include/linux/ide.h            |   93 +++++----
 63 files changed, 1107 insertions(+), 1464 deletions(-)


Bartlomiej Zolnierkiewicz (11):
      ide: fix UDMA/MWDMA/SWDMA masks (v3)
      ide: rework the code for selecting the best DMA transfer mode (v3)
      ide: add ide_tune_dma() helper
      ide: make /proc/ide/ optional
      ide: split off ioctl handling from IDE settings (v2)
      ide: move IDE settings handling to ide-proc.c
      ide: cable detection fixes (take 2)
      ide: add "initializing" argument to ide_register_hw()
      ide: add ide_proc_register_port()
      ide: legacy PCI bus order probing fixes
      ide: fix PIO setup on resume for ATAPI devices


[ sorry but the patch is too big to be included ]
