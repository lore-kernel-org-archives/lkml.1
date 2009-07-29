Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZG2RGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZG2RGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZG2RGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:06:06 -0400
Received: from ru.mvista.com ([213.79.90.228]:28676 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755942AbZG2RFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:05:11 -0400
Date: Wed, 29 Jul 2009 21:05:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 4/7] spi: Prefix modalias with "spi:"
Message-ID: <20090729170510.GD4803@oksana.dev.rtsoft.ru>
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it consistent with other buses (platform, i2c, vio, ...).
I'm not sure why we use the prefixes, but there must be a reason.

This was easy enough to do it, and I did it.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/max7301.c                 |    1 +
 drivers/gpio/mcp23s08.c                |    1 +
 drivers/hwmon/adcxx.c                  |    8 ++++----
 drivers/hwmon/lis3lv02d_spi.c          |    2 +-
 drivers/hwmon/lm70.c                   |    2 ++
 drivers/hwmon/max1111.c                |    1 +
 drivers/input/touchscreen/ad7877.c     |    1 +
 drivers/input/touchscreen/ad7879.c     |    1 +
 drivers/input/touchscreen/ads7846.c    |    1 +
 drivers/leds/leds-dac124s085.c         |    1 +
 drivers/mfd/ezx-pcap.c                 |    1 +
 drivers/misc/eeprom/at25.c             |    2 +-
 drivers/mmc/host/mmc_spi.c             |    1 +
 drivers/mtd/devices/mtd_dataflash.c    |    1 +
 drivers/net/enc28j60.c                 |    1 +
 drivers/net/ks8851.c                   |    1 +
 drivers/net/wireless/libertas/if_spi.c |    1 +
 drivers/net/wireless/p54/p54spi.c      |    1 +
 drivers/net/wireless/wl12xx/main.c     |    1 +
 drivers/rtc/rtc-ds1305.c               |    1 +
 drivers/rtc/rtc-ds1390.c               |    1 +
 drivers/rtc/rtc-ds3234.c               |    1 +
 drivers/rtc/rtc-m41t94.c               |    1 +
 drivers/rtc/rtc-max6902.c              |    1 +
 drivers/rtc/rtc-r9701.c                |    1 +
 drivers/rtc/rtc-rs5c348.c              |    1 +
 drivers/serial/max3100.c               |    1 +
 drivers/spi/spi.c                      |    3 ++-
 drivers/spi/spidev.c                   |    1 +
 drivers/spi/tle62x0.c                  |    1 +
 drivers/staging/stlc45xx/stlc45xx.c    |    1 +
 drivers/video/backlight/corgi_lcd.c    |    1 +
 drivers/video/backlight/ltv350qv.c     |    1 +
 drivers/video/backlight/tdo24m.c       |    1 +
 drivers/video/backlight/tosa_lcd.c     |    2 +-
 drivers/video/backlight/vgg2432a4.c    |    3 +--
 include/linux/mod_devicetable.h        |    1 +
 scripts/mod/file2alias.c               |    4 ++--
 38 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/max7301.c b/drivers/gpio/max7301.c
index 7b82eaa..480956f 100644
--- a/drivers/gpio/max7301.c
+++ b/drivers/gpio/max7301.c
@@ -339,3 +339,4 @@ module_exit(max7301_exit);
 MODULE_AUTHOR("Juergen Beisert");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MAX7301 SPI based GPIO-Expander");
