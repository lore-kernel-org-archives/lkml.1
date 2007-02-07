Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXBGSDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXBGSDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965660AbXBGSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:03:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:47245 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161409AbXBGSDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=rZ2IJICXI4Zgwqo+/z58xtpn2enjr2D6qqwXrOh+pNiIDhtUPQkrjHq4TJ3NWsPG7LOmzy2UOPsv9TF93pvqNe4YLqoZcbrOkh9sXPBcjLFPAVqHtA9bab83PYYTUbbPWfMBzEQa5yMOPv1pAT+roq7czgoy+hmYNRJMYJt0IWs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 07 Feb 2007 19:08:14 +0100
Message-Id: <20070207180814.27444.59159.sendpatchset@localhost.localdomain>
Subject: [git patches] IDE updates for 2.6.20
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Short summary:

- HPT driver rewrite (has been in -mm for months)
- driver for Toshiba TC86C001 chipset
- some fixes for piix/slc90e66/pdc202xx_new drivers
  (Sergei Shtylyov <sshtylyov@ru.mvista.com>)

- driver for ITE IT8213 chipset
  (Jack Lee <Jack.Lee@ite.com.tw>, some fixes from Alan Cox and me)

- driver for Delkin/Lexar/.. cardbus CF adapters
  (Mark Lord <mlord@pobox.com>)

- ACPI support for IDE (has been in SuSE kernels for months)
  (Hannes Reinecke <hare@suse.de>)

Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |   24 
 drivers/ide/Makefile           |    1 
 drivers/ide/ide-acpi.c         |  697 ++++++++++++++++++
 drivers/ide/ide-probe.c        |    3 
 drivers/ide/ide.c              |   36 
 drivers/ide/pci/Makefile       |    4 
 drivers/ide/pci/delkin_cb.c    |  140 +++
 drivers/ide/pci/hpt366.c       | 1583 +++++++++++++++++++++--------------------
 drivers/ide/pci/it8213.c       |  362 +++++++++
 drivers/ide/pci/pdc202xx_new.c |   56 -
 drivers/ide/pci/pdc202xx_old.c |   27 
 drivers/ide/pci/piix.c         |   31 
 drivers/ide/pci/slc90e66.c     |   55 -
 drivers/ide/pci/tc86c001.c     |  309 ++++++++
 drivers/pci/quirks.c           |   18 
 include/linux/ide.h            |   27 
 include/linux/pci_ids.h        |    1 
 17 files changed, 2506 insertions(+), 868 deletions(-)

Adrian Bunk (1):
      tc86c001: init_hwif_tc86c001() can be static

Andrew Morton (3):
      hpt366: rework rate filtering tidy
      tc86c001: mark init_chipset_tc86c001() with __devinit tag
      ide-acpi support warning fix

Bartlomiej Zolnierkiewicz (2):
      tc86c001: add missing __init tag for tc86c001_ide_init()
      ide: it8213 IDE driver update (version 2)

Hannes Reinecke (1):
      ACPI support for IDE devices

Jack Lee (1):
      ide: add it8213 IDE driver

Mark Lord (1):
      IDE Driver for Delkin/Lexar/etc.. cardbus CF adapter

Sergei Shtylyov (14):
      hpt366: rework rate filtering
      hpt366: print the real chip name at startup
      hpt366: switch to using pci_get_slot
      hpt366: cache channel's MCR address
      hpt366: merge HPT37x speedproc handlers
      hpt366: clean up DMA timeout handling for HPT370
      hpt366: init code rewrite
      hpt366: HPT36x PCI clock detection fix
      piix: fix 82371MX enablebits
      piix: tuneproc() fixes/cleanups
      slc90e66: carry over fixes from piix driver
      pdc202xx_new: remove useless code
      pdc202xx_new: remove check_in_drive_lists abomination
      ide: add Toshiba TC86C001 IDE driver (take 2)

Sorry but no patch this time (it is too big for the mailing list).
