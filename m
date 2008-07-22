Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYGVVO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYGVVO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYGVVOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:14:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1590 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYGVVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=JgNkwnCPjqpx4ePq+zeCHWhRqRcy4RVfpCwSJLwslNEAwAxnSw/UMwst6iq96sYrWI
         xnRaD1Mc3qI9p7+ypuaP8IvwrhIARrgnkiM/1Ld1yEgE2S1CBnuoxQJeg8ZmiJpxll/s
         w3GetGLNbYVUnffGVB2YHzMjCtJo9awbo0S7k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:11:59 +0200
Message-Id: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/10] ide: make ide 'struct hd_driveid'-free
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patchset (against pata tree + recently posted 'ata: add missing ATA_ID_*
defines (take 2)' patch) converts drivers/ide/ from using struct hd_driveid to
use 'raw' id + ATA_ID_* defines instead.  This is a part of larger project to
remove <linux/hdreg.h> + allows us to safely use ata_id_() & co. inline helpers
from <linux/ata.h> in drivers/ide/.

patches:
 #01-02 - drive-by fixes
 #03-05 - preparatory cleanups
 #06-07 - main conversion from struct hd_driveid to 'raw' id
 #08-10 - use more ata_id_*() helpers in drivers/ide/

diffstat:
 drivers/ide/arm/icside.c       |    4 
 drivers/ide/arm/palm_bk3710.c  |    3 
 drivers/ide/ide-acpi.c         |    6 -
 drivers/ide/ide-cd.c           |   15 +-
 drivers/ide/ide-disk.c         |  103 +++++++++-----------
 drivers/ide/ide-dma.c          |   62 ++++++------
 drivers/ide/ide-floppy.c       |   14 +-
 drivers/ide/ide-io.c           |    2 
 drivers/ide/ide-iops.c         |  209 +++++++++++------------------------------
 drivers/ide/ide-lib.c          |   28 ++---
 drivers/ide/ide-probe.c        |  164 ++++++++++++++++----------------
 drivers/ide/ide-proc.c         |    5 
 drivers/ide/ide-tape.c         |    7 -
 drivers/ide/ide-taskfile.c     |    6 -
 drivers/ide/ide-timings.c      |   23 ++--
 drivers/ide/ide.c              |   67 ++++++++++---
 drivers/ide/legacy/qd65xx.c    |   26 ++---
 drivers/ide/pci/alim15x3.c     |    4 
 drivers/ide/pci/cs5530.c       |   12 +-
 drivers/ide/pci/hpt366.c       |    8 -
 drivers/ide/pci/it821x.c       |   55 +++++-----
 drivers/ide/pci/pdc202xx_new.c |    4 
 drivers/ide/pci/pdc202xx_old.c |    8 -
 drivers/ide/pci/sc1200.c       |   12 +-
 drivers/ide/pci/serverworks.c  |    4 
 drivers/ide/pci/siimage.c      |    8 -
 drivers/ide/ppc/pmac.c         |    6 -
 drivers/scsi/ide-scsi.c        |   13 +-
 include/linux/ide.h            |   32 +++---
 29 files changed, 438 insertions(+), 472 deletions(-)
