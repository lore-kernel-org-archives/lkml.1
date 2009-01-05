Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZAESNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZAESNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZAESNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:13:10 -0500
Received: from mail.openmoko.org ([88.198.124.205]:37649 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZAESNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:13:09 -0500
Subject: [PATCH V3 0/7] PCF50633 support
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Date: Mon, 05 Jan 2009 23:42:42 +0530
Message-ID: <20090105181242.7559.30087.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1:
	- Subdevice specific header files now included in its respective patch.
	- Introduces pcf50633_register_irq and pcf50633_free_irq for irq
	  management
	- Many changes in how subdevices are created and information is passed
	  to them. Thanks to Alessandro Zummo for suggestions.
Changes from V2:
	- Changed RTC driver to use new alarm/update interfaces.
	- Cosmetic changes in ADC driver.

The following series implements support for NXP PCF50633. It's basically
an I2C device with 9 regulators, an ADC, a PMIC, a Battery Charger
and a RTC.

This chip is used in Openmoko Neo Freerunner mobile phone.

The specs are open and are available at 
http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633DS_02.pdf

---
Balaji Rao (7):
      mfd: PCF50633 core driver
      mfd: PCF50633 adc driver
      mfd: PCF50633 gpio support
      rtc: PCF50633 rtc driver
      power_supply: PCF50633 battery charger driver
      input: PCF50633 input driver
      regulator: PCF50633 pmic driver

 drivers/input/misc/Kconfig             |    7 
 drivers/input/misc/Makefile            |    1 
 drivers/input/misc/pcf50633-input.c    |  132 ++++++
 drivers/mfd/Kconfig                    |   23 +
 drivers/mfd/Makefile                   |    6 
 drivers/mfd/pcf50633-adc.c             |  277 ++++++++++++
 drivers/mfd/pcf50633-core.c            |  710 ++++++++++++++++++++++++++++++++
 drivers/mfd/pcf50633-gpio.c            |  118 +++++
 drivers/power/Kconfig                  |    6 
 drivers/power/Makefile                 |    1 
 drivers/power/pcf50633-charger.c       |  358 ++++++++++++++++
 drivers/regulator/Kconfig              |    7 
 drivers/regulator/Makefile             |    1 
 drivers/regulator/pcf50633-regulator.c |  329 +++++++++++++++
 drivers/rtc/Kconfig                    |    7 
 drivers/rtc/Makefile                   |    1 
 drivers/rtc/rtc-pcf50633.c             |  344 ++++++++++++++++
 include/linux/mfd/pcf50633/adc.h       |   72 +++
 include/linux/mfd/pcf50633/core.h      |  218 ++++++++++
 include/linux/mfd/pcf50633/gpio.h      |   52 ++
 include/linux/mfd/pcf50633/mbc.h       |  134 ++++++
 include/linux/mfd/pcf50633/pmic.h      |   67 +++
 22 files changed, 2870 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/pcf50633-input.c
 create mode 100644 drivers/mfd/pcf50633-adc.c
 create mode 100644 drivers/mfd/pcf50633-core.c
 create mode 100644 drivers/mfd/pcf50633-gpio.c
 create mode 100644 drivers/power/pcf50633-charger.c
 create mode 100644 drivers/regulator/pcf50633-regulator.c
 create mode 100644 drivers/rtc/rtc-pcf50633.c
 create mode 100644 include/linux/mfd/pcf50633/adc.h
 create mode 100644 include/linux/mfd/pcf50633/core.h
 create mode 100644 include/linux/mfd/pcf50633/gpio.h
 create mode 100644 include/linux/mfd/pcf50633/mbc.h
 create mode 100644 include/linux/mfd/pcf50633/pmic.h


-- 
Thanks,
Balaji Rao

