Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYGFRe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYGFRe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYGFRek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:34:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7197 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYGFRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id;
        b=hJ5jFLI+0WMkFVj1AuXOaZNqg5c/UnKD0mZt0mtAZi/FfCUe/GdZNWMg4QH5/Ghwjy
         Z10TqAQNfDB5R5D4hDZ0FT04dg8ms6XSUbB3kkhgWXgqpB509UR5DTIKiPe36ty6d1TP
         rUi89RRN+wlWxLm5m2rMbdwEYiGBa9+Imx7kU=
Date: Sun, 06 Jul 2008 19:20:10 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/50] ide: fix module unloading for host drivers
Message-ID: <4871022c.1ade660a.3458.6260@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset (against ide tree) fixes module unloading for majority of host
drivers.  The ones that still need fixing (because they lack ->remove method
and/or should be converted to use struct platform_device):

- arch specific: ide_arm, palm_bk3710, ide-h8300, buddha, falconide, gayle,
  macide, q40ide, swarm, pmac

  [ These are probably best to be handled by their Maintainers. ]

- legacy ISA/VLB: ide-generic, ide-4drives, ali14xx, dtc2278, ht6560b, qd65xx,
  umc8672

  [ These need to use platform_device_register_simple(). ]

- others: cs5520, cmd640

  [ cs5520 should be quick to fix, unlike cmd640. ]

diffstat:

 drivers/ide/arm/icside.c       |    6 +
 drivers/ide/arm/rapide.c       |    6 +
 drivers/ide/ide-cd.c           |   12 ++-
 drivers/ide/ide-disk.c         |   12 ++-
 drivers/ide/ide-floppy.c       |   12 ++-
 drivers/ide/ide-probe.c        |    8 ++
 drivers/ide/ide-tape.c         |   12 ++-
 drivers/ide/ide.c              |   47 ++++++++++++
 drivers/ide/pci/aec62xx.c      |   47 +++++++-----
 drivers/ide/pci/alim15x3.c     |    9 ++
 drivers/ide/pci/amd74xx.c      |   45 ++++++-----
 drivers/ide/pci/atiixp.c       |    9 ++
 drivers/ide/pci/cmd64x.c       |   27 ++----
 drivers/ide/pci/cs5530.c       |    9 ++
 drivers/ide/pci/cs5535.c       |    9 ++
 drivers/ide/pci/cy82c693.c     |   21 ++++-
 drivers/ide/pci/generic.c      |    9 ++
 drivers/ide/pci/hpt34x.c       |    9 ++
 drivers/ide/pci/hpt366.c       |   94 +++++++++++++++---------
 drivers/ide/pci/it8213.c       |   12 ++-
 drivers/ide/pci/it821x.c       |   46 +++++++----
 drivers/ide/pci/jmicron.c      |    9 ++
 drivers/ide/pci/ns87415.c      |    9 ++
 drivers/ide/pci/opti621.c      |    9 ++
 drivers/ide/pci/pdc202xx_new.c |   20 ++++-
 drivers/ide/pci/pdc202xx_old.c |    9 ++
 drivers/ide/pci/piix.c         |    9 ++
 drivers/ide/pci/rz1000.c       |    9 ++
 drivers/ide/pci/sc1200.c       |   48 ++++++------
 drivers/ide/pci/serverworks.c  |    9 ++
 drivers/ide/pci/siimage.c      |  141 +++++++++++++++++++++---------------
 drivers/ide/pci/sis5513.c      |   15 +++
 drivers/ide/pci/sl82c105.c     |    9 ++
 drivers/ide/pci/slc90e66.c     |    9 ++
 drivers/ide/pci/tc86c001.c     |   57 +++++++++++---
 drivers/ide/pci/triflex.c      |    9 ++
 drivers/ide/pci/trm290.c       |    9 ++
 drivers/ide/pci/via82cxxx.c    |  132 ++++++++++++++++++----------------
 drivers/ide/setup-pci.c        |  159 ++++++++++++++++++++++++++++-------------
 drivers/scsi/ide-scsi.c        |    8 +-
 include/linux/ide.h            |   16 +++-
 41 files changed, 813 insertions(+), 343 deletions(-)
-- 