+MODULE_ALIAS("spi:" DRIVER_NAME);
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index f6fae0e..c6c7aa1 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -433,3 +433,4 @@ static void __exit mcp23s08_exit(void)
 module_exit(mcp23s08_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:mcp23s08");
diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index 242294d..7a89fba 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -323,7 +323,7 @@ MODULE_AUTHOR("Marc Pignat");
 MODULE_DESCRIPTION("National Semiconductor adcxx8sxxx Linux driver");
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS("adcxx1s");
-MODULE_ALIAS("adcxx2s");
-MODULE_ALIAS("adcxx4s");
-MODULE_ALIAS("adcxx8s");
+MODULE_ALIAS("spi:adcxx1s");
+MODULE_ALIAS("spi:adcxx2s");
+MODULE_ALIAS("spi:adcxx4s");
+MODULE_ALIAS("spi:adcxx8s");
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index 3827ff0..b7aed07 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -112,4 +112,4 @@ module_exit(lis302dl_exit);
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("lis3lv02d SPI glue layer");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("spi:" DRV_NAME);
diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index ae6204f..d55cc7c 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -244,3 +244,5 @@ module_exit(cleanup_lm70);
 MODULE_AUTHOR("Kaiwan N Billimoria");
 MODULE_DESCRIPTION("NS LM70 / TI TMP121/TMP123 Linux driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:tmp121");
+MODULE_ALIAS("spi:lm70");
diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index bfaa665..9ac4972 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -242,3 +242,4 @@ module_exit(max1111_exit);
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_DESCRIPTION("MAX1111 ADC Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:max1111");
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index ecaeb7e..eb83939 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -842,3 +842,4 @@ module_exit(ad7877_exit);
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7877 touchscreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ad7877");
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index 5d8a703..19b4db7 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -779,3 +779,4 @@ module_exit(ad7879_exit);
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7879(-1) touchscreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ad7879");
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index ba9d38c..09c8109 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1256,3 +1256,4 @@ module_exit(ads7846_exit);
 
 MODULE_DESCRIPTION("ADS7846 TouchScreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ads7846");
diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
index 098d9aa..2913d76 100644
--- a/drivers/leds/leds-dac124s085.c
+++ b/drivers/leds/leds-dac124s085.c
@@ -148,3 +148,4 @@ module_exit(dac124s085_leds_exit);
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
 MODULE_DESCRIPTION("DAC124S085 LED driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("spi:dac124s085");
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index c1de4af..1672f30 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -505,3 +505,4 @@ module_exit(ezx_pcap_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
 MODULE_DESCRIPTION("Motorola PCAP2 ASIC Driver");
+MODULE_ALIAS("spi:ezx-pcap");
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index b34cb5f..d564de0 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -417,4 +417,4 @@ module_exit(at25_exit);
 MODULE_DESCRIPTION("Driver for most SPI EEPROMs");
 MODULE_AUTHOR("David Brownell");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("spi:at25");
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index a461017..d55fe4f 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1562,3 +1562,4 @@ MODULE_AUTHOR("Mike Lavender, David Brownell, "
 		"Hans-Peter Nilsson, Jan Nikitenko");
 MODULE_DESCRIPTION("SPI SD/MMC host driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:mmc_spi");
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 43976aa..211c27a 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -966,3 +966,4 @@ module_exit(dataflash_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andrew Victor, David Brownell");
 MODULE_DESCRIPTION("MTD DataFlash driver");
+MODULE_ALIAS("spi:mtd_dataflash");
diff --git a/drivers/net/enc28j60.c b/drivers/net/enc28j60.c
index fc6cc03..c709571 100644
--- a/drivers/net/enc28j60.c
+++ b/drivers/net/enc28j60.c
@@ -1665,3 +1665,4 @@ MODULE_AUTHOR("Claudio Lanconelli <lanconelli.claudio@eptar.com>");
 MODULE_LICENSE("GPL");
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., ffff=all)");
+MODULE_ALIAS("spi:" DRV_NAME);
diff --git a/drivers/net/ks8851.c b/drivers/net/ks8851.c
index 9a1dea6..fe7cf4f 100644
--- a/drivers/net/ks8851.c
+++ b/drivers/net/ks8851.c
@@ -1320,3 +1320,4 @@ MODULE_LICENSE("GPL");
 
 module_param_named(message, msg_enable, int, 0);
 MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
+MODULE_ALIAS("spi:ks8851");
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 6564282..ea45765 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1222,3 +1222,4 @@ MODULE_DESCRIPTION("Libertas SPI WLAN Driver");
 MODULE_AUTHOR("Andrey Yurovsky <andrey@cozybit.com>, "
 	      "Colin McCabe <colin@cozybit.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:libertas_spi");
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 72c7dbd..63bcdd1 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -767,3 +767,4 @@ module_exit(p54spi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
+MODULE_ALIAS("spi:cx3110x");
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..6416406 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1356,3 +1356,4 @@ module_exit(wl12xx_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
 		"Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_ALIAS("spi:wl12xx");
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 8f410e5..2736b11 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -841,3 +841,4 @@ module_exit(ds1305_exit);
 
 MODULE_DESCRIPTION("RTC driver for DS1305 and DS1306 chips");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-ds1305");
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index e01b955..cdb7050 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -189,3 +189,4 @@ module_exit(ds1390_exit);
 MODULE_DESCRIPTION("Dallas/Maxim DS1390/93/94 SPI RTC driver");
 MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-ds1390");
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index c51589e..a774ca3 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -188,3 +188,4 @@ module_exit(ds3234_exit);
 MODULE_DESCRIPTION("DS3234 SPI RTC driver");
 MODULE_AUTHOR("Dennis Aberilla <denzzzhome@yahoo.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ds3234");
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index c3a18c5..c8c97a4 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -171,3 +171,4 @@ module_exit(m41t94_exit);
 MODULE_AUTHOR("Kim B. Heino <Kim.Heino@bluegiga.com>");
 MODULE_DESCRIPTION("Driver for ST M41T94 SPI RTC");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-m41t94");
diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 36a8ea9..657403e 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -175,3 +175,4 @@ module_exit(max6902_exit);
 MODULE_DESCRIPTION ("max6902 spi RTC driver");
 MODULE_AUTHOR ("Raphael Assenat");
 MODULE_LICENSE ("GPL");
+MODULE_ALIAS("spi:rtc-max6902");
diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 42028f2..9beba49 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -174,3 +174,4 @@ module_exit(r9701_exit);
 MODULE_DESCRIPTION("r9701 spi RTC driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-r9701");
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index dd1e2bc..2099037 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -251,3 +251,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Ricoh RS5C348 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("spi:rtc-rs5c348");
diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
index 9fd33e5..05d36e2 100644
--- a/drivers/serial/max3100.c
+++ b/drivers/serial/max3100.c
@@ -925,3 +925,4 @@ module_exit(max3100_exit);
 MODULE_DESCRIPTION("MAX3100 driver");
 MODULE_AUTHOR("Christian Pellegrin <chripell@evolware.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:max3100");
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1431bf2..a3c9804 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/cache.h>
 #include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 
 
@@ -85,7 +86,7 @@ static int spi_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	const struct spi_device		*spi = to_spi_device(dev);
 
-	add_uevent_var(env, "MODALIAS=%s", spi->modalias);
+	add_uevent_var(env, "MODALIAS=%s%s", SPI_MODULE_PREFIX, spi->modalias);
 	return 0;
 }
 
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 606e7a4..f921bd1 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -688,3 +688,4 @@ module_exit(spidev_exit);
 MODULE_AUTHOR("Andrea Paterniani, <a.paterniani@swapp-eng.it>");
 MODULE_DESCRIPTION("User mode SPI device interface");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:spidev");
diff --git a/drivers/spi/tle62x0.c b/drivers/spi/tle62x0.c
index 455991f..bf9540f 100644
--- a/drivers/spi/tle62x0.c
+++ b/drivers/spi/tle62x0.c
@@ -329,3 +329,4 @@ module_exit(tle62x0_exit);
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("TLE62x0 SPI driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("spi:tle62x0");
diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index a137c78..38d0b24 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -2590,3 +2590,4 @@ module_exit(stlc45xx_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
+MODULE_ALIAS("spi:cx3110x");
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index f8a4bb2..2211a85 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -639,3 +639,4 @@ module_exit(corgi_lcd_exit);
 MODULE_DESCRIPTION("LCD and backlight driver for SHARP C7x0/Cxx00");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:corgi-lcd");
diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 2eb206b..4631ca8 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -328,3 +328,4 @@ module_exit(ltv350qv_exit);
 MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
 MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ltv350qv");
diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 51422fc..bbfb502 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -472,3 +472,4 @@ module_exit(tdo24m_exit);
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_DESCRIPTION("Driver for Toppoly TDO24M LCD Panel");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:tdo24m");
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index b7fbc75..50ec17d 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -300,4 +300,4 @@ module_exit(tosa_lcd_exit);
 MODULE_AUTHOR("Dmitry Baryshkov");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("LCD/Backlight control for Sharp SL-6000 PDA");
-
+MODULE_ALIAS("spi:tosa-lcd");
diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index 8e653b8..b49063c 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -280,5 +280,4 @@ module_exit(vgg2432a4_exit);
 MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
 MODULE_DESCRIPTION("VGG2432A4 LCD Driver");
 MODULE_LICENSE("GPL v2");
-
-
+MODULE_ALIAS("spi:VGG2432A4");
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 9660dca..814db86 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -402,6 +402,7 @@ struct i2c_device_id {
 /* spi */
 
 #define SPI_NAME_SIZE	20
+#define SPI_MODULE_PREFIX "spi:"
 
 struct spi_device_id {
 	char name[SPI_NAME_SIZE];
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 9d446e3..62a9025 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -657,11 +657,11 @@ static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
 	return 1;
 }
 
-/* Looks like: S */
+/* Looks like: spi:S */
 static int do_spi_entry(const char *filename, struct spi_device_id *id,
 			char *alias)
 {
-	sprintf(alias, "%s", id->name);
+	sprintf(alias, SPI_MODULE_PREFIX "%s", id->name);
 
 	return 1;
 }
-- 
1.6.3.3

