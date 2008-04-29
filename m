Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYD2VeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYD2VeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYD2VeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:34:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22509 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYD2VeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:34:00 -0400
Date: Tue, 29 Apr 2008 23:33:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT PULL] More i2c updates for 2.6.26
Message-ID: <20080429233340.240399c6@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.26 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

The biggest thing here is the long awaited conversion of the
device/driver matching model of the i2c subsystem. All new-style gpio,
hwmon and rtc i2c drivers are converted, as well as SoC video drivers.
Remaining are the bulk of video drivers, including ivtv. I couldn't get
them done in time so them will come later.

 Documentation/i2c/writing-clients          |    3 +-
 arch/arm/mach-at91/board-csb337.c          |    3 +-
 arch/arm/mach-at91/board-dk.c              |    3 +-
 arch/arm/mach-at91/board-eb9200.c          |    3 +-
 arch/arm/mach-iop32x/em7210.c              |    3 +-
 arch/arm/mach-iop32x/glantank.c            |    4 +-
 arch/arm/mach-iop32x/n2100.c               |    4 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c       |    2 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c       |    2 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c         |    2 +-
 arch/arm/mach-omap1/board-h2.c             |    2 -
 arch/arm/mach-omap1/board-h3.c             |    3 +-
 arch/arm/mach-omap1/board-osk.c            |    1 -
 arch/arm/mach-orion5x/db88f5281-setup.c    |    4 +-
 arch/arm/mach-orion5x/dns323-setup.c       |    7 +--
 arch/arm/mach-orion5x/kurobox_pro-setup.c  |    4 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c    |    4 +-
 arch/arm/mach-orion5x/ts209-setup.c        |    3 +-
 arch/arm/mach-pxa/pcm990-baseboard.c       |    5 +--
 arch/blackfin/mach-bf533/boards/stamp.c    |    3 -
 arch/blackfin/mach-bf537/boards/stamp.c    |    3 -
 arch/blackfin/mach-bf548/boards/ezkit.c    |    2 -
 arch/powerpc/sysdev/fsl_soc.c              |   27 ++++-----
 arch/sh/boards/renesas/migor/setup.c       |    3 +-
 arch/sh/boards/renesas/r7780rp/setup.c     |    3 +-
 drivers/gpio/pca953x.c                     |   24 ++------
 drivers/gpio/pcf857x.c                     |   36 +++++++-----
 drivers/hwmon/f75375s.c                    |   29 ++++++----
 drivers/i2c/busses/i2c-amd756-s4882.c      |    5 +-
 drivers/i2c/busses/i2c-piix4.c             |   10 +---
 drivers/i2c/busses/i2c-sis5595.c           |   14 +----
 drivers/i2c/busses/i2c-sis630.c            |    2 +-
 drivers/i2c/busses/i2c-stub.c              |    2 +-
 drivers/i2c/busses/i2c-taos-evm.c          |    3 +-
 drivers/i2c/chips/ds1682.c                 |   10 +++-
 drivers/i2c/chips/menelaus.c               |   10 +++-
 drivers/i2c/chips/tps65010.c               |   34 +++++-------
 drivers/i2c/chips/tsl2550.c                |   10 +++-
 drivers/i2c/i2c-core.c                     |   51 ++++++++++++++---
 drivers/media/video/cs5345.c               |    3 +-
 drivers/media/video/cs53l32a.c             |    3 +-
 drivers/media/video/cx25840/cx25840-core.c |    3 +-
 drivers/media/video/m52790.c               |    3 +-
 drivers/media/video/msp3400-driver.c       |    2 +-
 drivers/media/video/mt9m001.c              |   10 +++-
 drivers/media/video/mt9v022.c              |   10 +++-
 drivers/media/video/saa7115.c              |    3 +-
 drivers/media/video/saa7127.c              |    3 +-
 drivers/media/video/saa717x.c              |    3 +-
 drivers/media/video/tcm825x.c              |    3 +-
 drivers/media/video/tlv320aic23b.c         |    3 +-
 drivers/media/video/tuner-core.c           |    3 +-
 drivers/media/video/tvaudio.c              |    2 +-
 drivers/media/video/upd64031a.c            |    3 +-
 drivers/media/video/upd64083.c             |    3 +-
 drivers/media/video/v4l2-common.c          |    5 +-
 drivers/media/video/vp27smpx.c             |    3 +-
 drivers/media/video/wm8739.c               |    3 +-
 drivers/media/video/wm8775.c               |    3 +-
 drivers/rtc/rtc-ds1307.c                   |   66 +++++++++-------------
 drivers/rtc/rtc-ds1374.c                   |   10 +++-
 drivers/rtc/rtc-isl1208.c                  |    9 +++-
 drivers/rtc/rtc-m41t80.c                   |   81 +++++++--------------------
 drivers/rtc/rtc-pcf8563.c                  |   10 +++-
 drivers/rtc/rtc-rs5c372.c                  |   27 +++++-----
 drivers/rtc/rtc-s35390a.c                  |   10 +++-
 drivers/rtc/rtc-x1205.c                    |   10 +++-
 include/linux/i2c-id.h                     |    3 -
 include/linux/i2c.h                        |   17 +++---
 include/linux/mod_devicetable.h            |   11 ++++
 include/media/v4l2-common.h                |    4 +-
 include/media/v4l2-i2c-drv-legacy.h        |    2 +-
 include/media/v4l2-i2c-drv.h               |    2 +-
 scripts/mod/file2alias.c                   |   13 +++++
 74 files changed, 367 insertions(+), 325 deletions(-)

---------------

Jean Delvare (9):
      i2c-stub: No newline in parameter description
      i2c: Spelling fix (successful)
      i2c-piix4: Minor cleanups
      i2c-sis5595: Minor cleanups in sis5595_access
      i2c/tps65010: Add missing intialization of client data
      i2c: Drop unused RTC driver IDs
      i2c-amd756-s4882: Fix an error path
      i2c: Add support for device alias names
      i2c: Convert most new-style drivers to use module aliasing

Thanks,
-- 
Jean Delvare
