Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYA0R1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYA0R1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYA0R1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:27:46 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:64240 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753596AbYA0R1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:27:45 -0500
Date: Sun, 27 Jan 2008 18:27:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.25
Message-ID: <20080127182741.62bfe92a@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.25 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There is a new I2C chip driver (for the PCF8575 I/O expander), many
cleanups and improvements to the i2c-i801 (Intel ICH) bus driver, the
removal of several deprecated drivers, many i2c-core cleanups and
random fixes and cleanups.

 Documentation/feature-removal-schedule.txt         |   31 +--
 Documentation/i2c/busses/i2c-i801                  |    5 +-
 Documentation/i2c/busses/i2c-viapro                |    3 +-
 Documentation/i2c/chips/pcf8575                    |   72 ++++
 Documentation/i2c/i2c-stub                         |    6 +-
 Documentation/i2c/writing-clients                  |    6 +-
 arch/arm/mach-ixp4xx/avila-setup.c                 |   14 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c               |   13 +-
 arch/arm/mach-ixp4xx/ixdp425-setup.c               |   14 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c               |   14 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |   14 +-
 arch/arm/mach-omap1/board-h2.c                     |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |    2 +-
 arch/arm/mach-omap1/board-osk.c                    |    3 +-
 arch/arm/mach-omap1/leds-osk.c                     |    2 +-
 arch/arm/mach-pxa/akita-ioexp.c                    |    2 +-
 arch/arm/mach-pxa/pxa27x.c                         |    6 +
 arch/mips/au1000/common/platform.c                 |   21 +
 arch/ppc/platforms/83xx/mpc834x_sys.c              |   20 -
 arch/ppc/platforms/85xx/tqm85xx.c                  |   21 -
 arch/ppc/platforms/katana.c                        |   21 -
 drivers/i2c/algos/i2c-algo-bit.c                   |  226 ++++++-----
 drivers/i2c/algos/i2c-algo-pcf.c                   |   85 +----
 drivers/i2c/busses/Kconfig                         |   33 +-
 drivers/i2c/busses/Makefile                        |    1 -
 drivers/i2c/busses/i2c-amd756.c                    |    5 +
 drivers/i2c/busses/i2c-au1550.c                    |  177 ++++++----
 drivers/i2c/busses/i2c-au1550.h                    |   32 --
 drivers/i2c/busses/i2c-bfin-twi.c                  |    3 +-
 drivers/i2c/busses/i2c-davinci.c                   |    1 -
 drivers/i2c/busses/i2c-i801.c                      |  163 +++++---
 drivers/i2c/busses/i2c-ibm_iic.c                   |  191 +++++-----
 drivers/i2c/busses/i2c-ibm_iic.h                   |    8 +-
 drivers/i2c/busses/i2c-iop3xx.c                    |    1 -
 drivers/i2c/busses/i2c-ixp4xx.c                    |  178 ---------
 drivers/i2c/busses/i2c-mpc.c                       |   29 +-
 drivers/i2c/busses/i2c-nforce2.c                   |    1 +
 drivers/i2c/busses/i2c-omap.c                      |    2 -
 drivers/i2c/busses/i2c-pasemi.c                    |    3 +-
 drivers/i2c/busses/i2c-piix4.c                     |   41 +--
 drivers/i2c/busses/i2c-pxa.c                       |  189 +++++++--
 drivers/i2c/busses/i2c-sibyte.c                    |   29 +--
 drivers/i2c/busses/i2c-stub.c                      |   15 +-
 drivers/i2c/busses/i2c-viapro.c                    |   11 +-
 drivers/i2c/chips/Kconfig                          |   58 +--
 drivers/i2c/chips/Makefile                         |    4 +-
 drivers/i2c/chips/ds1337.c                         |  410 -------------------
 drivers/i2c/chips/ds1374.c                         |  267 -------------
 drivers/i2c/chips/eeprom.c                         |    2 +-
 drivers/i2c/chips/isp1301_omap.c                   |    2 +-
 drivers/i2c/chips/m41t00.c                         |  413 --------------------
 drivers/i2c/chips/max6875.c                        |    2 +-
 drivers/i2c/chips/pcf8574.c                        |    8 +-
 drivers/i2c/chips/pcf8575.c                        |  214 ++++++++++
 drivers/i2c/chips/pcf8591.c                        |    2 +-
 drivers/i2c/chips/tps65010.c                       |    2 +-
 drivers/i2c/chips/tsl2550.c                        |   21 +
 drivers/i2c/i2c-core.c                             |  352 ++++++++++-------
 drivers/i2c/i2c-dev.c                              |   29 +-
 drivers/macintosh/therm_windtunnel.c               |    5 +-
 drivers/media/video/dpc7146.c                      |   19 +-
 drivers/media/video/ks0127.c                       |    1 -
 drivers/media/video/mxb.c                          |   40 ++-
 drivers/media/video/vino.c                         |   22 +-
 drivers/mmc/host/omap.c                            |    2 +-
 drivers/rtc/rtc-ds1672.c                           |    2 +-
 drivers/rtc/rtc-isl1208.c                          |    2 +-
 drivers/rtc/rtc-max6900.c                          |    2 +-
 drivers/rtc/rtc-pcf8563.c                          |    2 +-
 drivers/rtc/rtc-pcf8583.c                          |    2 +-
 drivers/rtc/rtc-x1205.c                            |    2 +-
 drivers/usb/host/ohci-omap.c                       |    2 +-
 drivers/usb/host/ohci-pnx4008.c                    |    5 +-
 drivers/video/matrox/matroxfb_maven.c              |    2 +-
 drivers/video/omap/lcd_h3.c                        |    2 +-
 drivers/w1/masters/ds2482.c                        |    2 +-
 include/asm-arm/arch-ixp4xx/platform.h             |   11 -
 include/asm-arm/arch-pxa/i2c.h                     |    6 +
 include/linux/i2c-id.h                             |   63 ---
 include/linux/i2c.h                                |  126 +++----
 .../{asm-arm/arch-omap => linux/i2c}/tps65010.h    |    8 +-
 include/linux/m41t00.h                             |   50 ---
 include/media/v4l2-i2c-drv-legacy.h                |    2 +-
 sound/ppc/keywest.c                                |    3 -
 sound/soc/codecs/cs4270.c                          |    2 +-
 sound/soc/s3c24xx/neo1973_wm8753.c                 |    2 +-
 86 files changed, 1440 insertions(+), 2449 deletions(-)
 create mode 100644 Documentation/i2c/chips/pcf8575
 delete mode 100644 drivers/i2c/busses/i2c-au1550.h
 delete mode 100644 drivers/i2c/busses/i2c-ixp4xx.c
 delete mode 100644 drivers/i2c/chips/ds1337.c
 delete mode 100644 drivers/i2c/chips/ds1374.c
 delete mode 100644 drivers/i2c/chips/m41t00.c
 create mode 100644 drivers/i2c/chips/pcf8575.c
 rename include/{asm-arm/arch-omap/tps65010.h => linux/i2c/tps65010.h} (97%)
 delete mode 100644 include/linux/m41t00.h

