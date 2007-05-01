Return-Path: <linux-kernel-owner+w=401wt.eu-S1945908AbXEAVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945908AbXEAVkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423704AbXEAVkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:40:41 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2016 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423691AbXEAVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:40:40 -0400
Date: Tue, 1 May 2007 23:41:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>
Subject: [GIT PULL] i2c updates for 2.6.22
Message-ID: <20070501234128.388825db@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.22 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

We have a new API in i2c-core which finally follows the device driver
model, 4 new I2C bus drivers, many improvements and fixes to
i2c-algo-bit, and as usual many cleanups and fixes to individual
drivers.

 Documentation/feature-removal-schedule.txt      |   22 +-
 Documentation/i2c/busses/i2c-nforce2            |    2 +
 Documentation/i2c/porting-clients               |   18 +-
 Documentation/i2c/summary                       |   29 +-
 Documentation/i2c/writing-clients               |  415 +++++----------
 MAINTAINERS                                     |   19 +
 arch/powerpc/platforms/powermac/cpufreq_32.c    |    1 -
 drivers/Makefile                                |    2 +-
 drivers/i2c/Kconfig                             |   18 +-
 drivers/i2c/Makefile                            |    1 +
 drivers/i2c/algos/Kconfig                       |    8 +-
 drivers/i2c/algos/i2c-algo-bit.c                |  286 ++++++----
 drivers/i2c/algos/i2c-algo-sgi.c                |    9 +-
 drivers/i2c/busses/Kconfig                      |  151 ++++--
 drivers/i2c/busses/Makefile                     |    4 +
 drivers/i2c/busses/i2c-ali1535.c                |    2 +-
 drivers/i2c/busses/i2c-ali15x3.c                |    2 +-
 drivers/i2c/busses/i2c-amd8111.c                |    2 +-
 drivers/i2c/busses/i2c-bfin-twi.c               |  644 ++++++++++++++++++++++
 drivers/i2c/busses/i2c-elektor.c                |   51 ++-
 drivers/i2c/busses/i2c-gpio.c                   |  215 ++++++++
 drivers/i2c/busses/i2c-i801.c                   |    2 +-
 drivers/i2c/busses/i2c-isa.c                    |   43 +--
 drivers/i2c/busses/i2c-ixp2000.c                |    2 +-
 drivers/i2c/busses/i2c-ixp4xx.c                 |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c                |    2 +-
 drivers/i2c/busses/i2c-nforce2.c                |    6 +-
 drivers/i2c/busses/i2c-omap.c                   |    3 +-
 drivers/i2c/busses/i2c-parport-light.c          |  144 ++++-
 drivers/i2c/busses/i2c-parport.c                |   25 +-
 drivers/i2c/busses/i2c-pasemi.c                 |    2 +-
 drivers/i2c/busses/i2c-pca-isa.c                |   35 +-
 drivers/i2c/busses/i2c-piix4.c                  |    2 +-
 drivers/i2c/busses/i2c-pxa.c                    |   15 +-
 drivers/i2c/busses/i2c-s3c2410.c                |   96 ++--
 drivers/i2c/busses/i2c-simtec.c                 |  186 +++++++
 drivers/i2c/busses/i2c-sis96x.c                 |    2 +-
 drivers/i2c/busses/i2c-tiny-usb.c               |  277 ++++++++++
 drivers/i2c/busses/i2c-viapro.c                 |    2 +-
 drivers/i2c/busses/scx200_acb.c                 |    3 +-
 drivers/i2c/chips/Kconfig                       |   21 +-
 drivers/i2c/i2c-boardinfo.c                     |   90 +++
 drivers/i2c/i2c-core.c                          |  662 +++++++++++++++++------
 drivers/i2c/i2c-core.h                          |   31 +
 drivers/macintosh/therm_windtunnel.c            |    3 +-
 drivers/media/dvb/b2c2/flexcop-i2c.c            |    3 +-
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c         |    2 +-
 drivers/media/dvb/frontends/dibx000_common.c    |    4 +-
 drivers/media/video/cx2341x.c                   |    1 -
 drivers/media/video/ovcamchip/ovcamchip_priv.h  |    1 +
 drivers/media/video/usbvision/usbvision-cards.c |    1 -
 drivers/video/intelfb/intelfb_i2c.c             |    3 +-
 drivers/video/matrox/i2c-matroxfb.c             |    2 +-
 include/linux/i2c-algo-bit.h                    |    7 +-
 include/linux/i2c-gpio.h                        |   38 ++
 include/linux/i2c-id.h                          |    3 +-
 include/linux/i2c.h                             |  123 ++++-
 include/linux/pci_ids.h                         |    2 +
 include/media/ovcamchip.h                       |    1 -
 include/media/tuner.h                           |    1 +
 sound/oss/dmasound/tas_ioctl.h                  |    1 -
 61 files changed, 2880 insertions(+), 870 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-bfin-twi.c
 create mode 100644 drivers/i2c/busses/i2c-gpio.c
 create mode 100644 drivers/i2c/busses/i2c-simtec.c
 create mode 100644 drivers/i2c/busses/i2c-tiny-usb.c
 create mode 100644 drivers/i2c/i2c-boardinfo.c
 create mode 100644 drivers/i2c/i2c-core.h
 create mode 100644 include/linux/i2c-gpio.h

