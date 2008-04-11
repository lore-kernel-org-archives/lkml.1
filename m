Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYDKOI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYDKOI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbYDKOIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:08:51 -0400
Received: from mail0.scram.de ([78.47.204.202]:34189 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463AbYDKOIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:08:48 -0400
X-Spam-Score: -4.224
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47FF70E1.80200@scram.de>
Date: Fri, 11 Apr 2008 16:08:33 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: [PATCH2/7] i2c: Convert all new-style drivers to use module aliasing
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier work by Jon Smirl and Jean Delvare.

Update all the new-style i2c drivers to use standard module aliasing
instead of the old driver_name/type driver matching scheme.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jon Smirl <jonsmirl@gmail.com>
---
 arch/arm/mach-at91/board-csb337.c          |    3 +-
 arch/arm/mach-at91/board-dk.c              |    3 +-
 arch/arm/mach-at91/board-eb9200.c          |    3 +-
 arch/arm/mach-iop32x/em7210.c              |    3 +-
 arch/arm/mach-iop32x/n2100.c               |    4 +-
 arch/arm/mach-omap1/board-h2.c             |    2 -
 arch/arm/mach-omap1/board-h3.c             |    3 +-
 arch/arm/mach-omap1/board-osk.c            |    1 -
 arch/powerpc/sysdev/fsl_soc.c              |   27 ++++-----
 drivers/hwmon/f75375s.c                    |   12 ++++
 drivers/i2c/busses/i2c-taos-evm.c          |    3 +-
 drivers/i2c/chips/ds1682.c                 |    7 +++
 drivers/i2c/chips/menelaus.c               |    7 +++
 drivers/i2c/chips/tps65010.c               |   28 ++++------
 drivers/i2c/chips/tsl2550.c                |    7 +++
 drivers/media/video/cs5345.c               |    7 +++
 drivers/media/video/cs53l32a.c             |    7 +++
 drivers/media/video/cx25840/cx25840-core.c |    7 +++
 drivers/media/video/m52790.c               |    7 +++
 drivers/media/video/msp3400-driver.c       |    7 +++
 drivers/media/video/saa7115.c              |    7 +++
 drivers/media/video/saa7127.c              |   10 ++++
 drivers/media/video/tlv320aic23b.c         |    6 ++
 drivers/media/video/tuner-core.c           |   22 ++++++++
 drivers/media/video/tvaudio.c              |   13 +++++
 drivers/media/video/upd64031a.c            |    6 ++
 drivers/media/video/upd64083.c             |    6 ++
 drivers/media/video/vp27smpx.c             |    7 +++
 drivers/media/video/wm8739.c               |    7 +++
 drivers/media/video/wm8775.c               |    7 +++
 drivers/rtc/rtc-ds1307.c                   |   36 +++++--------
 drivers/rtc/rtc-ds1374.c                   |    7 +++
 drivers/rtc/rtc-m41t80.c                   |   78 +++++++---------------------
 drivers/rtc/rtc-rs5c372.c                  |   14 +++++-
 drivers/rtc/rtc-s35390a.c                  |    7 +++
 include/linux/i2c.h                        |   12 ++--
 include/media/v4l2-i2c-drv-legacy.h        |    2 +
 include/media/v4l2-i2c-drv.h               |    2 +
 38 files changed, 257 insertions(+), 140 deletions(-)

diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index 0e2a11f..63e4cb6 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -87,8 +87,7 @@ static struct at91_udc_data __initdata csb337_udc_data = {
 
 static struct i2c_board_info __initdata csb337_i2c_devices[] = {
 	{
-		I2C_BOARD_INFO("rtc-ds1307", 0x68),
-		.type	= "ds1307",
+		I2C_BOARD_INFO("ds1307", 0x68),
 	},
 };
 
diff --git a/arch/arm/mach-at91/board-dk.c b/arch/arm/mach-at91/board-dk.c
index 0a897ef..c1a813c 100644
--- a/arch/arm/mach-at91/board-dk.c
+++ b/arch/arm/mach-at91/board-dk.c
@@ -132,8 +132,7 @@ static struct i2c_board_info __initdata dk_i2c_devices[] = {
 		I2C_BOARD_INFO("x9429", 0x28),
 	},
 	{
-		I2C_BOARD_INFO("at24c", 0x50),
-		.type	= "24c1024",
+		I2C_BOARD_INFO("24c1024", 0x50),
 	}
 };
 
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index b7b79bb..af1a1d8 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -93,8 +93,7 @@ static struct at91_mmc_data __initdata eb9200_mmc_data = {
 
 static struct i2c_board_info __initdata eb9200_i2c_devices[] = {
 	{
-		I2C_BOARD_INFO("at24c", 0x50),
-		.type	= "24c512",
+		I2C_BOARD_INFO("24c512", 0x50),
 	},
 };
 
diff --git a/arch/arm/mach-iop32x/em7210.c b/arch/arm/mach-iop32x/em7210.c
index c947152..4877597 100644
--- a/arch/arm/mach-iop32x/em7210.c
+++ b/arch/arm/mach-iop32x/em7210.c
@@ -50,8 +50,7 @@ static struct sys_timer em7210_timer = {
  */
 static struct i2c_board_info __initdata em7210_i2c_devices[] = {
 	{
-		I2C_BOARD_INFO("rtc-rs5c372", 0x32),
-		.type = "rs5c372a",
+		I2C_BOARD_INFO("rs5c372a", 0x32),
 	},
 };
 
diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index bc91d6e..2741063 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -208,12 +208,10 @@ static struct f75375s_platform_data n2100_f75375s = {
 
 static struct i2c_board_info __initdata n2100_i2c_devices[] = {
 	{
-		I2C_BOARD_INFO("rtc-rs5c372", 0x32),
-		.type = "rs5c372b",
+		I2C_BOARD_INFO("rs5c372b", 0x32),
 	},
 	{
 		I2C_BOARD_INFO("f75375", 0x2e),
-		.type = "f75375",
 		.platform_data = &n2100_f75375s,
 	},
 };
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 5079877..4b444fd 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -351,11 +351,9 @@ static void __init h2_init_smc91x(void)
 static struct i2c_board_info __initdata h2_i2c_board_info[] = {
 	{
 		I2C_BOARD_INFO("tps65010", 0x48),
-		.type           = "tps65010",
 		.irq            = OMAP_GPIO_IRQ(58),
 	}, {
 		I2C_BOARD_INFO("isp1301_omap", 0x2d),
-		.type		= "isp1301_omap",
 		.irq		= OMAP_GPIO_IRQ(2),
 	},
 };
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index c3ef1ee..7fbaa8d 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -473,8 +473,7 @@ static struct omap_board_config_kernel h3_config[] __initdata = {
 
 static struct i2c_board_info __initdata h3_i2c_board_info[] = {
        {
-               I2C_BOARD_INFO("tps65010", 0x48),
-               .type           = "tps65013",
+		I2C_BOARD_INFO("tps65013", 0x48),
                /* .irq         = OMAP_GPIO_IRQ(??), */
        },
 };
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 5279e35..70c77e5 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -186,7 +186,6 @@ static struct platform_device *osk5912_devices[] __initdata = {
 static struct i2c_board_info __initdata osk_i2c_board_info[] = {
 	{
 		I2C_BOARD_INFO("tps65010", 0x48),
-		.type		= "tps65010",
 		.irq		= OMAP_GPIO_IRQ(OMAP_MPUIO(1)),
 	},
 	/* TODO when driver support is ready:
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 2c5388c..2cd4ef9 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -390,22 +390,21 @@ arch_initcall(gfar_of_init);
 #include <linux/i2c.h>
 struct i2c_driver_device {
 	char	*of_device;
-	char	*i2c_driver;
 	char	*i2c_type;
 };
 
 static struct i2c_driver_device i2c_devices[] __initdata = {
-	{"ricoh,rs5c372a", "rtc-rs5c372", "rs5c372a",},
-	{"ricoh,rs5c372b", "rtc-rs5c372", "rs5c372b",},
-	{"ricoh,rv5c386",  "rtc-rs5c372", "rv5c386",},
-	{"ricoh,rv5c387a", "rtc-rs5c372", "rv5c387a",},
-	{"dallas,ds1307",  "rtc-ds1307",  "ds1307",},
-	{"dallas,ds1337",  "rtc-ds1307",  "ds1337",},
-	{"dallas,ds1338",  "rtc-ds1307",  "ds1338",},
-	{"dallas,ds1339",  "rtc-ds1307",  "ds1339",},
-	{"dallas,ds1340",  "rtc-ds1307",  "ds1340",},
-	{"stm,m41t00",     "rtc-ds1307",  "m41t00"},
-	{"dallas,ds1374",  "rtc-ds1374",  "rtc-ds1374",},
+	{"ricoh,rs5c372a", "rs5c372a",},
+	{"ricoh,rs5c372b", "rs5c372b",},
+	{"ricoh,rv5c386",  "rv5c386",},
+	{"ricoh,rv5c387a", "rv5c387a",},
+	{"dallas,ds1307",  "ds1307",},
+	{"dallas,ds1337",  "ds1337",},
+	{"dallas,ds1338",  "ds1338",},
+	{"dallas,ds1339",  "ds1339",},
+	{"dallas,ds1340",  "ds1340",},
+	{"stm,m41t00",     "m41t00"},
+	{"dallas,ds1374",  "rtc-ds1374",},
 };
 
 static int __init of_find_i2c_driver(struct device_node *node,
@@ -416,9 +415,7 @@ static int __init of_find_i2c_driver(struct device_node *node,
 	for (i = 0; i < ARRAY_SIZE(i2c_devices); i++) {
 		if (!of_device_is_compatible(node, i2c_devices[i].of_device))
 			continue;
-		if (strlcpy(info->driver_name, i2c_devices[i].i2c_driver,
-			    KOBJ_NAME_LEN) >= KOBJ_NAME_LEN ||
-		    strlcpy(info->type, i2c_devices[i].i2c_type,
+		if (strlcpy(info->type, i2c_devices[i].i2c_type,
 			    I2C_NAME_SIZE) >= I2C_NAME_SIZE)
 			return -ENOMEM;
 		return 0;
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 3ec9123..1fabcae 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -129,12 +129,20 @@ static struct i2c_driver f75375_legacy_driver = {
 	.detach_client = f75375_detach_client,
 };
 
+static const struct i2c_device_id f75375_id[] = {
+	{ "f75373", f75373 },
+	{ "f75375", f75375 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, f75375_id);
+
 static struct i2c_driver f75375_driver = {
 	.driver = {
 		.name = "f75375",
 	},
 	.probe = f75375_probe,
 	.remove = f75375_remove,
+	.id_table = f75375_id,
 };
 
 static inline int f75375_read8(struct i2c_client *client, u8 reg)
@@ -716,6 +724,7 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
 	u8 version = 0;
 	int err = 0;
 	const char *name = "";
+	struct i2c_device_id id;
 
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client) {
@@ -754,6 +763,9 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
 	if (err)
 		goto exit_free;
 
+	strlcpy(id.name, name, I2C_NAME_SIZE);
+	id.driver_data = kind;
+
 	err = f75375_probe(client, NULL);
 	if (err < 0)
 		goto exit_detach;
diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
index 1b0cfd5..de9db49 100644
--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -51,7 +51,6 @@ struct taos_data {
 /* TAOS TSL2550 EVM */
 static struct i2c_board_info tsl2550_info = {
 	I2C_BOARD_INFO("tsl2550", 0x39),
-	.type	= "tsl2550",
 };
 
 /* Instantiate i2c devices based on the adapter name */
@@ -59,7 +58,7 @@ static struct i2c_client *taos_instantiate_device(struct i2c_adapter *adapter)
 {
 	if (!strncmp(adapter->name, "TAOS TSL2550 EVM", 16)) {
 		dev_info(&adapter->dev, "Instantiating device %s at 0x%02x\n",
-			tsl2550_info.driver_name, tsl2550_info.addr);
+			tsl2550_info.type, tsl2550_info.addr);
 		return i2c_new_device(adapter, &tsl2550_info);
 	}
 
diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
index 3070821..51ff518 100644
--- a/drivers/i2c/chips/ds1682.c
+++ b/drivers/i2c/chips/ds1682.c
@@ -235,12 +235,19 @@ static int ds1682_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct i2c_device_id ds1682_id[] = {
+	{ "ds1682", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, ds1682_id);
+
 static struct i2c_driver ds1682_driver = {
 	.driver = {
 		.name = "ds1682",
 	},
 	.probe = ds1682_probe,
 	.remove = ds1682_remove,
+	.id_table = ds1682_id,
 };
 
 static int __init ds1682_init(void)
diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
index 3b8ba7e..1f9ac5e 100644
--- a/drivers/i2c/chips/menelaus.c
+++ b/drivers/i2c/chips/menelaus.c
@@ -1243,12 +1243,19 @@ static int __exit menelaus_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct i2c_device_id menelaus_id[] = {
+	{ "menelaus", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, menelaus_id);
+
 static struct i2c_driver menelaus_i2c_driver = {
 	.driver = {
 		.name		= DRIVER_NAME,
 	},
 	.probe		= menelaus_probe,
 	.remove		= __exit_p(menelaus_remove),
+	.id_table	= menelaus_id,
 };
 
 static int __init menelaus_init(void)
diff --git a/drivers/i2c/chips/tps65010.c b/drivers/i2c/chips/tps65010.c
index 3ce43f8..e07274d 100644
--- a/drivers/i2c/chips/tps65010.c
+++ b/drivers/i2c/chips/tps65010.c
@@ -60,7 +60,6 @@ static struct i2c_driver tps65010_driver;
  * as part of board setup by a bootloader.
  */
 enum tps_model {
-	TPS_UNKNOWN = 0,
 	TPS65010,
 	TPS65011,
 	TPS65012,
@@ -487,20 +486,6 @@ static int tps65010_probe(struct i2c_client *client,
 	INIT_DELAYED_WORK(&tps->work, tps65010_work);
 	tps->client = client;
 
-	if (strcmp(client->name, "tps65010") == 0)
-		tps->model = TPS65010;
-	else if (strcmp(client->name, "tps65011") == 0)
-		tps->model = TPS65011;
-	else if (strcmp(client->name, "tps65012") == 0)
-		tps->model = TPS65012;
-	else if (strcmp(client->name, "tps65013") == 0)
-		tps->model = TPS65013;
-	else {
-		dev_warn(&client->dev, "unknown chip '%s'\n", client->name);
-		status = -ENODEV;
-		goto fail1;
-	}
-
 	/* the IRQ is active low, but many gpio lines can't support that
 	 * so this driver uses falling-edge triggers instead.
 	 */
@@ -528,9 +513,6 @@ static int tps65010_probe(struct i2c_client *client,
 	case TPS65012:
 		tps->por = 1;
 		break;
-	case TPS_UNKNOWN:
-		printk(KERN_WARNING "%s: unknown TPS chip\n", DRIVER_NAME);
-		break;
 	/* else CHGCONFIG.POR is replaced by AUA, enabling a WAIT mode */
 	}
 	tps->chgconf = i2c_smbus_read_byte_data(client, TPS_CHGCONFIG);
@@ -584,12 +566,22 @@ fail1:
 	return status;
 }
 
+static const struct i2c_device_id tps65010_id[] = {
+	{ "tps65010", TPS65010 },
+	{ "tps65011", TPS65011 },
+	{ "tps65012", TPS65012 },
+	{ "tps65013", TPS65013 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, tps65010_id);
+
 static struct i2c_driver tps65010_driver = {
 	.driver = {
 		.name	= "tps65010",
 	},
 	.probe	= tps65010_probe,
 	.remove	= __exit_p(tps65010_remove),
+	.id_table = tps65010_id,
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
index 59c2c66..2add8be 100644
--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -452,6 +452,12 @@ static int tsl2550_resume(struct i2c_client *client)
 
 #endif /* CONFIG_PM */
 
+static const struct i2c_device_id tsl2550_id[] = {
+	{ "tsl2550", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, tsl2550_id);
+
 static struct i2c_driver tsl2550_driver = {
 	.driver = {
 		.name	= TSL2550_DRV_NAME,
@@ -461,6 +467,7 @@ static struct i2c_driver tsl2550_driver = {
 	.resume	= tsl2550_resume,
 	.probe	= tsl2550_probe,
 	.remove	= __devexit_p(tsl2550_remove),
+	.id_table = tsl2550_id,
 };
 
 static int __init tsl2550_init(void)
diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index 2a429f9..69aeb3d 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -160,9 +160,16 @@ static int cs5345_probe(struct i2c_client *client,
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id cs5345_id[] = {
+	{ "cs5345", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, cs5345_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "cs5345",
 	.driverid = I2C_DRIVERID_CS5345,
+	.id_table = cs5345_id,
 	.command = cs5345_command,
 	.probe = cs5345_probe,
 };
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index 2dfd0af..f3749fb 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -175,9 +175,16 @@ static int cs53l32a_probe(struct i2c_client *client,
 	return 0;
 }
 
+static const struct i2c_device_id cs53l32a_id[] = {
+	{ "cs53l32a", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, cs53l32a_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "cs53l32a",
 	.driverid = I2C_DRIVERID_CS53L32A,
+	.id_table = cs53l32a_id,
 	.command = cs53l32a_command,
 	.probe = cs53l32a_probe,
 };
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 6f16186..7df9dc1 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1301,9 +1301,16 @@ static int cx25840_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct i2c_device_id cx25840_id[] = {
+	{ "cx25840", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, cx25840_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "cx25840",
 	.driverid = I2C_DRIVERID_CX25840,
+	.id_table = cx25840_id,
 	.command = cx25840_command,
 	.probe = cx25840_probe,
 	.remove = cx25840_remove,
diff --git a/drivers/media/video/m52790.c b/drivers/media/video/m52790.c
index 5b9dfa2..acf9075 100644
--- a/drivers/media/video/m52790.c
+++ b/drivers/media/video/m52790.c
@@ -159,9 +159,16 @@ static int m52790_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id m52790_id[] = {
+	{ "m52790", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, m52790_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "m52790",
 	.driverid = I2C_DRIVERID_M52790,
+	.id_table = m52790_id,
 	.command = m52790_command,
 	.probe = m52790_probe,
 	.remove = m52790_remove,
diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index 3f97737..1e5f256 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -988,9 +988,16 @@ static int msp_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id msp_id[] = {
+	{ "msp3400", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, msp_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "msp3400",
 	.driverid = I2C_DRIVERID_MSP3400,
+	.id_table = msp_id,
 	.command = msp_command,
 	.probe = msp_probe,
 	.remove = msp_remove,
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 7882e29..ea9a9c4 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1553,9 +1553,16 @@ static int saa7115_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct i2c_device_id saa7115_id[] = {
+	{ "saa7115", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, saa7115_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "saa7115",
 	.driverid = I2C_DRIVERID_SAA711X,
+	.id_table = saa7115_id,
 	.command = saa7115_command,
 	.probe = saa7115_probe,
 	.remove = saa7115_remove,
diff --git a/drivers/media/video/saa7127.c b/drivers/media/video/saa7127.c
index e750cd6..9520041 100644
--- a/drivers/media/video/saa7127.c
+++ b/drivers/media/video/saa7127.c
@@ -741,8 +741,18 @@ static int saa7127_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static struct i2c_device_id saa7127_id[] = {
+	{ "saa7126", 0 },
+	{ "saa7127", 0 },
+	{ "saa7128", 0 },
+	{ "saa7129", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, saa7127_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "saa7127",
+	.id_table = saa7127_id,
 	.driverid = I2C_DRIVERID_SAA7127,
 	.command = saa7127_command,
 	.probe = saa7127_probe,
diff --git a/drivers/media/video/tlv320aic23b.c b/drivers/media/video/tlv320aic23b.c
index f1db542..87e538f 100644
--- a/drivers/media/video/tlv320aic23b.c
+++ b/drivers/media/video/tlv320aic23b.c
@@ -168,10 +168,16 @@ static int tlv320aic23b_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id tlv320aic23b_id[] = {
+	{ "tlv320aic23b", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, tlv320aic23b_id);
 
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "tlv320aic23b",
 	.driverid = I2C_DRIVERID_TLV320AIC23B,
+	.id_table = tlv320aic23b_id,
 	.command = tlv320aic23b_command,
 	.probe = tlv320aic23b_probe,
 	.remove = tlv320aic23b_remove,
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index edd451e..205c9d0 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1247,9 +1247,31 @@ static int tuner_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id tuner_id[] = {
+	{ "dtt761x", 0 },
+	{ "fcv1236", 0 },
+	{ "fi1216mk", 0 },
+	{ "fm1216me", 0 },
+	{ "fm1236", 0 },
+	{ "fm1256", 0 },
+	{ "fmd1216me", 0 },
+	{ "h06xf", 0 },
+	{ "j180at", 0 },
+	{ "mt4042fi5", 0 },
+	{ "mt4049fm5", 0 },
+	{ "tlc2002n", 0 },
+	{ "tnf8831", 0 },
+	{ "tnf9533", 0 },
+	{ "tvf5533mf", 0 },
+	{ "vp27s", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, tuner_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "tuner",
 	.driverid = I2C_DRIVERID_TUNER,
+	.id_table = tuner_id,
 	.command = tuner_command,
 	.probe = tuner_probe,
 	.remove = tuner_remove,
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 1fa1552..3545daf 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1831,9 +1831,22 @@ static int chip_legacy_probe(struct i2c_adapter *adap)
 	return 0;
 }
 
+static const struct i2c_device_id chip_id[] = {
+	{ "tda8425", 0 },
+	{ "tea6300", 0 },
+	{ "tea6420", 0 },
+	{ "tda9840", 0 },
+	{ "tda985x", 0 },
+	{ "tda9874", 0 },
+	{ "pic16c54", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, chip_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "tvaudio",
 	.driverid = I2C_DRIVERID_TVAUDIO,
+	.id_table = chip_id,
 	.command = chip_command,
 	.probe = chip_probe,
 	.remove = chip_remove,
diff --git a/drivers/media/video/upd64031a.c b/drivers/media/video/upd64031a.c
index 93bfd19..f69f9b9 100644
--- a/drivers/media/video/upd64031a.c
+++ b/drivers/media/video/upd64031a.c
@@ -228,10 +228,16 @@ static int upd64031a_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id upd64031a_id[] = {
+	{ "upd64031a", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, upd64031a_id);
 
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "upd64031a",
 	.driverid = I2C_DRIVERID_UPD64031A,
+	.id_table = upd64031a_id,
 	.command = upd64031a_command,
 	.probe = upd64031a_probe,
 	.remove = upd64031a_remove,
diff --git a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
index 9ab712a..d39849f 100644
--- a/drivers/media/video/upd64083.c
+++ b/drivers/media/video/upd64083.c
@@ -205,10 +205,16 @@ static int upd64083_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id upd64083_id[] = {
+	{ "upd64083", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, upd64083_id);
 
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "upd64083",
 	.driverid = I2C_DRIVERID_UPD64083,
+	.id_table = upd64083_id,
 	.command = upd64083_command,
 	.probe = upd64083_probe,
 	.remove = upd64083_remove,
diff --git a/drivers/media/video/vp27smpx.c b/drivers/media/video/vp27smpx.c
index fac0deb..fc91cfa 100644
--- a/drivers/media/video/vp27smpx.c
+++ b/drivers/media/video/vp27smpx.c
@@ -154,9 +154,16 @@ static int vp27smpx_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct i2c_device_id vp27smpx_id[] = {
+	{ "vp27smpx", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, vp27smpx_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "vp27smpx",
 	.driverid = I2C_DRIVERID_VP27SMPX,
+	.id_table = vp27smpx_id,
 	.command = vp27smpx_command,
 	.probe = vp27smpx_probe,
 	.remove = vp27smpx_remove,
diff --git a/drivers/media/video/wm8739.c b/drivers/media/video/wm8739.c
index 0f8ed84..cf180a5 100644
--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -313,9 +313,16 @@ static int wm8739_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct i2c_device_id wm8739_id[] = {
+	{ "wm8739", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, wm8739_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "wm8739",
 	.driverid = I2C_DRIVERID_WM8739,
+	.id_table = wm8739_id,
 	.command = wm8739_command,
 	.probe = wm8739_probe,
 	.remove = wm8739_remove,
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index 67a409e..b1653c5 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -216,9 +216,16 @@ static int wm8775_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct i2c_device_id wm8775_id[] = {
+	{ "wm8775", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, wm8775_id);
+
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "wm8775",
 	.driverid = I2C_DRIVERID_WM8775,
+	.id_table = wm8775_id,
 	.command = wm8775_command,
 	.probe = wm8775_probe,
 	.remove = wm8775_remove,
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 67ba8ae..93fdced 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -102,42 +102,36 @@ struct chip_desc {
 	char			name[9];
 	unsigned		nvram56:1;
 	unsigned		alarm:1;
-	enum ds_type		type;
 };
 
 static const struct chip_desc chips[] = { {
 	.name		= "ds1307",
-	.type		= ds_1307,
 	.nvram56	= 1,
 }, {
 	.name		= "ds1337",
-	.type		= ds_1337,
 	.alarm		= 1,
 }, {
 	.name		= "ds1338",
-	.type		= ds_1338,
 	.nvram56	= 1,
 }, {
 	.name		= "ds1339",
-	.type		= ds_1339,
 	.alarm		= 1,
 }, {
 	.name		= "ds1340",
-	.type		= ds_1340,
 }, {
 	.name		= "m41t00",
-	.type		= m41t00,
 }, };
 
-static inline const struct chip_desc *find_chip(const char *s)
-{
-	unsigned i;
-
-	for (i = 0; i < ARRAY_SIZE(chips); i++)
-		if (strnicmp(s, chips[i].name, sizeof chips[i].name) == 0)
-			return &chips[i];
-	return NULL;
-}
+static const struct i2c_device_id ds1307_id[] = {
+	{ "ds1307", ds_1307 },
+	{ "ds1337", ds_1337 },
+	{ "ds1338", ds_1338 },
+	{ "ds1339", ds_1339 },
+	{ "ds1340", ds_1340 },
+	{ "m41t00", m41t00 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ds1307_id);
 
 static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 {
@@ -335,12 +329,7 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 	const struct chip_desc	*chip;
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 
-	chip = find_chip(client->name);
-	if (!chip) {
-		dev_err(&client->dev, "unknown chip type '%s'\n",
-				client->name);
-		return -ENODEV;
-	}
+	chip = &chips[id->driver_data];
 
 	if (!i2c_check_functionality(adapter,
 			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
@@ -362,7 +351,7 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 	ds1307->msg[1].len = sizeof(ds1307->regs);
 	ds1307->msg[1].buf = ds1307->regs;
 
-	ds1307->type = chip->type;
+	ds1307->type = id->driver_data;
 
 	switch (ds1307->type) {
 	case ds_1337:
@@ -551,6 +540,7 @@ static struct i2c_driver ds1307_driver = {
 	},
 	.probe		= ds1307_probe,
 	.remove		= __devexit_p(ds1307_remove),
+	.id_table	= ds1307_id,
 };
 
 static int __init ds1307_init(void)
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 104dcfd..376ceeb 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -41,6 +41,12 @@
 #define DS1374_REG_SR_AF	0x01 /* Alarm Flag */
 #define DS1374_REG_TCR		0x09 /* Trickle Charge */
 
+static const struct i2c_device_id ds1374_id[] = {
+	{ "ds1374", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ds1374_id);
+
 struct ds1374 {
 	struct i2c_client *client;
 	struct rtc_device *rtc;
@@ -430,6 +436,7 @@ static struct i2c_driver ds1374_driver = {
 	},
 	.probe = ds1374_probe,
 	.remove = __devexit_p(ds1374_remove),
+	.id_table = ds1374_id,
 };
 
 static int __init ds1374_init(void)
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 2ee0d07..c672557 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -60,48 +60,21 @@
 
 #define DRV_VERSION "0.05"
 
-struct m41t80_chip_info {
-	const char *name;
-	u8 features;
-};
-
-static const struct m41t80_chip_info m41t80_chip_info_tbl[] = {
-	{
-		.name		= "m41t80",
-		.features	= 0,
-	},
-	{
-		.name		= "m41t81",
-		.features	= M41T80_FEATURE_HT,
-	},
-	{
-		.name		= "m41t81s",
-		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
-	},
-	{
-		.name		= "m41t82",
-		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
-	},
-	{
-		.name		= "m41t83",
-		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
-	},
-	{
-		.name		= "m41st84",
-		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
-	},
-	{
-		.name		= "m41st85",
-		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
-	},
-	{
-		.name		= "m41st87",
-		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
-	},
+static const struct i2c_device_id m41t80_id[] = {
+	{ "m41t80", 0 },
+	{ "m41t81", M41T80_FEATURE_HT },
+	{ "m41t81s", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41t82", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41t83", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41st84", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41st85", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41st87", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{},
 };
+MODULE_DEVICE_TABLE(i2c, m41t80_id);
 
 struct m41t80_data {
-	const struct m41t80_chip_info *chip;
+	u8 features;
 	struct rtc_device *rtc;
 };
 
@@ -208,7 +181,7 @@ static int m41t80_rtc_proc(struct device *dev, struct seq_file *seq)
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	u8 reg;
 
-	if (clientdata->chip->features & M41T80_FEATURE_BL) {
+	if (clientdata->features & M41T80_FEATURE_BL) {
 		reg = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
 		seq_printf(seq, "battery\t\t: %s\n",
 			   (reg & M41T80_FLAGS_BATT_LOW) ? "exhausted" : "ok");
@@ -759,10 +732,9 @@ static struct notifier_block wdt_notifier = {
 static int m41t80_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	int i, rc = 0;
+	int rc = 0;
 	struct rtc_device *rtc = NULL;
 	struct rtc_time tm;
-	const struct m41t80_chip_info *chip;
 	struct m41t80_data *clientdata = NULL;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
@@ -774,19 +746,6 @@ static int m41t80_probe(struct i2c_client *client,
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
-	chip = NULL;
-	for (i = 0; i < ARRAY_SIZE(m41t80_chip_info_tbl); i++) {
-		if (!strcmp(m41t80_chip_info_tbl[i].name, client->name)) {
-			chip = &m41t80_chip_info_tbl[i];
-			break;
-		}
-	}
-	if (!chip) {
-		dev_err(&client->dev, "%s is not supported\n", client->name);
-		rc = -ENODEV;
-		goto exit;
-	}
-
 	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
 	if (!clientdata) {
 		rc = -ENOMEM;
@@ -802,7 +761,7 @@ static int m41t80_probe(struct i2c_client *client,
 	}
 
 	clientdata->rtc = rtc;
-	clientdata->chip = chip;
+	clientdata->features = id->driver_data;
 	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
@@ -811,7 +770,7 @@ static int m41t80_probe(struct i2c_client *client,
 		goto ht_err;
 
 	if (rc & M41T80_ALHOUR_HT) {
-		if (chip->features & M41T80_FEATURE_HT) {
+		if (clientdata->features & M41T80_FEATURE_HT) {
 			m41t80_get_datetime(client, &tm);
 			dev_info(&client->dev, "HT bit was set!\n");
 			dev_info(&client->dev,
@@ -843,7 +802,7 @@ static int m41t80_probe(struct i2c_client *client,
 		goto exit;
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-	if (chip->features & M41T80_FEATURE_HT) {
+	if (clientdata->features & M41T80_FEATURE_HT) {
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -879,7 +838,7 @@ static int m41t80_remove(struct i2c_client *client)
 	struct rtc_device *rtc = clientdata->rtc;
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-	if (clientdata->chip->features & M41T80_FEATURE_HT) {
+	if (clientdata->features & M41T80_FEATURE_HT) {
 		misc_deregister(&wdt_dev);
 		unregister_reboot_notifier(&wdt_notifier);
 	}
@@ -897,6 +856,7 @@ static struct i2c_driver m41t80_driver = {
 	},
 	.probe = m41t80_probe,
 	.remove = m41t80_remove,
+	.id_table = m41t80_id,
 };
 
 static int __init m41t80_rtc_init(void)
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index ebdbad9..a3e4f8d 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -69,6 +69,15 @@ enum rtc_type {
 	rtc_rv5c387a,
 };
 
+static const struct i2c_device_id rs5c372_id[] = {
+	{ "rs5c372a", rtc_rs5c372a },
+	{ "rs5c372b", rtc_rs5c372b },
+	{ "rv5c386", rtc_rv5c386 },
+	{ "rv5c387a", rtc_rv5c387a },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, rs5c372_id);
+
 /* REVISIT:  this assumes that:
  *  - we're in the 21st century, so it's safe to ignore the century
  *    bit for rv5c38[67] (REG_MONTH bit 7);
@@ -523,7 +532,9 @@ static int rs5c372_probe(struct i2c_client *client,
 	if (err < 0)
 		goto exit_kfree;
 
-	if (strcmp(client->name, "rs5c372a") == 0)
+	if (id)
+		rs5c372->type = id->driver_data;
+	else if (strcmp(client->name, "rs5c372a") == 0)
 		rs5c372->type = rtc_rs5c372a;
 	else if (strcmp(client->name, "rs5c372b") == 0)
 		rs5c372->type = rtc_rs5c372b;
@@ -652,6 +663,7 @@ static struct i2c_driver rs5c372_driver = {
 	},
 	.probe		= rs5c372_probe,
 	.remove		= rs5c372_remove,
+	.id_table	= rs5c372_id,
 };
 
 static __init int rs5c372_init(void)
diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index e8abc90..c55b9ea 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -34,6 +34,12 @@
 #define S35390A_FLAG_RESET	0x80
 #define S35390A_FLAG_TEST	0x01
 
+static const struct i2c_device_id s35390a_id[] = {
+	{ "s35390a", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, s35390a_id);
+
 struct s35390a {
 	struct i2c_client *client[8];
 	struct rtc_device *rtc;
@@ -296,6 +302,7 @@ static struct i2c_driver s35390a_driver = {
 	},
 	.probe		= s35390a_probe,
 	.remove		= s35390a_remove,
+	.id_table	= s35390a_id,
 };
 
 static int __init s35390a_rtc_init(void)
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 92c8ecf..01ad5db 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -229,17 +229,17 @@ struct i2c_board_info {
 };
 
 /**
- * I2C_BOARD_INFO - macro used to list an i2c device and its driver
- * @driver: identifies the driver to use with the device
+ * I2C_BOARD_INFO - macro used to list an i2c device and its address
+ * @dev_type: identifies the device type
  * @dev_addr: the device's address on the bus.
  *
  * This macro initializes essential fields of a struct i2c_board_info,
  * declaring what has been provided on a particular board.  Optional
- * fields (such as the chip type, its associated irq, or device-specific
- * platform_data) are provided using conventional syntax.
+ * fields (such as associated irq, or device-specific platform_data)
+ * are provided using conventional syntax.
  */
-#define I2C_BOARD_INFO(driver,dev_addr) \
-	.driver_name = (driver), .addr = (dev_addr)
+#define I2C_BOARD_INFO(dev_type,dev_addr) \
+	.type = (dev_type), .addr = (dev_addr)
 
 
 /* Add-on boards should register/unregister their devices; e.g. a board
diff --git a/include/media/v4l2-i2c-drv-legacy.h b/include/media/v4l2-i2c-drv-legacy.h
index 347b6f8..8785622 100644
--- a/include/media/v4l2-i2c-drv-legacy.h
+++ b/include/media/v4l2-i2c-drv-legacy.h
@@ -31,6 +31,7 @@ struct v4l2_i2c_driver_data {
 	int (*resume)(struct i2c_client *client);
 	int (*legacy_probe)(struct i2c_adapter *adapter);
 	int legacy_class;
+	const struct i2c_device_id *id_table;
 };
 
 static struct v4l2_i2c_driver_data v4l2_i2c_data;
@@ -124,6 +125,7 @@ static int __init v4l2_i2c_drv_init(void)
 	v4l2_i2c_driver.command = v4l2_i2c_data.command;
 	v4l2_i2c_driver.probe = v4l2_i2c_data.probe;
 	v4l2_i2c_driver.remove = v4l2_i2c_data.remove;
+	v4l2_i2c_driver.id_table = v4l2_i2c_data.id_table;
 	err = i2c_add_driver(&v4l2_i2c_driver);
 	if (err)
 		i2c_del_driver(&v4l2_i2c_driver_legacy);
diff --git a/include/media/v4l2-i2c-drv.h b/include/media/v4l2-i2c-drv.h
index 7b6f06b..40ecef2 100644
--- a/include/media/v4l2-i2c-drv.h
+++ b/include/media/v4l2-i2c-drv.h
@@ -36,6 +36,7 @@ struct v4l2_i2c_driver_data {
 	int (*resume)(struct i2c_client *client);
 	int (*legacy_probe)(struct i2c_adapter *adapter);
 	int legacy_class;
+	const struct i2c_device_id *id_table;
 };
 
 static struct v4l2_i2c_driver_data v4l2_i2c_data;
@@ -53,6 +54,7 @@ static int __init v4l2_i2c_drv_init(void)
 	v4l2_i2c_driver.remove = v4l2_i2c_data.remove;
 	v4l2_i2c_driver.suspend = v4l2_i2c_data.suspend;
 	v4l2_i2c_driver.resume = v4l2_i2c_data.resume;
+	v4l2_i2c_driver.id_table = v4l2_i2c_data.id_table;
 	return i2c_add_driver(&v4l2_i2c_driver);
 }
 
-- 
1.5.4.5



