Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbXJMWLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbXJMWLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbXJMWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:11:09 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:50659 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757128AbXJMWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:11:08 -0400
Date: Sun, 14 Oct 2007 00:11:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.24
Message-ID: <20071014001104.0f917dd2@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.24 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There is one new I2C bus driver (i2c-davinci), support for the Intel
Tolapai SMBus, some more conversions to the new i2c model, and a dozen
random fixes and cleanups.

 Documentation/i2c/busses/i2c-i801              |    3 +-
 Documentation/i2c/chips/pcf8574                |    8 +-
 Documentation/i2c/dev-interface                |   11 +-
 Documentation/i2c/i2c-stub                     |   18 +-
 arch/arm/mach-omap1/board-h2.c                 |   45 ++-
 arch/arm/mach-omap1/board-h3.c                 |   39 ++-
 arch/arm/mach-omap1/board-osk.c                |   64 +++-
 drivers/i2c/busses/Kconfig                     |   23 +-
 drivers/i2c/busses/Makefile                    |    1 +
 drivers/i2c/busses/i2c-amd8111.c               |    2 +-
 drivers/i2c/busses/i2c-au1550.c                |   11 +-
 drivers/i2c/busses/i2c-bfin-twi.c              |   16 -
 drivers/i2c/busses/i2c-davinci.c               |  586 ++++++++++++++++++++++++
 drivers/i2c/busses/i2c-i801.c                  |    5 +-
 drivers/i2c/busses/i2c-ibm_iic.c               |    9 +-
 drivers/i2c/busses/i2c-iop3xx.c                |    8 -
 drivers/i2c/busses/i2c-nforce2.c               |   83 +++-
 drivers/i2c/busses/i2c-stub.c                  |   79 +++-
 drivers/i2c/chips/pcf8574.c                    |   14 +-
 drivers/i2c/chips/tps65010.c                   |  299 ++++--------
 drivers/i2c/i2c-core.c                         |   50 +--
 drivers/i2c/i2c-dev.c                          |   20 +-
 drivers/media/video/bt8xx/bttv-i2c.c           |    7 -
 drivers/media/video/cx23885/cx23885-i2c.c      |    7 -
 drivers/media/video/em28xx/em28xx-i2c.c        |   10 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    7 -
 drivers/media/video/saa7134/saa7134-i2c.c      |    7 -
 drivers/media/video/usbvision/usbvision-i2c.c  |    6 -
 drivers/media/video/w9968cf.c                  |   11 -
 include/asm-arm/arch-davinci/i2c.h             |   21 +
 include/linux/i2c-dev.h                        |   31 ++-
 include/linux/i2c.h                            |  102 ++---
 include/linux/mod_devicetable.h                |    5 -
 scripts/mod/file2alias.c                       |   11 -
 34 files changed, 1154 insertions(+), 465 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-davinci.c
 create mode 100644 include/asm-arm/arch-davinci/i2c.h

---------------

Adrian Bunk (1):
      i2c-core: Make some code static

Chris David (1):
      i2c-au1550: Fix a misused register problem

David Brownell (10):
      i2c: New-style devices can support driver model wakeup flags
      i2c/tps65010: New-style driver updates, part 1
      i2c/tps65010: New-style driver updates, part 2
      i2c: Document struct i2c_msg
      i2c-dev: Reject I2C_M_RECV_LEN
      i2c: Remove NOP i2c_algorithm.algo_control() methods
      i2c: Remove i2c_algorithm.algo_control()
      i2c: Move i2c-dev interfaces to i2c-dev.h
      i2c-at91: Mark as broken
      i2c: Rename the PEC functionality bit

Francis Moreau (1):
      i2c-bfin-twi: Remove useless twi_lock mutex

Jason Gaston (1):
      i2c-i801: Add support for the Intel Tolapai SMBus

Jean Delvare (5):
      i2c: Kill struct i2c_device_id
      i2c/pcf8574: No arbitrary initialization
      i2c-stub: Support multiple chips
      cx23885: Drop empty i2c algorithm control callback
      i2c-nforce2: Declare PEC as supported

Oleg Ryjkov (2):
      i2c-nforce2: Move status checking to a separate function
      i2c-nforce2: Abort the transaction on error

Stefan Roese (1):
      i2c-ibm_iic: Add support for new-style clients

Vladimir Barinov (1):
      i2c: Add DaVinci I2C controller support

Thanks,
-- 
Jean Delvare
