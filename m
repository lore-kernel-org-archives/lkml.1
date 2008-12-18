Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752465AbYLRF4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbYLRF4o (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 00:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYLRF4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 00:56:34 -0500
Received: from mail.openmoko.org ([88.198.124.205]:51397 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYLRF4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 00:56:33 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH V2 0/7] PCF50633 support
To: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2008 11:26:18 +0530
Message-ID: <20081218055618.31696.65002.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
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

The following series implements support for NXP PCF50633. It's basically
an I2C device with 9 regulators, an ADC, a PMIC, a Battery Charger
and a RTC.

This chip is used in Openmoko Neo Freerunner mobile phone.

Driver for a similar chip PCF50606, used in Openmoko Neo 1973 device
will follow soon.

The specs are open and are available at 
http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633DS_02.pdf

Samuel, are you ok with merging this via linux-mfd tree ?

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
 drivers/mfd/pcf50633-adc.c             |  277 +++++++++++++
 drivers/mfd/pcf50633-core.c            |  707 ++++++++++++++++++++++++++++++++
 drivers/mfd/pcf50633-gpio.c            |  118 +++++
 drivers/power/Kconfig                  |    6 
 drivers/power/Makefile                 |    2 
 drivers/power/pcf50633-charger.c       |  358 ++++++++++++++++
 drivers/regulator/Kconfig              |    7 
 drivers/regulator/Makefile             |    1 
 drivers/regulator/pcf50633-regulator.c |  330 +++++++++++++++
 drivers/rtc/Kconfig                    |    6 
 drivers/rtc/Makefile                   |    1 
 drivers/rtc/rtc-pcf50633.c             |  336 +++++++++++++++
 include/linux/mfd/pcf50633/adc.h       |   72 +++
 include/linux/mfd/pcf50633/core.h      |  218 ++++++++++
 include/linux/mfd/pcf50633/gpio.h      |   52 ++
 include/linux/mfd/pcf50633/mbc.h       |  134 ++++++
 include/linux/mfd/pcf50633/pmic.h      |   68 +++
 22 files changed, 2861 insertions(+), 1 deletions(-)
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

