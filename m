Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYAFQus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYAFQus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbYAFQug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:50:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbYAFQuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=INHdwuzMz00X6jwDmE5Z6r7acNSbqtFwpESryVlH/fl0nzi9akdDRGpSsMqygJkZjVKhdiLmdWojtOySLRoH4tqa9Ub3us60eSdVpZRuWyuVc6+X3rKGBudrsXgiMGR7T3ButRBcvRbD2eXNpAqWZvq7733v9CsWfqpRN//pUE0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:02:20 +0100
Message-Id: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/8] ide: more IDE probing code rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Convert legacy host drivers to use struct ide_port_info + ide_device_add()
  instead of open-coding initialization of IDE port data structures.

* Add ->cable_detect method for cable detection + use it in PCI host drivers.

* Fix some bugs in the process (handling of "idex=ata66" in atiixp, cs5535
  and scc_pata and handling I/O 32-bit setting in dtc2278 and au1xxx-ide).

diffstat:

 drivers/ide/arm/icside.c          |   25 ++++---
 drivers/ide/arm/ide_arm.c         |    2
 drivers/ide/arm/rapide.c          |    2
 drivers/ide/cris/ide-cris.c       |   18 +++--
 drivers/ide/h8300/ide-h8300.c     |    2
 drivers/ide/ide-generic.c         |    2
 drivers/ide/ide-pnp.c             |    2
 drivers/ide/ide-probe.c           |   87 +++++++++++++++++++++++++-
 drivers/ide/ide.c                 |    6 -
 drivers/ide/legacy/ali14xx.c      |   24 ++-----
 drivers/ide/legacy/buddha.c       |    2
 drivers/ide/legacy/dtc2278.c      |   36 ++++-------
 drivers/ide/legacy/falconide.c    |    2
 drivers/ide/legacy/gayle.c        |    2
 drivers/ide/legacy/ht6560b.c      |   22 +++---
 drivers/ide/legacy/ide_platform.c |    2
 drivers/ide/legacy/macide.c       |   12 ---
 drivers/ide/legacy/q40ide.c       |    2
 drivers/ide/legacy/qd65xx.c       |   23 ++++---
 drivers/ide/legacy/umc8672.c      |   24 ++-----
 drivers/ide/mips/au1xxx-ide.c     |   34 +++-------
 drivers/ide/mips/swarm.c          |    2
 drivers/ide/pci/aec62xx.c         |   25 +++----
 drivers/ide/pci/alim15x3.c        |    5 -
 drivers/ide/pci/amd74xx.c         |   18 ++---
 drivers/ide/pci/atiixp.c          |   30 ++++-----
 drivers/ide/pci/cmd640.c          |   31 ++++-----
 drivers/ide/pci/cmd64x.c          |    5 -
 drivers/ide/pci/cs5520.c          |    2
 drivers/ide/pci/cs5535.c          |   14 +---
 drivers/ide/pci/hpt366.c          |   84 ++++++++++++++-----------
 drivers/ide/pci/it8213.c          |   21 +++---
 drivers/ide/pci/it821x.c          |    5 -
 drivers/ide/pci/jmicron.c         |    6 -
 drivers/ide/pci/pdc202xx_new.c    |    8 --
 drivers/ide/pci/pdc202xx_old.c    |   10 +--
 drivers/ide/pci/piix.c            |    7 --
 drivers/ide/pci/scc_pata.c        |   12 ++-
 drivers/ide/pci/serverworks.c     |    9 --
 drivers/ide/pci/sgiioc4.c         |   18 +++--
 drivers/ide/pci/siimage.c         |    5 -
 drivers/ide/pci/sis5513.c         |    5 -
 drivers/ide/pci/slc90e66.c        |   19 +++--
 drivers/ide/pci/tc86c001.c        |   24 ++++---
 drivers/ide/pci/via82cxxx.c       |    6 -
 drivers/ide/ppc/mpc8xx.c          |    2
 drivers/ide/ppc/pmac.c            |   84 ++++++++++---------------
 drivers/ide/setup-pci.c           |  123 +++++++++++---------------------------
 include/linux/ide.h               |   15 ++++
 49 files changed, 459 insertions(+), 467 deletions(-)