---------------

Adrian Bunk (2):
      i2c: the scheduled I2C RTC driver removal
      i2c: some overdue driver removal

Bart Van Assche (1):
      i2c: Add support for the PCF8575 chip

David Brownell (6):
      i2c-algo-bit: Whitespace fixes (+ NAK/ARB comments)
      i2c-algo-bit: Fix NAK/ARB comments
      i2c/tps65010: move header to <linux/i2c/...>
      i2c: Stop using the redundant client list
      i2c-remove-redundant-i2c_client-list.patch
      i2c: Add i2c_new_dummy() utility

eric miao (1):
      i2c-pxa: Remove hardcoded #ifdef and use cpu_is_pxa27x

Jean Delvare (26):
      i2c-nforce2: The nForce2 can do block transactions
      i2c-stub: Mention the existence of an helper script
      i2c-stub: Use a single array for byte and word operations
      i2c-algo-pcf: Delete broken 10-bit address support
      i2c: normal_i2c can be made const (rtc drivers)
      i2c: normal_i2c can be made const (remaining drivers)
      i2c: Kill rogue driver IDs
      i2c: Don't uselessly set i2c_adapter.retries
      i2c: Deprecate drivers for I2C buses on video adapters
      i2c: Use the driver model reference counting
      i2c: Change prototypes of refcounting functions
      i2c: Drop redundant i2c_adapter.list
      i2c: Drop redundant i2c_driver.list
      i2c: Rename main mutex
      i2c-i801: Document which chip support what feature
      i2c-i801: More explicit names for chip features
      i2c-i801: Clear special mode bits as needed
      i2c-i801: Implement I2C block read support
      i2c: Discard unused driver IDs
      i2c-sibyte: Remove the bus scan module parameter
      i2c: Let the user specify PCI driver data through new_id
      i2c-piix4: Drop redundant PCI function number check
      i2c-viapro: Add support for the VT8237S
      i2c: Drivers stop using the redundant client list
      i2c: Limit locking scope in i2c_detach_client
      i2c: Drop legacy locking in i2c_new_probed_device

Jon Smirl (1):
      mpc-i2c: Propagate error values properly

Kalle Pokki (1):
      i2c-bfin-twi: Register adapter with a specific bus number

Manuel Lauss (2):
      i2c-au1550: properly terminate zero-byte transfers
      i2c-au1550: Convert to platform driver

Mark M. Hoffman (1):
      i2c: Constify client address data

Michael-Luke Jones (1):
      ixp4xx-i2c-gpio

Mike Rapoport (2):
      i2c: Support i2c_transfer in atomic contexts
      i2c-pxa: Add polling transfer

Olof Johansson (1):
      i2c-pasemi: use i2c_add_numbered_adapter()

Rodolfo Giometti (1):
      i2c/tsl2550: Add power management added

Stefan Roese (1):
      i2c-ibm_iic: Whitespace cleanup


Thanks,
-- 
Jean Delvare
