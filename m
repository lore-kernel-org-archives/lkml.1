Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZHDLd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZHDLd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZHDLdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:33:25 -0400
Received: from mga07.intel.com ([143.182.124.22]:47650 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753856AbZHDLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:33:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,321,1246863600"; 
   d="scan'208";a="172083296"
Date: Tue, 4 Aug 2009 13:35:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Jean Delvare <khali@linux-fr.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 0/22] WM831x drivers
Message-ID: <20090804113528.GB8601@sortiz.org>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 27, 2009 at 02:45:27PM +0100, Mark Brown wrote:
> The following patch series adds initial support for the WM813x series of
> PMICs.
> 
> Since these devices have functionality that crosses many subsystems the
> patches cross many kernel trees.  For clarity I'm presenting this
> initial submission as a single series but I have endeavoured to split
> things up so that the patches can be applied separately to the various
> subsystems.  In order to avoid merge issues as patches are applied the
> platform data for the devices is included in the core patches.
> 
> Due to Kconfig and Makefile collisons I've also included the patch adding
> hwmon support for the WM835x series of PMICs to the series.  Other than
> the build system updates there is no interdependence between those two
> patches.
I applied patches [1-8], the gpio one, the 2 hwmon ones and the input one.
I'll now wait for some more feedback for the remaining patches.

Thanks for your work.

Cheers,
Samuel.