---------------

Ben Dooks (3):
      i2c: New Simtec I2C bus driver
      i2c-s3c2410: Fix I2C SDA to SCL setup time
      i2c-s3c2410: Fix bug in releasing driver

Bryan Wu (1):
      i2c: Blackfin Two Wire Interface driver

David Brownell (11):
      i2c: i2c_register_driver() cleanup
      i2c: Shrink struct i2c_client
      i2c: Class attribute cleanup
      i2c: Rename dev_to_i2c_adapter()
      i2c: i2c stack can probe()
      i2c: i2c stack can remove()
      i2c: i2c probe() and remove() documented
      i2c: Add i2c_board_info and i2c_new_device()
      i2c: Add i2c_add_numbered_adapter()
      i2c: i2c EXPORT_SYMBOL cleanup
      i2c-omap: Switch to static adapter numbering

Haavard Skinnemoen (1):
      i2c: Bitbanging I2C bus driver using the GPIO API

Jan Engelhardt (1):
      Use menuconfig objects - I2C

Jean Delvare (24):
      i2c: Kill i2c_adapter.class_dev
      i2c: i2c_adapter devices need no driver
      i2c-algo-bit: Always send a stop condition before leaving
      i2c: Emulate SMBus block read over I2C
      i2c-algo-bit: Emulate SMBus block read
      i2c-parport: Optimize binary size
      i2c-nforce2: Add support for the MCP61 and MCP65
      i2c: Cleanup the includes of <linux/i2c.h>
      scx200_acb: Fix PCI device reference count
      i2c-parport: Fix a minor race on driver unload
      i2c-parport-light: Port to the new device driver model
      i2c-elektor: Port to the new device driver model
      i2c-pca-isa: Port to the new device driver model
      i2c-algo-bit: Add i2c_bit_add_numbered_bus
      i2c: Add i2c_new_probed_device()
      i2c: Document i2c_new_device()
      i2c: Move i2c-isa-only exported symbol declarations
      i2c: Make i2c_del_driver a void function
      i2c-algo-bit: Implement a 50/50 SCL duty cycle
      i2c-algo-bit: Improve debugging
      i2c-pxa: Clean transaction stop
      i2c: Restore i2c_smbus_read_block_data
      i2c: Obsolete i2c-ixp2000, i2c-ixp4xx and scx200_i2c
      i2c: Documentation update

Ladislav Michl (1):
      i2c-algo-sgi: Comment and whitespace cleanups

Milind Arun Choudhary (1):
      i2c: SPIN_LOCK_UNLOCKED cleanup

Till Harbaum (1):
      i2c: New i2c-tiny-usb bus driver

Thanks,
-- 
Jean Delvare
