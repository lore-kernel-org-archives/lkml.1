Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0CDIZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:25:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54087
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777Ab0CDIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:24:59 -0500
Date: Thu, 04 Mar 2010 00:25:17 -0800 (PST)
Message-Id: <20100304.002517.194287089.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) ide-cs resource releasing bug fix from Wolfram Sang

2) Cleanups and refactoring from Bart, including ->{pio,dma}_mode
   handling consolidation so the drivers are formed more like PATA
   counterparts.

3) Section mismatch warning fix in cmd640.c

4) pdc202xx_old regression fix from Russell King.

5) Bring back icside use of ->maskproc method to fix a regression,
   from Bart.

6) Wrap ide-tape's ioctl in lock_kernel() and use ->unlocked_ioctl,
   from Alan Cox.

7) Kernel message continuation fixes from Joe Perches.

8) Kill stale references in ide-cd documentation, from Thadeu Lima de
   Souza Cascardo.

Please pull, thanks a lot!

The following changes since commit 066000dd856709b6980123eb39b957fe26993f7b:
  Ananth N Mavinakayanahalli (1):
        Revert "x86, apic: Use logical flat on intel with <= 8 logical cpus"

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-next-2.6.git master

Alan Cox (1):
      ide_tape: kill off use of the ->ioctl operation

Bartlomiej Zolnierkiewicz (43):
      scc_pata: fix module unloading
      icside: bring back ->maskproc method
      ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
      alim15x3: fix PIO timings calculations
      alim15x3: add ali_fifo_control() helper
      alim15x3: remove superfluous locking from ali_set_pio_mode()
      alim15x3: cleanup ali_cable_detect()
      amd74xx: don't change UDMA settings when programming PIO timings
      cmd64x: fix PIO and MWDMA timings calculations
      cmd64x: remove superfluous checks from cmd64x_set_dma_mode()
      cy82c693: fix PIO timings calculations
      cy82c693: remove stale driver history
      opti621: remove stale driver history
      pdc202xx_old: add ->init_hwif method
      serverworks: cleanup svwks_udma_filter()
      serverworks: add missing pci_dev_put() call
      via82cxxx: vx855 is a single channel controller
      ide: add SATA cable detection support
      via82cxxx: fix SATA cable detection
      via82cxxx: workaround h/w bugs
      via82cxxx: add support for vt8261 and future chips
      via82cxxx: add support for VT6415 PCIE PATA IDE Host Controller
      via82cxxx: fix UDMA settings programming
      ide: add drive->pio_mode field
      ide: add drive->dma_mode field
      ide: change ->set_pio_mode method parameters
      ide: change ->set_dma_mode method parameters
      ide-timings: use ->pio_mode value to determine fastest PIO speed
      alim15x3: fix handling of address setup timings
      alim15x3: fix handling of command timings
      alim15x3: fix handling of DMA timings
      alim15x3: fix handling of UDMA enable bit
      amd74xx: use ->pio_mode value to determine pair device speed
      cmd64x: fix handling of address setup timings
      cs5535: use ->pio_mode value to determine pair device speed
      cs5536: use ->pio_mode value to determine pair device speed
      it821x: use ->pio_mode value to determine pair device speed
      palm_bk3710: use ->pio_mode value to determine pair device speed
      siimage: use ->pio_mode value to determine pair device speed
      tx493xide: use ->pio_mode value to determine pair device speed
      via82cxxx: use ->pio_mode value to determine pair device speed
      ide: make ide_get_best_pio_mode() static
      ide: ide_timing_compute() fixup

Chris Frey (1):
      ide: fixed section mismatch warning in cmd640.c

David S. Miller (1):
      Merge branch 'master' of master.kernel.org:/.../davem/ide-2.6

Joe Perches (1):
      drivers/ide: Fix continuation line formats

Russell King (1):
      ide: Fix Promise UDMA33 IDE driver (pdc202xx_old)

Thadeu Lima de Souza Cascardo (1):
      ide: doc: remove compilation options section from ide-cd documentation

Wolfram Sang (1):
      ide/ide-cs: fix order of releasing resources

 Documentation/cdrom/ide-cd  |   39 +---------
 drivers/ide/aec62xx.c       |   13 ++--
 drivers/ide/ali14xx.c       |    3 +-
 drivers/ide/alim15x3.c      |  171 +++++++++++++++++++++++--------------------
 drivers/ide/amd74xx.c       |   18 +++--
 drivers/ide/at91_ide.c      |    5 +-
 drivers/ide/atiixp.c        |   14 ++--
 drivers/ide/au1xxx-ide.c    |   13 ++--
 drivers/ide/cmd640.c        |    5 +-
 drivers/ide/cmd64x.c        |  114 +++++++++++------------------
 drivers/ide/cs5520.c        |    9 +-
 drivers/ide/cs5530.c        |   13 ++--
 drivers/ide/cs5535.c        |   14 ++--
 drivers/ide/cs5536.c        |   16 ++--
 drivers/ide/cy82c693.c      |  146 ++++++-------------------------------
 drivers/ide/dtc2278.c       |    4 +-
 drivers/ide/hpt366.c        |    9 +-
 drivers/ide/ht6560b.c       |    3 +-
 drivers/ide/icside.c        |   67 ++++++++++++++++-
 drivers/ide/ide-cs.c        |   23 +++---
 drivers/ide/ide-devsets.c   |    6 +-
 drivers/ide/ide-iops.c      |    2 +-
 drivers/ide/ide-probe.c     |    2 +
 drivers/ide/ide-tape.c      |   14 +++-
 drivers/ide/ide-timings.c   |   18 ++--
 drivers/ide/ide-xfer-mode.c |   18 +++--
 drivers/ide/it8172.c        |   14 ++--
 drivers/ide/it8213.c        |   20 +++---
 drivers/ide/it821x.c        |   14 ++--
 drivers/ide/jmicron.c       |    6 +-
 drivers/ide/opti621.c       |   77 +-------------------
 drivers/ide/palm_bk3710.c   |   12 ++-
 drivers/ide/pdc202xx_new.c  |    8 +-
 drivers/ide/pdc202xx_old.c  |   31 ++++----
 drivers/ide/piix.c          |   20 +++---
 drivers/ide/pmac.c          |   13 ++--
 drivers/ide/qd65xx.c        |   10 +--
 drivers/ide/sc1200.c        |    8 +-
 drivers/ide/scc_pata.c      |   24 +++---
 drivers/ide/serverworks.c   |   50 ++++--------
 drivers/ide/sgiioc4.c       |    2 +-
 drivers/ide/siimage.c       |   14 ++--
 drivers/ide/sis5513.c       |    8 +-
 drivers/ide/sl82c105.c      |    8 +-
 drivers/ide/slc90e66.c      |   17 ++--
 drivers/ide/tc86c001.c      |    9 +-
 drivers/ide/triflex.c       |   10 +-
 drivers/ide/tx4938ide.c     |    7 +-
 drivers/ide/tx4939ide.c     |   10 +-
 drivers/ide/umc8672.c       |    5 +-
 drivers/ide/via82cxxx.c     |  132 +++++++++++++++++++++++++++------
 include/linux/ide.h         |    7 +-
 52 files changed, 617 insertions(+), 678 deletions(-)