> Mark Brown (22):
>       mfd: Allow multiple MFD cells with the same name
>       mfd: Initial core support for WM831x series devices
>       mfd: Add WM831x interrupt support
>       mfd: Add WM831x AUXADC support
>       mfd: Conditionally add WM831x backlight subdevice
>       mfd: Add basic WM831x OTP support
>       mfd: Export ISEL values from WM831x core
>       mfd: Hook WM831x into build system
>       backlight: Add WM831x backlight driver
>       gpio: Add WM831X GPIO driver
>       hwmon: Add WM835x PMIC hardware monitoring driver
>       hwmon: WM831x PMIC hardware monitoring driver
>       Input: Add support for the WM831x ON pin
>       leds: Add WM831x status LED driver
>       power_supply: Add driver for the PMU on WM831x PMICs
>       regulator: Add WM831x DC-DC buck convertor support
>       regulator: Add WM831x LDO support
>       regulator: Add WM831x EPE support
>       regulator: Add WM831x DC-DC boost convertor support
>       regulator: Add WM831x ISINK support
>       RTC: Add support for RTCs on Wolfson WM831x devices
>       [WATCHDOG] Add support for WM831x watchdog
> 
>  Documentation/hwmon/wm831x           |   37 +
>  Documentation/hwmon/wm8350           |   26 +
>  drivers/gpio/Kconfig                 |    7 +
>  drivers/gpio/Makefile                |    1 +
>  drivers/gpio/wm831x-gpio.c           |  252 ++++++
>  drivers/hwmon/Kconfig                |   21 +
>  drivers/hwmon/Makefile               |    2 +
>  drivers/hwmon/wm831x-hwmon.c         |  236 ++++++
>  drivers/hwmon/wm8350-hwmon.c         |  151 ++++
>  drivers/input/misc/Kconfig           |   10 +
>  drivers/input/misc/Makefile          |    1 +
>  drivers/input/misc/wm831x-on.c       |  163 ++++
>  drivers/leds/Kconfig                 |    7 +
>  drivers/leds/Makefile                |    1 +
>  drivers/leds/leds-wm831x-status.c    |  341 ++++++++
>  drivers/mfd/Kconfig                  |   10 +
>  drivers/mfd/Makefile                 |    2 +
>  drivers/mfd/mfd-core.c               |    2 +-
>  drivers/mfd/wm831x-core.c            | 1549 ++++++++++++++++++++++++++++++++++
>  drivers/mfd/wm831x-irq.c             |  559 ++++++++++++
>  drivers/mfd/wm831x-otp.c             |   83 ++
>  drivers/mfd/wm8350-core.c            |    3 +
>  drivers/power/Kconfig                |    7 +
>  drivers/power/Makefile               |    1 +
>  drivers/power/wm831x_power.c         |  779 +++++++++++++++++
>  drivers/regulator/Kconfig            |    7 +
>  drivers/regulator/Makefile           |    3 +
>  drivers/regulator/wm831x-dcdc.c      |  862 +++++++++++++++++++
>  drivers/regulator/wm831x-isink.c     |  260 ++++++
>  drivers/regulator/wm831x-ldo.c       |  852 +++++++++++++++++++
>  drivers/rtc/Kconfig                  |   10 +
>  drivers/rtc/Makefile                 |    1 +
>  drivers/rtc/rtc-wm831x.c             |  538 ++++++++++++
>  drivers/video/backlight/Kconfig      |    7 +
>  drivers/video/backlight/Makefile     |    1 +
>  drivers/video/backlight/wm831x_bl.c  |  250 ++++++
>  drivers/watchdog/Kconfig             |    7 +
>  drivers/watchdog/Makefile            |    1 +
>  drivers/watchdog/wm831x_wdt.c        |  441 ++++++++++
>  include/linux/mfd/core.h             |    1 +
>  include/linux/mfd/wm831x/auxadc.h    |  216 +++++
>  include/linux/mfd/wm831x/core.h      |  289 +++++++
>  include/linux/mfd/wm831x/gpio.h      |   55 ++
>  include/linux/mfd/wm831x/irq.h       |  764 +++++++++++++++++
>  include/linux/mfd/wm831x/otp.h       |  162 ++++
>  include/linux/mfd/wm831x/pdata.h     |  113 +++
>  include/linux/mfd/wm831x/pmu.h       |  189 +++++
>  include/linux/mfd/wm831x/regulator.h | 1218 ++++++++++++++++++++++++++
>  include/linux/mfd/wm831x/status.h    |   34 +
>  include/linux/mfd/wm831x/watchdog.h  |   52 ++
>  include/linux/mfd/wm8350/core.h      |    6 +
>  51 files changed, 10589 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/hwmon/wm831x
>  create mode 100644 Documentation/hwmon/wm8350
>  create mode 100644 drivers/gpio/wm831x-gpio.c
>  create mode 100644 drivers/hwmon/wm831x-hwmon.c
>  create mode 100644 drivers/hwmon/wm8350-hwmon.c
>  create mode 100644 drivers/input/misc/wm831x-on.c
>  create mode 100644 drivers/leds/leds-wm831x-status.c
>  create mode 100644 drivers/mfd/wm831x-core.c
>  create mode 100644 drivers/mfd/wm831x-irq.c
>  create mode 100644 drivers/mfd/wm831x-otp.c
>  create mode 100644 drivers/power/wm831x_power.c
>  create mode 100644 drivers/regulator/wm831x-dcdc.c
>  create mode 100644 drivers/regulator/wm831x-isink.c
>  create mode 100644 drivers/regulator/wm831x-ldo.c
>  create mode 100644 drivers/rtc/rtc-wm831x.c
>  create mode 100644 drivers/video/backlight/wm831x_bl.c
>  create mode 100644 drivers/watchdog/wm831x_wdt.c
>  create mode 100644 include/linux/mfd/wm831x/auxadc.h
>  create mode 100644 include/linux/mfd/wm831x/core.h
>  create mode 100644 include/linux/mfd/wm831x/gpio.h
>  create mode 100644 include/linux/mfd/wm831x/irq.h
>  create mode 100644 include/linux/mfd/wm831x/otp.h
>  create mode 100644 include/linux/mfd/wm831x/pdata.h
>  create mode 100644 include/linux/mfd/wm831x/pmu.h
>  create mode 100644 include/linux/mfd/wm831x/regulator.h
>  create mode 100644 include/linux/mfd/wm831x/status.h
>  create mode 100644 include/linux/mfd/wm831x/watchdog.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
