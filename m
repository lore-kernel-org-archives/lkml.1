Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYGNUud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYGNUud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbYGNUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:49:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28602 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbYGNUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:49:55 -0400
Date: Mon, 14 Jul 2008 22:49:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT PULL] i2c updates for 2.6.27, round 1
Message-ID: <20080714224945.629446fa@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the first round of i2c subsystem updates for Linux 2.6.27
from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There are two new i2c bus driver (i2c-cpm and i2c-isch), one new i2c
chip driver (at24), three bus drivers removed (i2c-i810, i2c-prosavage
and i2c-savage4), and many many improvements to both i2c-core and
pretty much every individual driver.

 Documentation/feature-removal-schedule.txt |    7 -
 Documentation/i2c/busses/i2c-i810          |   47 --
 Documentation/i2c/busses/i2c-prosavage     |   23 -
 Documentation/i2c/busses/i2c-savage4       |   26 -
 Documentation/i2c/fault-codes              |  127 +++++
 Documentation/i2c/smbus-protocol           |    4 +-
 Documentation/i2c/writing-clients          |   51 ++-
 MAINTAINERS                                |    7 +
 arch/mips/sibyte/swarm/Makefile            |    1 +
 arch/mips/sibyte/swarm/swarm-i2c.c         |   37 ++
 drivers/i2c/algos/i2c-algo-bit.c           |    4 +-
 drivers/i2c/algos/i2c-algo-pca.c           |    2 +-
 drivers/i2c/algos/i2c-algo-pcf.c           |   48 ++-
 drivers/i2c/busses/Kconfig                 |  715 +++++++++++++--------------
 drivers/i2c/busses/Makefile                |   57 ++-
 drivers/i2c/busses/i2c-ali1535.c           |   38 +-
 drivers/i2c/busses/i2c-ali1563.c           |   38 +-
 drivers/i2c/busses/i2c-ali15x3.c           |   32 +-
 drivers/i2c/busses/i2c-amd756-s4882.c      |    4 +-
 drivers/i2c/busses/i2c-amd756.c            |   35 +-
 drivers/i2c/busses/i2c-amd8111.c           |   54 ++-
 drivers/i2c/busses/i2c-au1550.c            |  130 +++--
 drivers/i2c/busses/i2c-cpm.c               |  745 ++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-davinci.c           |   89 +++-
 drivers/i2c/busses/i2c-elektor.c           |    4 +-
 drivers/i2c/busses/i2c-gpio.c              |    2 +-
 drivers/i2c/busses/i2c-hydra.c             |    3 -
 drivers/i2c/busses/i2c-i801.c              |  284 +++++------
 drivers/i2c/busses/i2c-i810.c              |  260 ----------
 drivers/i2c/busses/i2c-ibm_iic.c           |  206 +--------
 drivers/i2c/busses/i2c-iop3xx.c            |    2 +-
 drivers/i2c/busses/i2c-isch.c              |  339 +++++++++++++
 drivers/i2c/busses/i2c-mpc.c               |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c           |    2 +-
 drivers/i2c/busses/i2c-nforce2-s4985.c     |  257 ++++++++++
 drivers/i2c/busses/i2c-nforce2.c           |   49 ++-
 drivers/i2c/busses/i2c-ocores.c            |   44 ++-
 drivers/i2c/busses/i2c-pasemi.c            |    2 +-
 drivers/i2c/busses/i2c-pca-platform.c      |    2 +-
 drivers/i2c/busses/i2c-piix4.c             |   73 ++--
 drivers/i2c/busses/i2c-pmcmsp.c            |    2 +-
 drivers/i2c/busses/i2c-prosavage.c         |  325 ------------
 drivers/i2c/busses/i2c-pxa.c               |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c           |    2 +-
 drivers/i2c/busses/i2c-savage4.c           |  185 -------
 drivers/i2c/busses/i2c-sibyte.c            |    8 +-
 drivers/i2c/busses/i2c-sis5595.c           |   29 +-
 drivers/i2c/busses/i2c-sis630.c            |   59 ++-
 drivers/i2c/busses/i2c-sis96x.c            |   37 +-
 drivers/i2c/busses/i2c-stub.c              |    6 +-
 drivers/i2c/busses/i2c-taos-evm.c          |    5 +-
 drivers/i2c/busses/i2c-via.c               |    5 +-
 drivers/i2c/busses/i2c-viapro.c            |   31 +-
 drivers/i2c/busses/i2c-voodoo3.c           |    2 -
 drivers/i2c/busses/scx200_acb.c            |    2 +-
 drivers/i2c/chips/Kconfig                  |   43 ++-
 drivers/i2c/chips/Makefile                 |    1 +
 drivers/i2c/chips/at24.c                   |  583 ++++++++++++++++++++++
 drivers/i2c/chips/eeprom.c                 |   81 ++--
 drivers/i2c/chips/max6875.c                |    4 +-
 drivers/i2c/chips/pca9539.c                |   25 +-
 drivers/i2c/chips/pcf8574.c                |   25 +-
 drivers/i2c/chips/pcf8591.c                |   33 +-
 drivers/i2c/i2c-core.c                     |  575 +++++++++++++++++-----
 drivers/i2c/i2c-dev.c                      |   12 +-
 drivers/video/fb_ddc.c                     |    1 +
 drivers/video/intelfb/intelfb_i2c.c        |   12 +-
 drivers/video/matrox/i2c-matroxfb.c        |   20 +-
 include/linux/i2c-algo-pcf.h               |    8 +-
 include/linux/i2c-id.h                     |    3 -
 include/linux/i2c.h                        |   46 ++-
 include/linux/i2c/at24.h                   |   28 +
 72 files changed, 3844 insertions(+), 2208 deletions(-)
 delete mode 100644 Documentation/i2c/busses/i2c-i810
 delete mode 100644 Documentation/i2c/busses/i2c-prosavage
 delete mode 100644 Documentation/i2c/busses/i2c-savage4
 create mode 100644 Documentation/i2c/fault-codes
 create mode 100644 arch/mips/sibyte/swarm/swarm-i2c.c
 create mode 100644 drivers/i2c/busses/i2c-cpm.c
 delete mode 100644 drivers/i2c/busses/i2c-i810.c
 create mode 100644 drivers/i2c/busses/i2c-isch.c
 create mode 100644 drivers/i2c/busses/i2c-nforce2-s4985.c
 delete mode 100644 drivers/i2c/busses/i2c-prosavage.c
 delete mode 100644 drivers/i2c/busses/i2c-savage4.c
 create mode 100644 drivers/i2c/chips/at24.c
 create mode 100644 include/linux/i2c/at24.h

