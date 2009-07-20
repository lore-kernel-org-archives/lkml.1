Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZGTNc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZGTNc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZGTNcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:32:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45888 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZGTNcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:32:51 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Balaji T K <balajitk@ti.com>,
       Rajendra Nayak <rnayak@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 2/4] ARM: OMAP: Rename all twl4030_i2c*.
Date: Mon, 20 Jul 2009 19:02:16 +0530
Message-Id: <1248096736-14197-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

 This patch renames function names like twl4030_i2c_write_u8,
 twl4030_i2c_read_u8 to twl_i2c_write_u8, twl_i2c_read_u8.
 I2C address for modules(MADC, Battery Charger, Audio, RTC)
 have changed between 4030 and 6030. Base address of these module register also
 changed. Thus twl4030_map will be different for twl4030 and twl6030.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/board-2430sdp.c      |    4 +-
 arch/arm/mach-omap2/board-3430sdp.c      |   12 +-
 arch/arm/mach-omap2/board-ldp.c          |   10 +-
 arch/arm/mach-omap2/board-omap3beagle.c  |    4 +-
 arch/arm/mach-omap2/board-omap3pandora.c |    8 +-
 arch/arm/mach-omap2/board-overo.c        |    6 +-
 drivers/gpio/twl4030-gpio.c              |   24 +++---
 drivers/mfd/twl-core.c                   |  159 ++++++++++++++++-------------
 drivers/mfd/twl4030-irq.c                |   18 ++--
 drivers/regulator/twl-regulator.c        |    8 +-
 drivers/rtc/rtc-twl.c                    |   14 ++--
 drivers/usb/otg/twl4030-usb.c            |   40 ++++----
 include/linux/i2c/twl.h                  |   73 ++++++++++----
 sound/soc/codecs/twl4030.c               |   16 ++--
 14 files changed, 223 insertions(+), 173 deletions(-)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index 7f5aac5..fa34798 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -156,13 +156,13 @@ static struct omap_board_config_kernel sdp2430_config[] = {
 };
 
 
-static struct twl4030_gpio_platform_data sdp2430_gpio_data = {
+static struct twl_gpio_platform_data sdp2430_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
 };
 
