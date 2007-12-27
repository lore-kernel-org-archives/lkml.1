Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXL0TBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXL0TBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbXL0TBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:01:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXL0TBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=sCQYOCsbgjBbrsucfg4NW+f0I0J/phTK2HPuPO4Hzpq19szme4lSAO3AIM7CExH2blyNFIybKRM8VOASnr0mDBDekY05Ua+6k4QeTUq5AIi5ZNFLZmvUHOiUF6XuYJPd2M89fWKjo4CVPcF0g346L55JhAB/RUE3w3DgqssEcAM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 27 Dec 2007 20:11:53 +0100
Message-Id: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/9] ide: switch to generic DMA-mapping API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make IDE core PCI independent by replacing hwif->pci_dev (struct pci_dev *)
with hwif->dev (struct device *) and switch to using generic DMA-mapping API.

This is on top of IDE quilt tree + 3 patches posted today.

diffstat:

 drivers/ide/arm/icside.c                  |   52 ++++++++--------------------
 drivers/ide/ide-dma.c                     |   55 +++++++++++++++---------------
 drivers/ide/ide-io.c                      |    2 -
 drivers/ide/ide-lib.c                     |    6 ++-
 drivers/ide/ide-probe.c                   |    4 +-
 drivers/ide/ide.c                         |    3 +
 drivers/ide/mips/au1xxx-ide.c             |   43 ++++-------------------
 drivers/ide/pci/aec62xx.c                 |    8 ++--
 drivers/ide/pci/alim15x3.c                |    9 ++--
 drivers/ide/pci/amd74xx.c                 |    7 ++-
 drivers/ide/pci/atiixp.c                  |    9 ++--
 drivers/ide/pci/cmd64x.c                  |   14 +++----
 drivers/ide/pci/cs5520.c                  |    2 -
 drivers/ide/pci/cs5535.c                  |    4 +-
 drivers/ide/pci/cy82c693.c                |    5 +-
 drivers/ide/pci/delkin_cb.c               |    2 -
 drivers/ide/pci/hpt34x.c                  |    2 -
 drivers/ide/pci/hpt366.c                  |   29 +++++++++------
 drivers/ide/pci/it8213.c                  |    7 ++-
 drivers/ide/pci/it821x.c                  |   47 +++++++++++++++----------
 drivers/ide/pci/jmicron.c                 |    2 -
 drivers/ide/pci/ns87415.c                 |   14 +++----
 drivers/ide/pci/pdc202xx_new.c            |    6 ++-
 drivers/ide/pci/pdc202xx_old.c            |   11 +++---
 drivers/ide/pci/piix.c                    |   53 ++--------------------------
 drivers/ide/pci/rz1000.c                  |    2 -
 drivers/ide/pci/sc1200.c                  |   12 +++---
 drivers/ide/pci/scc_pata.c                |   13 +++----
 drivers/ide/pci/serverworks.c             |   18 ++++++---
 drivers/ide/pci/sgiioc4.c                 |   19 ++++------
 drivers/ide/pci/siimage.c                 |   51 ++++++++++++++++-----------
 drivers/ide/pci/sis5513.c                 |   22 ++++++------
 drivers/ide/pci/sl82c105.c                |   17 +++++----
 drivers/ide/pci/slc90e66.c                |    7 ++-
 drivers/ide/pci/tc86c001.c                |    3 +
 drivers/ide/pci/triflex.c                 |    2 -
 drivers/ide/pci/trm290.c                  |    2 -
 drivers/ide/pci/via82cxxx.c               |   12 +++---
 drivers/ide/ppc/pmac.c                    |   24 ++++++-------
 drivers/ide/setup-pci.c                   |    6 +--
 include/asm-mips/mach-au1x00/au1xxx_ide.h |    1
 include/linux/ide.h                       |   10 +++--
 42 files changed, 288 insertions(+), 329 deletions(-)

Thanks,
Bart