---------------

Adrian Bunk (1):
      i2c: Remove 3 deprecated bus drivers

Alan Cox (1):
      i2c: Push ioctl BKL down into the i2c code

Alek Du (1):
      i2c: Add Intel SCH SMBus support

Dave Young (1):
      i2c: Use class_for_each_device

David Brownell (6):
      i2c: Document standard fault codes
      i2c-core: Return -Errno, not -1
      i2c: Kerneldoc for most I/O calls
      i2c: i2c_use_client() defends against NULL
      i2c: Bus drivers return -Errno not -1
      i2c: Deprecate the legacy gpio drivers

Eric Brower (1):
      i2c-algo-pcf: Multi-master lost-arbitration improvement

Jean Delvare (24):
      i2c-nforce2: Add support for multiplexing on the Tyan S4985
      i2c-core: Remove needless include
      i2c: Group bus drivers by type
      i2c: Delete unused function i2c_smbus_write_quick
      i2c: Update stray references to smbus_access
      i2c-piix4: Various cleanups and minor fixes
      i2c: Consistently reject unsupported transactions
      i2c: Simplify i2c_del_driver()
      i2c: Let framebuffer drivers set their I2C bus class to DDC
      i2c: Let bus drivers add SPD to their class
      i2c/eeprom: Only probe buses with DDC or SPD class
      i2c/eeprom: Fall back to SMBus read word transactions
      i2c: Simplify i2c_device_probe
      i2c-algo-pcf: Drop unused struct members
      i2c-i801: Remove verbose debugging messages
      i2c-i801: Properly report bus arbitration loss
      i2c-i801: Rename local variable temp to status
      i2c-i801: Fix handling of error conditions
      i2c: Check for ACPI resource conflicts
      i2c: Drop stray references to lm_sensors
      i2c-dev: Delete empty detach_client callback
      i2c: Clean up old chip drivers
      i2c: Call client_unregister for new-style devices too
      i2c: Add detection capability to new-style drivers

Jochen Friedrich (2):
      i2c: Add support for I2C bus on Freescale CPM1/CPM2 controllers
      i2c: Add MAINTAINER entry for i2c-cpm

Jon Smirl (1):
      i2c: Export the i2c_bus_type symbol

Maciej W. Rozycki (1):
      i2c-sibyte: SWARM I2C board initialization

Manuel Lauss (2):
      i2c-ocores: basic PM support
      i2c-au1550: Fix PM support

Matthias Kaehlcke (1):
      i2c: Use list_for_each_entry_safe

Mike Frysinger (1):
      i2c-bfin-twi: Update the dependencies

Sean MacLennan (1):
      i2c-ibm_iic: Register child nodes

Stefan Roese (2):
      i2c-ibm_iic: Remove deprecated OCP style part
      i2c-ibm_iic: Enable driver for all PPC4xx variants in arch/powerpc

Troy Kisky (5):
      i2c-davinci: Ensure clock between 7-12 MHz
      i2c-davinci: Move dev_dbg statement for more output
      i2c-davinci: Remove useless IVR read
      i2c-davinci: Fix signal handling bug
      i2c-davinci: Initialize cmd_complete sooner

Uli Luckas (1):
      i2c-pxa: Initialize early

Wolfram Sang (4):
      i2c-pca-algo: Fix error code
      i2c-pca-platform: Fix error code
      i2c-cpm: Bugfixes
      i2c: New-style EEPROM driver using device IDs

Thanks,
-- 
Jean Delvare