-static struct twl4030_platform_data sdp2430_twldata = {
+static struct twl_platform_data sdp2430_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
 
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index fa6645e..85193d7 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -88,7 +88,7 @@ static int sdp3430_keymap[] = {
 	0
 };
 
-static struct twl4030_keypad_data sdp3430_kp_data = {
+static struct twl_keypad_data sdp3430_kp_data = {
 	.rows		= 5,
 	.cols		= 6,
 	.keymap		= sdp3430_keymap,
@@ -198,7 +198,7 @@ static int sdp3430_batt_table[] = {
 4040,   3910,   3790,   3670,   3550
 };
 
-static struct twl4030_bci_platform_data sdp3430_bci_data = {
+static struct twl_bci_platform_data sdp3430_bci_data = {
 	.battery_tmp_tbl	= sdp3430_batt_table,
 	.tblsize		= ARRAY_SIZE(sdp3430_batt_table),
 };
@@ -260,7 +260,7 @@ static int sdp3430_twl_gpio_setup(struct device *dev,
 	return 0;
 }
 
-static struct twl4030_gpio_platform_data sdp3430_gpio_data = {
+static struct twl_gpio_platform_data sdp3430_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
@@ -269,11 +269,11 @@ static struct twl4030_gpio_platform_data sdp3430_gpio_data = {
 	.setup		= sdp3430_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data sdp3430_usb_data = {
+static struct twl_usb_data sdp3430_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_madc_platform_data sdp3430_madc_data = {
+static struct twl_madc_platform_data sdp3430_madc_data = {
 	.irq_line	= 1,
 };
 
@@ -409,7 +409,7 @@ static struct regulator_init_data sdp3430_vpll2 = {
 	.consumer_supplies	= &sdp3430_vdvi_supply,
 };
 
-static struct twl4030_platform_data sdp3430_twldata = {
+static struct twl_platform_data sdp3430_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
 
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index cf8244a..eb91056 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -101,7 +101,7 @@ static int ldp_twl4030_keymap[] = {
 	0
 };
 
-static struct twl4030_keypad_data ldp_kp_twl4030_data = {
+static struct twl_keypad_data ldp_kp_twl4030_data = {
 	.rows		= 6,
 	.cols		= 6,
 	.keymap		= ldp_twl4030_keymap,
@@ -294,17 +294,17 @@ static struct omap_board_config_kernel ldp_config[] __initdata = {
 	{ OMAP_TAG_LCD,		&ldp_lcd_config },
 };
 
-static struct twl4030_usb_data ldp_usb_data = {
+static struct twl_usb_data ldp_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_gpio_platform_data ldp_gpio_data = {
+static struct twl_gpio_platform_data ldp_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
 };
 
-static struct twl4030_madc_platform_data ldp_madc_data = {
+static struct twl_madc_platform_data ldp_madc_data = {
 	.irq_line	= 1,
 };
 
@@ -327,7 +327,7 @@ static struct regulator_init_data ldp_vmmc1 = {
 	.consumer_supplies	= &ldp_vmmc1_supply,
 };
 
-static struct twl4030_platform_data ldp_twldata = {
+static struct twl_platform_data ldp_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
 
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 455f65d..ca6bebd 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -169,7 +169,7 @@ static int beagle_twl_gpio_setup(struct device *dev,
 	return 0;
 }
 
-static struct twl4030_gpio_platform_data beagle_gpio_data = {
+static struct twl_gpio_platform_data beagle_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
@@ -249,7 +249,7 @@ static struct regulator_init_data beagle_vpll2 = {
 	.consumer_supplies	= &beagle_vdvi_supply,
 };
 
-static struct twl4030_platform_data beagle_twldata = {
+static struct twl_platform_data beagle_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 47b5ee4..046964f 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -179,7 +179,7 @@ static int pandora_keypad_map[] = {
 	KEY(5, 2, KEY_FN),
 };
 
-static struct twl4030_keypad_data pandora_kp_data = {
+static struct twl_keypad_data pandora_kp_data = {
 	.rows		= 8,
 	.cols		= 6,
 	.keymap		= pandora_keypad_map,
@@ -239,7 +239,7 @@ static int omap3pandora_twl_gpio_setup(struct device *dev,
 	return 0;
 }
 
-static struct twl4030_gpio_platform_data omap3pandora_gpio_data = {
+static struct twl_gpio_platform_data omap3pandora_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
@@ -276,11 +276,11 @@ static struct regulator_init_data pandora_vmmc2 = {
 	.consumer_supplies	= &pandora_vmmc2_supply,
 };
 
-static struct twl4030_usb_data omap3pandora_usb_data = {
+static struct twl_usb_data omap3pandora_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_platform_data omap3pandora_twldata = {
+static struct twl_platform_data omap3pandora_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
 	.gpio		= &omap3pandora_gpio_data,
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 744ff80..de9d516 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -305,14 +305,14 @@ static int overo_twl_gpio_setup(struct device *dev,
 	return 0;
 }
 
-static struct twl4030_gpio_platform_data overo_gpio_data = {
+static struct twl_gpio_platform_data overo_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
 	.setup		= overo_twl_gpio_setup,
 };
 
-static struct twl4030_usb_data overo_usb_data = {
+static struct twl_usb_data overo_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
@@ -332,7 +332,7 @@ static struct regulator_init_data overo_vmmc1 = {
 
 /* mmc2 (WLAN) and Bluetooth don't use twl4030 regulators */
 
-static struct twl4030_platform_data overo_twldata = {
+static struct twl_platform_data overo_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
 	.gpio		= &overo_gpio_data,
diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/twl4030-gpio.c
index 8446399..a93a363 100644
--- a/drivers/gpio/twl4030-gpio.c
+++ b/drivers/gpio/twl4030-gpio.c
@@ -80,7 +80,7 @@ static unsigned int gpio_usage_count;
  */
 static inline int gpio_twl4030_write(u8 address, u8 data)
 {
-	return twl4030_i2c_write_u8(TWL4030_MODULE_GPIO, data, address);
+	return twl_i2c_write_u8(TWL4030_MODULE_GPIO, data, address);
 }
 
 /*----------------------------------------------------------------------*/
@@ -117,7 +117,7 @@ static inline int gpio_twl4030_read(u8 address)
 	u8 data;
 	int ret = 0;
 
-	ret = twl4030_i2c_read_u8(TWL4030_MODULE_GPIO, &data, address);
+	ret = twl_i2c_read_u8(TWL4030_MODULE_GPIO, &data, address);
 	return (ret < 0) ? ret : data;
 }
 
@@ -142,7 +142,7 @@ static void twl4030_led_set_value(int led, int value)
 		cached_leden &= ~mask;
 	else
 		cached_leden |= mask;
-	status = twl4030_i2c_write_u8(TWL4030_MODULE_LED, cached_leden,
+	status = twl_i2c_write_u8(TWL4030_MODULE_LED, cached_leden,
 			TWL4030_LED_LEDEN);
 	mutex_unlock(&gpio_lock);
 }
@@ -223,23 +223,23 @@ static int twl_request(struct gpio_chip *chip, unsigned offset)
 		}
 
 		/* initialize PWM to always-drive */
-		status = twl4030_i2c_write_u8(module, 0x7f,
+		status = twl_i2c_write_u8(module, 0x7f,
 				TWL4030_PWMx_PWMxOFF);
 		if (status < 0)
 			goto done;
-		status = twl4030_i2c_write_u8(module, 0x7f,
+		status = twl_i2c_write_u8(module, 0x7f,
 				TWL4030_PWMx_PWMxON);
 		if (status < 0)
 			goto done;
 
 		/* init LED to not-driven (high) */
 		module = TWL4030_MODULE_LED;
-		status = twl4030_i2c_read_u8(module, &cached_leden,
+		status = twl_i2c_read_u8(module, &cached_leden,
 				TWL4030_LED_LEDEN);
 		if (status < 0)
 			goto done;
 		cached_leden &= ~ledclr_mask;
-		status = twl4030_i2c_write_u8(module, cached_leden,
+		status = twl_i2c_write_u8(module, cached_leden,
 				TWL4030_LED_LEDEN);
 		if (status < 0)
 			goto done;
@@ -250,7 +250,7 @@ static int twl_request(struct gpio_chip *chip, unsigned offset)
 
 	/* on first use, turn GPIO module "on" */
 	if (!gpio_usage_count) {
-		struct twl4030_gpio_platform_data *pdata;
+		struct twl_gpio_platform_data *pdata;
 		u8 value = MASK_GPIO_CTRL_GPIO_ON;
 
 		/* optionally have the first two GPIOs switch vMMC1
@@ -370,7 +370,7 @@ static int __devinit gpio_twl4030_pulls(u32 ups, u32 downs)
 		message[i] = bit_mask;
 	}
 
-	return twl4030_i2c_write(TWL4030_MODULE_GPIO, message,
+	return twl_i2c_write(TWL4030_MODULE_GPIO, message,
 				REG_GPIOPUPDCTR1, 5);
 }
 
@@ -387,7 +387,7 @@ static int __devinit gpio_twl4030_debounce(u32 debounce, u8 mmc_cd)
 	debounce >>= 8;
 	message[3] = (debounce & 0x03);
 
-	return twl4030_i2c_write(TWL4030_MODULE_GPIO, message,
+	return twl_i2c_write(TWL4030_MODULE_GPIO, message,
 				REG_GPIO_DEBEN1, 3);
 }
 
@@ -395,7 +395,7 @@ static int gpio_twl4030_remove(struct platform_device *pdev);
 
 static int __devinit gpio_twl4030_probe(struct platform_device *pdev)
 {
-	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct twl_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int ret;
 
 	/* maybe setup IRQs */
@@ -462,7 +462,7 @@ no_irqs:
 
 static int __devexit gpio_twl4030_remove(struct platform_device *pdev)
 {
-	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct twl_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int status;
 
 	if (pdata->teardown) {
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 97eb9a0..7cd1b01 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -55,7 +55,7 @@
  * (and associated registers).
  */
 
-#define DRIVER_NAME			"twl4030"
+#define DRIVER_NAME			"twl"
 
 #if defined(CONFIG_TWL4030_BCI_BATTERY) || \
 	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
@@ -110,11 +110,24 @@
 
 /* Triton Core internal information (BEGIN) */
 
-/* Last - for index max*/
-#define TWL4030_MODULE_LAST		TWL4030_MODULE_SECURED_REG
+#define TWL_NUM_SLAVES		4
 
-#define TWL4030_NUM_SLAVES		4
+#define SUB_CHIP_ID0 0
+#define SUB_CHIP_ID1 1
+#define SUB_CHIP_ID2 2
+#define SUB_CHIP_ID3 3
 
+#ifdef CONFIG_TWL4030_CORE
+#define USB_SUB_CHIP_ID SUB_CHIP_ID0
+#define GPIO_SUB_CHIP_ID SUB_CHIP_ID1
+#define MADC_SUB_CHIP_ID SUB_CHIP_ID2
+#define KEYPAD_SUB_CHIP_ID SUB_CHIP_ID2
+#define BCI_SUB_CHIP_ID SUB_CHIP_ID3
+#define RTC_SUB_CHIP_ID SUB_CHIP_ID3
+
+/* Last - for index max*/
+#define TWL4030_MODULE_LAST		TWL4030_MODULE_SECURED_REG
+#define TWL_MODULE_LAST TWL4030_MODULE_LAST
 
 /* Base Address defns for twl4030_map[] */
 
@@ -147,7 +160,7 @@
 #define TWL4030_BASEADD_PM_RECEIVER	0x005B
 #define TWL4030_BASEADD_RTC		0x001C
 #define TWL4030_BASEADD_SECURED_REG	0x0000
-
+#endif /* CONFIG_TWL4030_CORE */
 /* Triton Core internal information (END) */
 
 
@@ -177,7 +190,7 @@
 static bool inuse;
 
 /* Structure for each TWL4030 Slave */
-struct twl4030_client {
+struct twl_client {
 	struct i2c_client *client;
 	u8 address;
 
@@ -188,16 +201,17 @@ struct twl4030_client {
 	struct mutex xfer_lock;
 };
 
-static struct twl4030_client twl4030_modules[TWL4030_NUM_SLAVES];
+static struct twl_client twl_modules[TWL_NUM_SLAVES];
 
 
 /* mapping the module id to slave id and base address */
-struct twl4030mapping {
+struct twl_mapping {
 	unsigned char sid;	/* Slave ID */
 	unsigned char base;	/* base address */
 };
 
-static struct twl4030mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
+#ifdef CONFIG_TWL4030_CORE
+static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
 	/*
 	 * NOTE:  don't change this table without updating the
 	 * <linux/i2c/twl4030.h> defines for TWL4030_MODULE_*
@@ -230,13 +244,14 @@ static struct twl4030mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
 	{ 3, TWL4030_BASEADD_RTC },
 	{ 3, TWL4030_BASEADD_SECURED_REG },
 };
+#endif
 
 /*----------------------------------------------------------------------*/
 
 /* Exported Functions */
 
 /**
- * twl4030_i2c_write - Writes a n bit register in TWL4030
+ * twl_i2c_write - Writes a n bit register in TWL4030
  * @mod_no: module number
  * @value: an array of num_bytes+1 containing data to write
  * @reg: register address (just offset will do)
@@ -247,19 +262,19 @@ static struct twl4030mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
  *
  * Returns the result of operation - 0 is success
  */
-int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
+int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 {
 	int ret;
 	int sid;
-	struct twl4030_client *twl;
+	struct twl_client *twl;
 	struct i2c_msg *msg;
 
-	if (unlikely(mod_no > TWL4030_MODULE_LAST)) {
+	if (unlikely(mod_no > TWL_MODULE_LAST)) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
 	sid = twl4030_map[mod_no].sid;
-	twl = &twl4030_modules[sid];
+	twl = &twl_modules[sid];
 
 	if (unlikely(!inuse)) {
 		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
@@ -285,10 +300,10 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		ret = 0;
 	return ret;
 }
-EXPORT_SYMBOL(twl4030_i2c_write);
+EXPORT_SYMBOL(twl_i2c_write);
 
 /**
- * twl4030_i2c_read - Reads a n bit register in TWL4030
+ * twl_i2c_read - Reads a n bit register in TWL4030
  * @mod_no: module number
  * @value: an array of num_bytes containing data to be read
  * @reg: register address (just offset will do)
@@ -296,20 +311,20 @@ EXPORT_SYMBOL(twl4030_i2c_write);
  *
  * Returns result of operation - num_bytes is success else failure.
  */
-int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
+int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 {
 	int ret;
 	u8 val;
 	int sid;
-	struct twl4030_client *twl;
+	struct twl_client *twl;
 	struct i2c_msg *msg;
 
-	if (unlikely(mod_no > TWL4030_MODULE_LAST)) {
+	if (unlikely(mod_no > TWL_MODULE_LAST)) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
 	sid = twl4030_map[mod_no].sid;
-	twl = &twl4030_modules[sid];
+	twl = &twl_modules[sid];
 
 	if (unlikely(!inuse)) {
 		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
@@ -337,40 +352,40 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		ret = 0;
 	return ret;
 }
-EXPORT_SYMBOL(twl4030_i2c_read);
+EXPORT_SYMBOL(twl_i2c_read);
 
 /**
- * twl4030_i2c_write_u8 - Writes a 8 bit register in TWL4030
+ * twl_i2c_write_u8 - Writes a 8 bit register in TWL4030
  * @mod_no: module number
  * @value: the value to be written 8 bit
  * @reg: register address (just offset will do)
  *
  * Returns result of operation - 0 is success
  */
-int twl4030_i2c_write_u8(u8 mod_no, u8 value, u8 reg)
+int twl_i2c_write_u8(u8 mod_no, u8 value, u8 reg)
 {
 
 	/* 2 bytes offset 1 contains the data offset 0 is used by i2c_write */
 	u8 temp_buffer[2] = { 0 };
 	/* offset 1 contains the data */
 	temp_buffer[1] = value;
-	return twl4030_i2c_write(mod_no, temp_buffer, reg, 1);
+	return twl_i2c_write(mod_no, temp_buffer, reg, 1);
 }
-EXPORT_SYMBOL(twl4030_i2c_write_u8);
+EXPORT_SYMBOL(twl_i2c_write_u8);
 
 /**
- * twl4030_i2c_read_u8 - Reads a 8 bit register from TWL4030
+ * twl_i2c_read_u8 - Reads a 8 bit register from TWL4030
  * @mod_no: module number
  * @value: the value read 8 bit
  * @reg: register address (just offset will do)
  *
  * Returns result of operation - 0 is success
  */
-int twl4030_i2c_read_u8(u8 mod_no, u8 *value, u8 reg)
+int twl_i2c_read_u8(u8 mod_no, u8 *value, u8 reg)
 {
-	return twl4030_i2c_read(mod_no, value, reg, 1);
+	return twl_i2c_read(mod_no, value, reg, 1);
 }
-EXPORT_SYMBOL(twl4030_i2c_read_u8);
+EXPORT_SYMBOL(twl_i2c_read_u8);
 
 /*----------------------------------------------------------------------*/
 
@@ -380,7 +395,7 @@ add_numbered_child(unsigned chip, const char *name, int num,
 		bool can_wakeup, int irq0, int irq1)
 {
 	struct platform_device	*pdev;
-	struct twl4030_client	*twl = &twl4030_modules[chip];
+	struct twl_client	*twl = &twl_modules[chip];
 	int			status;
 
 	pdev = platform_device_alloc(name, num);
@@ -465,41 +480,42 @@ add_regulator(int num, struct regulator_init_data *pdata)
  */
 
 static int
-add_children(struct twl4030_platform_data *pdata, unsigned long features)
+add_children(struct twl_platform_data *pdata, unsigned long features)
 {
 	struct device	*child;
 	struct device	*usb_transceiver = NULL;
 
 	if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
-		child = add_child(3, "twl4030_bci",
+		child = add_child(BCI_SUB_CHIP_ID, "twl4030_bci",
 				pdata->bci, sizeof(*pdata->bci),
 				false,
 				/* irq0 = CHG_PRES, irq1 = BCI */
-				pdata->irq_base + 8 + 1, pdata->irq_base + 2);
+				pdata->irq_base + BCI_PRES_INTR_OFFSET,
+				pdata->irq_base + BCI_INTR_OFFSET);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (twl_has_gpio() && pdata->gpio) {
-		child = add_child(1, "twl4030_gpio",
+		child = add_child(GPIO_SUB_CHIP_ID, "twl4030_gpio",
 				pdata->gpio, sizeof(*pdata->gpio),
-				false, pdata->irq_base + 0, 0);
+				false, pdata->irq_base + GPIO_INTR_OFFSET, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (twl_has_keypad() && pdata->keypad) {
-		child = add_child(2, "twl4030_keypad",
+		child = add_child(KEYPAD_SUB_CHIP_ID, "twl4030_keypad",
 				pdata->keypad, sizeof(*pdata->keypad),
-				true, pdata->irq_base + 1, 0);
+				true, pdata->irq_base + KEYPAD_INTR_OFFSET, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (twl_has_madc() && pdata->madc) {
-		child = add_child(2, "twl4030_madc",
+		child = add_child(MADC_SUB_CHIP_ID, "twl4030_madc",
 				pdata->madc, sizeof(*pdata->madc),
-				true, pdata->irq_base + 3, 0);
+				true, pdata->irq_base + MADC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
@@ -512,19 +528,20 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		 * Eventually, Linux might become more aware of such
 		 * HW security concerns, and "least privilege".
 		 */
-		child = add_child(3, "twl4030_rtc",
+		child = add_child(RTC_SUB_CHIP_ID, "twl4030_rtc",
 				NULL, 0,
-				true, pdata->irq_base + 8 + 3, 0);
+				true, pdata->irq_base + RTC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (twl_has_usb() && pdata->usb) {
-		child = add_child(0, "twl4030_usb",
+		child = add_child(USB_SUB_CHIP_ID, "twl4030_usb",
 				pdata->usb, sizeof(*pdata->usb),
 				true,
 				/* irq0 = USB_PRES, irq1 = USB */
-				pdata->irq_base + 8 + 2, pdata->irq_base + 4);
+				pdata->irq_base + USB_PRES_INTR_OFFSET,
+				pdata->irq_base + USB_INTR_OFFSET);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 
@@ -643,7 +660,7 @@ static inline int __init protect_pm_master(void)
 {
 	int e = 0;
 
-	e = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_LOCK,
+	e = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_LOCK,
 			R_PROTECT_KEY);
 	return e;
 }
@@ -652,9 +669,9 @@ static inline int __init unprotect_pm_master(void)
 {
 	int e = 0;
 
-	e |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_UNLOCK1,
+	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_UNLOCK1,
 			R_PROTECT_KEY);
-	e |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_UNLOCK2,
+	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_UNLOCK2,
 			R_PROTECT_KEY);
 	return e;
 }
@@ -673,7 +690,7 @@ static void clocks_init(struct device *dev)
 		osc = clk_get(dev, "osc_sys_ck");
 
 	if (IS_ERR(osc)) {
-		printk(KERN_WARNING "Skipping twl4030 internal clock init and "
+		printk(KERN_WARNING "Skipping twl internal clock init and "
 				"using bootloader value (unknown osc rate)\n");
 		return;
 	}
@@ -687,7 +704,7 @@ static void clocks_init(struct device *dev)
 	 */
 	osc = ERR_PTR(-EIO);
 
-	printk(KERN_WARNING "Skipping twl4030 internal clock init and "
+	printk(KERN_WARNING "Skipping twl internal clock init and "
 	       "using bootloader value (unknown osc rate)\n");
 
 	return;
@@ -708,7 +725,7 @@ static void clocks_init(struct device *dev)
 	ctrl |= HIGH_PERF_SQ;
 	e |= unprotect_pm_master();
 	/* effect->MADC+USB ck en */
-	e |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, ctrl, R_CFG_BOOT);
+	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, ctrl, R_CFG_BOOT);
 	e |= protect_pm_master();
 
 	if (e < 0)
@@ -717,7 +734,7 @@ static void clocks_init(struct device *dev)
 
 /*----------------------------------------------------------------------*/
 
-static int twl4030_remove(struct i2c_client *client)
+static int twl_remove(struct i2c_client *client)
 {
 	unsigned i;
 	int status;
@@ -726,12 +743,12 @@ static int twl4030_remove(struct i2c_client *client)
 	if (status < 0)
 		return status;
 
-	for (i = 0; i < TWL4030_NUM_SLAVES; i++) {
-		struct twl4030_client	*twl = &twl4030_modules[i];
+	for (i = 0; i < TWL_NUM_SLAVES; i++) {
+		struct twl_client	*twl = &twl_modules[i];
 
 		if (twl->client && twl->client != client)
 			i2c_unregister_device(twl->client);
-		twl4030_modules[i].client = NULL;
+		twl_modules[i].client = NULL;
 	}
 	inuse = false;
 	return 0;
@@ -739,11 +756,11 @@ static int twl4030_remove(struct i2c_client *client)
 
 /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
 static int
-twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
+twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
 	unsigned			i;
-	struct twl4030_platform_data	*pdata = client->dev.platform_data;
+	struct twl_platform_data	*pdata = client->dev.platform_data;
 
 	if (!pdata) {
 		dev_dbg(&client->dev, "no platform data?\n");
@@ -760,8 +777,8 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -EBUSY;
 	}
 
-	for (i = 0; i < TWL4030_NUM_SLAVES; i++) {
-		struct twl4030_client	*twl = &twl4030_modules[i];
+	for (i = 0; i < TWL_NUM_SLAVES; i++) {
+		struct twl_client	*twl = &twl_modules[i];
 
 		twl->address = client->addr + i;
 		if (i == 0)
@@ -798,11 +815,11 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	status = add_children(pdata, id->driver_data);
 fail:
 	if (status < 0)
-		twl4030_remove(client);
+		twl_remove(client);
 	return status;
 }
 
-static const struct i2c_device_id twl4030_ids[] = {
+static const struct i2c_device_id twl_ids[] = {
 	{ "twl4030", TWL4030_VAUX2 },	/* "Triton 2" */
 	{ "twl5030", 0 },		/* T2 updated */
 	{ "tps65950", 0 },		/* catalog version of twl5030 */
@@ -810,28 +827,28 @@ static const struct i2c_device_id twl4030_ids[] = {
 	{ "tps65920", TPS_SUBSET },	/* fewer LDOs; no codec or charger */
 	{ /* end of list */ },
 };
-MODULE_DEVICE_TABLE(i2c, twl4030_ids);
+MODULE_DEVICE_TABLE(i2c, twl_ids);
 
 /* One Client Driver , 4 Clients */
-static struct i2c_driver twl4030_driver = {
+static struct i2c_driver twl_driver = {
 	.driver.name	= DRIVER_NAME,
-	.id_table	= twl4030_ids,
-	.probe		= twl4030_probe,
-	.remove		= twl4030_remove,
+	.id_table	= twl_ids,
+	.probe		= twl_probe,
+	.remove		= twl_remove,
 };
 
-static int __init twl4030_init(void)
+static int __init twl_init(void)
 {
-	return i2c_add_driver(&twl4030_driver);
+	return i2c_add_driver(&twl_driver);
 }
-subsys_initcall(twl4030_init);
+subsys_initcall(twl_init);
 
-static void __exit twl4030_exit(void)
+static void __exit twl_exit(void)
 {
-	i2c_del_driver(&twl4030_driver);
+	i2c_del_driver(&twl_driver);
 }
-module_exit(twl4030_exit);
+module_exit(twl_exit);
 
 MODULE_AUTHOR("Texas Instruments, Inc.");
-MODULE_DESCRIPTION("I2C Core interface for TWL4030");
+MODULE_DESCRIPTION("I2C Core interface for TWL");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 6827e8f..6e55da4 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -199,7 +199,7 @@ static int twl4030_irq_thread(void *data)
 		/* Wait for IRQ, then read PIH irq status (also blocking) */
 		wait_for_completion_interruptible(&irq_event);
 
-		ret = twl4030_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
+		ret = twl_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
 					  REG_PIH_ISR_P1);
 		if (ret) {
 			pr_warning("twl4030: I2C error %d reading PIH ISR\n",
@@ -307,7 +307,7 @@ static int twl4030_init_sih_modules(unsigned line)
 		if (!sih->bytes_ixr)
 			continue;
 
-		status = twl4030_i2c_write(sih->module, buf,
+		status = twl_i2c_write(sih->module, buf,
 				sih->mask[line].imr_offset, sih->bytes_ixr);
 		if (status < 0)
 			pr_err("twl4030: err %d initializing %s %s\n",
@@ -321,7 +321,7 @@ static int twl4030_init_sih_modules(unsigned line)
 		 * And for PWR_INT it's not documented...
 		 */
 		if (sih->set_cor) {
-			status = twl4030_i2c_write_u8(sih->module,
+			status = twl_i2c_write_u8(sih->module,
 					TWL4030_SIH_CTRL_COR_MASK,
 					sih->control_offset);
 			if (status < 0)
@@ -345,14 +345,14 @@ static int twl4030_init_sih_modules(unsigned line)
 		 * uncommon with PWR_INT.PWRON.
 		 */
 		for (j = 0; j < 2; j++) {
-			status = twl4030_i2c_read(sih->module, rxbuf,
+			status = twl_i2c_read(sih->module, rxbuf,
 				sih->mask[line].isr_offset, sih->bytes_ixr);
 			if (status < 0)
 				pr_err("twl4030: err %d initializing %s %s\n",
 					status, sih->name, "ISR");
 
 			if (!sih->set_cor)
-				status = twl4030_i2c_write(sih->module, buf,
+				status = twl_i2c_write(sih->module, buf,
 					sih->mask[line].isr_offset,
 					sih->bytes_ixr);
 			/* else COR=1 means read sufficed.
@@ -421,7 +421,7 @@ static void twl4030_sih_do_mask(struct work_struct *work)
 		return;
 
 	/* write the whole mask ... simpler than subsetting it */
-	status = twl4030_i2c_write(sih->module, imr.bytes,
+	status = twl_i2c_write(sih->module, imr.bytes,
 			sih->mask[irq_line].imr_offset, sih->bytes_ixr);
 	if (status)
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
@@ -452,7 +452,7 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 	 * any processor on the other IRQ line, EDR registers are
 	 * shared.
 	 */
-	status = twl4030_i2c_read(sih->module, bytes + 1,
+	status = twl_i2c_read(sih->module, bytes + 1,
 			sih->edr_offset, sih->bytes_edr);
 	if (status) {
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
@@ -486,7 +486,7 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 	}
 
 	/* Write */
-	status = twl4030_i2c_write(sih->module, bytes,
+	status = twl_i2c_write(sih->module, bytes,
 			sih->edr_offset, sih->bytes_edr);
 	if (status)
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
@@ -571,7 +571,7 @@ static inline int sih_read_isr(const struct sih *sih)
 	/* FIXME need retry-on-error ... */
 
 	isr.word = 0;
-	status = twl4030_i2c_read(sih->module, isr.bytes,
+	status = twl_i2c_read(sih->module, isr.bytes,
 			sih->mask[irq_line].isr_offset, sih->bytes_ixr);
 
 	return (status < 0) ? status : le32_to_cpu(isr.word);
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 78b618f..68c941d 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -64,7 +64,7 @@ twl4030reg_read(struct twlreg_info *info, unsigned offset)
 	u8 value;
 	int status;
 
-	status = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER,
+	status = twl_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER,
 			&value, info->base + offset);
 	return (status < 0) ? status : value;
 }
@@ -72,7 +72,7 @@ twl4030reg_read(struct twlreg_info *info, unsigned offset)
 static inline int
 twl4030reg_write(struct twlreg_info *info, unsigned offset, u8 value)
 {
-	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+	return twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
 			value, info->base + offset);
 }
 
@@ -171,12 +171,12 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
 	if (!(status & (P3_GRP | P2_GRP | P1_GRP)))
 		return -EACCES;
 
-	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+	status = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
 			message >> 8, 0x15/* PB_WORD_MSB */);
 	if (status >= 0)
 		return status;
 
-	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+	return twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
 			message, 0x16/* PB_WORD_LSB */);
 }
 
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 93565be..6119712 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -92,7 +92,7 @@ static int twl4030_rtc_read_u8(u8 *data, u8 reg)
 {
 	int ret;
 
-	ret = twl4030_i2c_read_u8(TWL4030_MODULE_RTC, data, reg);
+	ret = twl_i2c_read_u8(TWL4030_MODULE_RTC, data, reg);
 	if (ret < 0)
 		pr_err("twl4030_rtc: Could not read TWL4030"
 		       "register %X - error %d\n", reg, ret);
@@ -106,7 +106,7 @@ static int twl4030_rtc_write_u8(u8 data, u8 reg)
 {
 	int ret;
 
-	ret = twl4030_i2c_write_u8(TWL4030_MODULE_RTC, data, reg);
+	ret = twl_i2c_write_u8(TWL4030_MODULE_RTC, data, reg);
 	if (ret < 0)
 		pr_err("twl4030_rtc: Could not write TWL4030"
 		       "register %X - error %d\n", reg, ret);
@@ -201,7 +201,7 @@ static int twl4030_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	if (ret < 0)
 		return ret;
 
-	ret = twl4030_i2c_read(TWL4030_MODULE_RTC, rtc_data,
+	ret = twl_i2c_read(TWL4030_MODULE_RTC, rtc_data,
 			       REG_SECONDS_REG, ALL_TIME_REGS);
 
 	if (ret < 0) {
@@ -243,7 +243,7 @@ static int twl4030_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		goto out;
 
 	/* update all the time registers in one shot */
-	ret = twl4030_i2c_write(TWL4030_MODULE_RTC, rtc_data,
+	ret = twl_i2c_write(TWL4030_MODULE_RTC, rtc_data,
 			REG_SECONDS_REG, ALL_TIME_REGS);
 	if (ret < 0) {
 		dev_err(dev, "rtc_set_time error %d\n", ret);
@@ -266,7 +266,7 @@ static int twl4030_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 
-	ret = twl4030_i2c_read(TWL4030_MODULE_RTC, rtc_data,
+	ret = twl_i2c_read(TWL4030_MODULE_RTC, rtc_data,
 			       REG_ALARM_SECONDS_REG, ALL_TIME_REGS);
 	if (ret < 0) {
 		dev_err(dev, "rtc_read_alarm error %d\n", ret);
@@ -305,7 +305,7 @@ static int twl4030_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	alarm_data[6] = bin2bcd(alm->time.tm_year - 100);
 
 	/* update all the alarm registers in one shot */
-	ret = twl4030_i2c_write(TWL4030_MODULE_RTC, alarm_data,
+	ret = twl_i2c_write(TWL4030_MODULE_RTC, alarm_data,
 			REG_ALARM_SECONDS_REG, ALL_TIME_REGS);
 	if (ret) {
 		dev_err(dev, "rtc_set_alarm error %d\n", ret);
@@ -363,7 +363,7 @@ static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
 	 * risk wrongly clearing status for some other IRQ (losing
 	 * the interrupt).  Be smarter about handling RTC_UF ...
 	 */
-	res = twl4030_i2c_read_u8(TWL4030_MODULE_INT,
+	res = twl_i2c_read_u8(TWL4030_MODULE_INT,
 			&rd_reg, TWL4030_INT_PWR_ISR1);
 	if (res)
 		goto out;
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 591334d..60fbf46 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -258,7 +258,7 @@ struct twl4030_usb {
 	spinlock_t		lock;
 
 	/* pin configuration */
-	enum twl4030_usb_mode	usb_mode;
+	enum twl_usb_mode	usb_mode;
 
 	int			irq;
 	u8			linkstat;
@@ -276,16 +276,16 @@ static int twl4030_i2c_write_u8_verify(struct twl4030_usb *twl,
 {
 	u8 check;
 
-	if ((twl4030_i2c_write_u8(module, data, address) >= 0) &&
-	    (twl4030_i2c_read_u8(module, &check, address) >= 0) &&
+	if ((twl_i2c_write_u8(module, data, address) >= 0) &&
+	    (twl_i2c_read_u8(module, &check, address) >= 0) &&
 						(check == data))
 		return 0;
 	dev_dbg(twl->dev, "Write%d[%d,0x%x] wrote %02x but read %02x\n",
 			1, module, address, check, data);
 
 	/* Failed once: Try again */
-	if ((twl4030_i2c_write_u8(module, data, address) >= 0) &&
-	    (twl4030_i2c_read_u8(module, &check, address) >= 0) &&
+	if ((twl_i2c_write_u8(module, data, address) >= 0) &&
+	    (twl_i2c_read_u8(module, &check, address) >= 0) &&
 						(check == data))
 		return 0;
 	dev_dbg(twl->dev, "Write%d[%d,0x%x] wrote %02x but read %02x\n",
@@ -303,7 +303,7 @@ static inline int twl4030_usb_write(struct twl4030_usb *twl,
 {
 	int ret = 0;
 
-	ret = twl4030_i2c_write_u8(TWL4030_MODULE_USB, data, address);
+	ret = twl_i2c_write_u8(TWL4030_MODULE_USB, data, address);
 	if (ret < 0)
 		dev_dbg(twl->dev,
 			"TWL4030:USB:Write[0x%x] Error %d\n", address, ret);
@@ -315,7 +315,7 @@ static inline int twl4030_readb(struct twl4030_usb *twl, u8 module, u8 address)
 	u8 data;
 	int ret = 0;
 
-	ret = twl4030_i2c_read_u8(module, &data, address);
+	ret = twl_i2c_read_u8(module, &data, address);
 	if (ret >= 0)
 		ret = data;
 	else
@@ -462,7 +462,7 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 		 * SLEEP. We work around this by clearing the bit after usv3v1
 		 * is re-activated. This ensures that VUSB3V1 is really active.
 		 */
-		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0,
+		twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0,
 							VUSB_DEDICATED2);
 		regulator_enable(twl->usb1v5);
 		pwr &= ~PHY_PWR_PHYPWD;
@@ -505,44 +505,44 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 {
 	/* Enable writing to power configuration registers */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0xC0, PROTECT_KEY);
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0x0C, PROTECT_KEY);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0xC0, PROTECT_KEY);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0x0C, PROTECT_KEY);
 
 	/* put VUSB3V1 LDO in active state */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
 
 	/* input to VUSB3V1 LDO is from VBAT, not VBUS */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
 
 	/* Initialize 3.1V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
 
 	twl->usb3v1 = regulator_get(twl->dev, "usb3v1");
 	if (IS_ERR(twl->usb3v1))
 		return -ENODEV;
 
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
 
 	/* Initialize 1.5V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
 
 	twl->usb1v5 = regulator_get(twl->dev, "usb1v5");
 	if (IS_ERR(twl->usb1v5))
 		goto fail1;
 
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
 
 	/* Initialize 1.8V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
 
 	twl->usb1v8 = regulator_get(twl->dev, "usb1v8");
 	if (IS_ERR(twl->usb1v8))
 		goto fail2;
 
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
 
 	/* disable access to power configuration registers */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, PROTECT_KEY);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, PROTECT_KEY);
 
 	return 0;
 
@@ -655,7 +655,7 @@ static int twl4030_set_host(struct otg_transceiver *x, struct usb_bus *host)
 
 static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 {
-	struct twl4030_usb_data *pdata = pdev->dev.platform_data;
+	struct twl_usb_data *pdata = pdev->dev.platform_data;
 	struct twl4030_usb	*twl;
 	int			status, err;
 
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 277d05f..1695e92 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -22,8 +22,8 @@
  *
  */
 
-#ifndef __TWL4030_H_
-#define __TWL4030_H_
+#ifndef __TWL_H_
+#define __TWL_H_
 
 /*
  * Using the twl4030 core we address registers using a pair
@@ -66,20 +66,53 @@
 #define TWL4030_MODULE_RTC		0x14
 #define TWL4030_MODULE_SECURED_REG	0x15
 
+#ifdef CONFIG_TWL4030_CORE
+#define TWL_MODULE_USB		TWL4030_MODULE_USB
+#define TWL_MODULE_AUDIO_VOICE	TWL4030_MODULE_AUDIO_VOICE
+#define TWL_MODULE_GPIO		TWL4030_MODULE_GPIO
+#define TWL_MODULE_INTBR		TWL4030_MODULE_INTBR
+#define TWL_MODULE_PIH		TWL4030_MODULE_PIH
+#define TWL_MODULE_TEST		TWL4030_MODULE_TEST
+#define TWL_MODULE_KEYPAD		TWL4030_MODULE_KEYPAD
+#define TWL_MODULE_MADC		TWL4030_MODULE_MADC
+#define TWL_MODULE_INTERRUPTS	TWL4030_MODULE_INTERRUPTS
+#define TWL_MODULE_LED		TWL4030_MODULE_LED
+#define TWL_MODULE_MAIN_CHARGE	TWL4030_MODULE_MAIN_CHARGE
+#define TWL_MODULE_PRECHARGE	TWL4030_MODULE_PRECHARGE
+#define TWL_MODULE_PWM0		TWL4030_MODULE_PWM0
+#define TWL_MODULE_PWM1		TWL4030_MODULE_PWM1
+#define TWL_MODULE_PWMA		TWL4030_MODULE_PWMA
+#define TWL_MODULE_PWMB		TWL4030_MODULE_PWMB
+#define TWL_MODULE_BACKUP		TWL4030_MODULE_BACKUP
+#define TWL_MODULE_INT		TWL4030_MODULE_INT
+#define TWL_MODULE_PM_MASTER	TWL4030_MODULE_PM_MASTER
+#define TWL_MODULE_PM_RECEIVER	TWL4030_MODULE_PM_RECEIVER
+#define TWL_MODULE_RTC		TWL4030_MODULE_RTC
+#define TWL_MODULE_SECURED_REG	TWL4030_MODULE_SECURED_REG
+
+#define GPIO_INTR_OFFSET	0
+#define KEYPAD_INTR_OFFSET	1
+#define BCI_INTR_OFFSET	2
+#define MADC_INTR_OFFSET	3
+#define USB_INTR_OFFSET	4
+#define BCI_PRES_INTR_OFFSET	9
+#define USB_PRES_INTR_OFFSET	10
+#define RTC_INTR_OFFSET	11
+#endif
 /*
  * Read and write single 8-bit registers
  */
-int twl4030_i2c_write_u8(u8 mod_no, u8 val, u8 reg);
-int twl4030_i2c_read_u8(u8 mod_no, u8 *val, u8 reg);
+int twl_i2c_write_u8(u8 mod_no, u8 val, u8 reg);
+int twl_i2c_read_u8(u8 mod_no, u8 *val, u8 reg);
 
 /*
  * Read and write several 8-bit registers at once.
  *
- * IMPORTANT:  For twl4030_i2c_write(), allocate num_bytes + 1
+ * IMPORTANT:  For twl_i2c_write(), allocate num_bytes + 1
  * for the value, and populate your data starting at offset 1.
  */
-int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
-int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
+int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
+int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
@@ -265,13 +298,13 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
-struct twl4030_bci_platform_data {
+struct twl_bci_platform_data {
 	int *battery_tmp_tbl;
 	unsigned int tblsize;
 };
 
 /* TWL4030_GPIO_MAX (18) GPIOs, with interrupts */
-struct twl4030_gpio_platform_data {
+struct twl_gpio_platform_data {
 	int		gpio_base;
 	unsigned	irq_base, irq_end;
 
@@ -298,11 +331,11 @@ struct twl4030_gpio_platform_data {
 				unsigned gpio, unsigned ngpio);
 };
 
-struct twl4030_madc_platform_data {
+struct twl_madc_platform_data {
 	int		irq_line;
 };
 
-struct twl4030_keypad_data {
+struct twl_keypad_data {
 	int rows;
 	int cols;
 	int *keymap;
@@ -311,22 +344,22 @@ struct twl4030_keypad_data {
 	unsigned int rep:1;
 };
 
-enum twl4030_usb_mode {
+enum twl_usb_mode {
 	T2_USB_MODE_ULPI = 1,
 	T2_USB_MODE_CEA2011_3PIN = 2,
 };
 
-struct twl4030_usb_data {
-	enum twl4030_usb_mode	usb_mode;
+struct twl_usb_data {
+	enum twl_usb_mode	usb_mode;
 };
 
-struct twl4030_platform_data {
+struct twl_platform_data {
 	unsigned				irq_base, irq_end;
-	struct twl4030_bci_platform_data	*bci;
-	struct twl4030_gpio_platform_data	*gpio;
-	struct twl4030_madc_platform_data	*madc;
-	struct twl4030_keypad_data		*keypad;
-	struct twl4030_usb_data			*usb;
+	struct twl_bci_platform_data	*bci;
+	struct twl_gpio_platform_data	*gpio;
+	struct twl_madc_platform_data	*madc;
+	struct twl_keypad_data		*keypad;
+	struct twl_usb_data			*usb;
 
 	/* LDO regulators */
 	struct regulator_init_data		*vdac;
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 2c47240..efe38a4 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -174,7 +174,7 @@ static int twl4030_write(struct snd_soc_codec *codec,
 {
 	twl4030_write_reg_cache(codec, reg, value);
 	if (likely(reg < TWL4030_REG_SW_SHADOW))
-		return twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, value,
+		return twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, value,
 					    reg);
 	else
 		return 0;
@@ -230,25 +230,25 @@ static void twl4030_codec_mute(struct snd_soc_codec *codec, int mute)
 		 * Things to mute:  Earpiece, PreDrivL/R, CarkitL/R
 		 */
 		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_EAR_CTL);
-		twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					reg_val & (~TWL4030_EAR_GAIN),
 					TWL4030_REG_EAR_CTL);
 
 		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_PREDL_CTL);
-		twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					reg_val & (~TWL4030_PREDL_GAIN),
 					TWL4030_REG_PREDL_CTL);
 		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_PREDR_CTL);
-		twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					reg_val & (~TWL4030_PREDR_GAIN),
 					TWL4030_REG_PREDL_CTL);
 
 		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_PRECKL_CTL);
-		twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					reg_val & (~TWL4030_PRECKL_GAIN),
 					TWL4030_REG_PRECKL_CTL);
 		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_PRECKR_CTL);
-		twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					reg_val & (~TWL4030_PRECKR_GAIN),
 					TWL4030_REG_PRECKR_CTL);
 
@@ -304,7 +304,7 @@ static void twl4030_power_up(struct snd_soc_codec *codec)
 	do {
 		/* this takes a little while, so don't slam i2c */
 		udelay(2000);
-		twl4030_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &byte,
+		twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &byte,
 				    TWL4030_REG_ANAMICL);
 	} while ((i++ < 100) &&
 		 ((byte & TWL4030_CNCL_OFFSET_START) ==
@@ -645,7 +645,7 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 		mdelay((ramp_base[(hs_pop & TWL4030_RAMP_DELAY) >> 2] /
 			twl4030->sysclk) + 1);
 		/* Bypass the reg_cache to mute the headset */
-		twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					hs_gain & (~0x0f),
 					TWL4030_REG_HS_GAIN_SET);
 
-- 
1.5.4.7

