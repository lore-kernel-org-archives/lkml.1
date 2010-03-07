Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0CGVwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 16:52:32 -0500
Received: from mga06.intel.com ([134.134.136.21]:43525 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754742Ab0CGVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 16:52:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,599,1262592000"; 
   d="scan'208";a="602142089"
Date: Sun, 7 Mar 2010 22:53:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Huewe <peterhuewe@gmx.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Denis Turischev <denis@compulab.co.il>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Mike Turquette <mturquette@ti.com>, Magnus Damm <damm@opensource.se>,
       Yusuke Goda <goda.yusuke@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Balaji T K <balajitk@ti.com>, Moiz Sonasath <m-sonasath@ti.com>,
       Eduardo Valentin <eduardo.valentin@nokia.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Cory Maccarrone <darkstar6262@gmail.com>, Julia Lawall <julia@diku.dk>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [GIT PULL] MFD update for 2.6.34
Message-ID: <20100307215323.GA21970@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.34 merge window.
The highlights for this round are:
- Marvell max8925 support and Marvell 88pm860x rework.
- Wolfson Microelectronics WM8994 support and a lot of updates for the many
WM8xxx devices.
- HTC HTCPLD support.
- Intel SCH LPC bridge support.
- Many subdevices support for all the above devices.
- Several drivers being converted to threaded IRQs and genirq.
- Our usual updates for the twl, AB3100 and sh_mobile drivers.

Thanks in advance for pulling this.

The following changes since commit 08b8499bdd26822df16f962db88215d02e40850a:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Balaji T K (1):
      mfd: Add twl6030 base addr for ID0, ID1, ID2

Christoph Egger (1):
      mfd: Remove leftover from discontinued TWL4030 battery patch

Cory Maccarrone (1):
      mfd: Add HTCPLD driver

Denis Turischev (3):
      mfd: Introduce lpc_sch for Intel SCH LPC bridge
      i2c: convert i2c-isch to platform_device
      gpio: add Intel SCH GPIO controller driver

Eduardo Valentin (1):
      mfd: Fix twl_has_pwrbutton typo

Guennadi Liakhovetski (1):
      tmio_mmc: Keep card-detect interrupts enabled

H Hartley Sweeten (3):
      mfd: Use resource_size() in sm501
      mfd: Use resource_size() for t7l66xb
      mfd: Use resouce_size for tc6393xb

Haojian Zhuang (21):
      mfd: Split 88pm8607 driver
      mfd: Support 88pm8606 in 860x driver
      mfd: Rename 88pm8607 to 88pm860x in mfd
      mfd: Add irq support in 88pm860x
      mfd: Append subdev into 88pm860x driver
      backlight: Enable backlight in 88pm860x
      led: Enable led in 88pm860x
      input: Enable touch on 88pm860x
      regulator: Unsupport 88pm8607 A0 and A1
      mfd: Initial max8925 support
      mfd: Add subdevs in max8925
      backlight: Enable max8925 backlight
      regulator: Add max8925 support
      mfd: Update i2c driver for max8925
      mfd: Update irq handler in max8925
      rtc: Enable rtc in max8925
      power_supply: Enable power supply of max8925
      mfd: Clean code in max8925
      mfd: Use i2c_dummy in 88pm860x
      mfd: Use genirq in 88pm860x
      input: Support onkey in 88pm860x

Joonyoung Shim (1):
      mfd: Fix WM8994 error handling

Julia Lawall (1):
      mfd: Correct use after free for t7l66xb

Linus Walleij (3):
      mfd: Convert AB3100 driver to threaded IRQ
      mfd: Use AB3100 MFD core IRQ for interrupt randomness
      mfd: Fix debugfs code in AB3100 OTP driver

Magnus Damm (5):
      tmio_mmc: Use 100ms mmc_detect_change() delay
      tmio_mmc: Remove const from platform data V3
      tmio_mmc: Balance cell enable()/disable() calls
      mfd: sh_mobile_sdhi MMC_CAP_MMC_HIGHSPEED support
      mfd/mmc: SDHI Kconfig update

Mark Brown (15):
      mfd: Add a data argument to the WM8350 IRQ free function
      rtc: Suppress duplicate enable/disable of WM8350 update interrupt
      mfd: Convert WM8350 to genirq
      mfd: Don't allow WM8350 to be built modular
      mfd: Update WM8350 drivers for changed interrupt numbers
      gpiolib: Add support for WM8350 GPIO controller
      mfd: Add WM8994 register definitions
      mfd: Add initial WM8994 support
      gpiolib: Add WM8994 GPIO support
      gpiolib: Actually set output state in wm831x_gpio_direction_output()
      gpiolib: Correct debugfs display of WM831x GPIO inversion
      mfd: Add WM831x revision B support
      gpiolib: Force wm831x GPIOs into GPIO mode when requested
      mfd: Use completion interrupt for WM835x AUXADC
      mfd: Use completion interrupt for WM831x AUXADC

Mike Turquette (2):
      mfd: Program twl4030 remap_sleep correctly
      mfd: Introduce remove_script function for twl4030

Moiz Sonasath (1):
      mfd: Disable TWL4030/5030 I2C1/I2C4 internal pull-ups

Peter Huewe (1):
      mfd: Fix ucb1x00 build failure for collie_defconfig

Randy Dunlap (2):
      mfd: htc-i2cpld depends on GPIOLIB
      mfd: Fix lpc_sch related depends/selects, fix build error

Samuel Ortiz (2):
      mfd: Check for ACPI conflicts
      gpio: Fix sch_gpio warning

Yusuke Goda (1):
      tmio_mmc: Add MMC_CAP_MMC_HIGHSPEED support V2

 drivers/gpio/Kconfig                    |   31 +
 drivers/gpio/Makefile                   |    3 +
 drivers/gpio/sch_gpio.c                 |  295 +++
 drivers/gpio/wm831x-gpio.c              |   45 +-
 drivers/gpio/wm8350-gpiolib.c           |  181 ++
 drivers/gpio/wm8994-gpio.c              |  204 ++
 drivers/i2c/busses/Kconfig              |    2 +
 drivers/i2c/busses/i2c-isch.c           |   68 +-
 drivers/input/misc/88pm860x_onkey.c     |  155 ++
 drivers/input/misc/Kconfig              |   10 +
 drivers/input/misc/Makefile             |    1 +
 drivers/input/touchscreen/88pm860x-ts.c |  236 ++
 drivers/input/touchscreen/Kconfig       |   12 +
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/leds/Kconfig                    |    7 +
 drivers/leds/Makefile                   |    1 +
 drivers/leds/leds-88pm860x.c            |  325 +++
 drivers/mfd/88pm8607.c                  |  302 ---
 drivers/mfd/88pm860x-core.c             |  740 ++++++
 drivers/mfd/88pm860x-i2c.c              |  236 ++
 drivers/mfd/Kconfig                     |   72 +-
 drivers/mfd/Makefile                    |    8 +-
 drivers/mfd/ab3100-core.c               |   54 +-
 drivers/mfd/ab3100-otp.c                |   13 +-
 drivers/mfd/htc-i2cpld.c                |  710 +++++
 drivers/mfd/lpc_sch.c                   |  133 +
 drivers/mfd/max8925-core.c              |  656 +++++
 drivers/mfd/max8925-i2c.c               |  211 ++
 drivers/mfd/mfd-core.c                  |    5 +
 drivers/mfd/sh_mobile_sdhi.c            |    6 +-
 drivers/mfd/sm501.c                     |    7 +-
 drivers/mfd/t7l66xb.c                   |    4 +-
 drivers/mfd/tc6393xb.c                  |    2 +-
 drivers/mfd/twl-core.c                  |   41 +-
 drivers/mfd/twl4030-power.c             |   52 +-
 drivers/mfd/ucb1x00-core.c              |    1 +
 drivers/mfd/wm831x-core.c               |   51 +-
 drivers/mfd/wm8350-core.c               |   35 +-
 drivers/mfd/wm8350-irq.c                |  155 +-
 drivers/mfd/wm8994-core.c               |  537 ++++
 drivers/mmc/host/Kconfig                |    2 +-
 drivers/mmc/host/tmio_mmc.c             |   13 +-
 drivers/mmc/host/tmio_mmc.h             |    6 +-
 drivers/power/Kconfig                   |    7 +
 drivers/power/Makefile                  |    1 +
 drivers/power/max8925_power.c           |  534 ++++
 drivers/power/wm8350_power.c            |   26 +-
 drivers/regulator/88pm8607.c            |  318 +--
 drivers/regulator/Kconfig               |    8 +-
 drivers/regulator/Makefile              |    1 +
 drivers/regulator/max8925-regulator.c   |  306 +++
 drivers/regulator/wm8350-regulator.c    |    2 +-
 drivers/rtc/Kconfig                     |   10 +
 drivers/rtc/Makefile                    |    1 +
 drivers/rtc/rtc-max8925.c               |  314 +++
 drivers/rtc/rtc-wm8350.c                |   11 +-
 drivers/video/backlight/88pm860x_bl.c   |  304 +++
 drivers/video/backlight/Kconfig         |   13 +
 drivers/video/backlight/Makefile        |    2 +
 drivers/video/backlight/max8925_bl.c    |  200 ++
 include/linux/htcpld.h                  |   24 +
 include/linux/i2c/twl.h                 |   28 +-
 include/linux/mfd/88pm8607.h            |  217 --
 include/linux/mfd/88pm860x.h            |  375 +++
 include/linux/mfd/ab3100.h              |    3 -
 include/linux/mfd/max8925.h             |  253 ++
 include/linux/mfd/tmio.h                |    3 +-
 include/linux/mfd/ucb1x00.h             |    1 +
 include/linux/mfd/wm831x/core.h         |    6 +
 include/linux/mfd/wm831x/gpio.h         |    4 +
 include/linux/mfd/wm8350/core.h         |   49 +-
 include/linux/mfd/wm8350/gpio.h         |    1 +
 include/linux/mfd/wm8350/rtc.h          |    1 +
 include/linux/mfd/wm8994/core.h         |   54 +
 include/linux/mfd/wm8994/gpio.h         |   72 +
 include/linux/mfd/wm8994/pdata.h        |   97 +
 include/linux/mfd/wm8994/registers.h    | 4292 +++++++++++++++++++++++++++++++
 sound/soc/codecs/wm8350.c               |    8 +-
 78 files changed, 12151 insertions(+), 1024 deletions(-)
 create mode 100644 drivers/gpio/sch_gpio.c
 create mode 100644 drivers/gpio/wm8350-gpiolib.c
 create mode 100644 drivers/gpio/wm8994-gpio.c
 create mode 100644 drivers/input/misc/88pm860x_onkey.c
 create mode 100644 drivers/input/touchscreen/88pm860x-ts.c
 create mode 100644 drivers/leds/leds-88pm860x.c
 delete mode 100644 drivers/mfd/88pm8607.c
 create mode 100644 drivers/mfd/88pm860x-core.c
 create mode 100644 drivers/mfd/88pm860x-i2c.c
 create mode 100644 drivers/mfd/htc-i2cpld.c
 create mode 100644 drivers/mfd/lpc_sch.c
 create mode 100644 drivers/mfd/max8925-core.c
 create mode 100644 drivers/mfd/max8925-i2c.c
 create mode 100644 drivers/mfd/wm8994-core.c
 create mode 100644 drivers/power/max8925_power.c
 create mode 100644 drivers/regulator/max8925-regulator.c
 create mode 100644 drivers/rtc/rtc-max8925.c
 create mode 100644 drivers/video/backlight/88pm860x_bl.c
 create mode 100644 drivers/video/backlight/max8925_bl.c
 create mode 100644 include/linux/htcpld.h
 delete mode 100644 include/linux/mfd/88pm8607.h
 create mode 100644 include/linux/mfd/88pm860x.h
 create mode 100644 include/linux/mfd/max8925.h
 create mode 100644 include/linux/mfd/wm8994/core.h
 create mode 100644 include/linux/mfd/wm8994/gpio.h
 create mode 100644 include/linux/mfd/wm8994/pdata.h
 create mode 100644 include/linux/mfd/wm8994/registers.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
