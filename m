Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXJaXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXJaXEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXJaXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:04:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52412 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752481AbXJaXEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:04:10 -0400
Date: Thu, 1 Nov 2007 00:03:58 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [2.6 patch] the scheduled I2C RTC driver removal
Message-ID: <20071031230357.GW7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of legacy I2C RTC drivers with 
replacement drivers.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    7 
 arch/powerpc/platforms/83xx/mpc832x_mds.c  |   24 -
 arch/powerpc/platforms/83xx/mpc834x_mds.c  |   24 -
 arch/powerpc/platforms/83xx/mpc836x_mds.c  |   24 -
 arch/ppc/platforms/83xx/mpc834x_sys.c      |   20 -
 arch/ppc/platforms/85xx/tqm85xx.c          |   21 -
 arch/ppc/platforms/katana.c                |   21 -
 drivers/i2c/chips/Kconfig                  |   38 -
 drivers/i2c/chips/Makefile                 |    3 
 drivers/i2c/chips/ds1337.c                 |  410 --------------------
 drivers/i2c/chips/ds1374.c                 |  267 -------------
 drivers/i2c/chips/m41t00.c                 |  413 ---------------------
 include/linux/m41t00.h                     |   50 --
 13 files changed, 1322 deletions(-)

bf858b44b3071082be3aaf71e2d46ddb26415247 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 6bb9be5..391f2d1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -275,13 +275,6 @@ Who:  Tejun Heo <htejun@gmail.com>
 
 ---------------------------
 
-What:	Legacy RTC drivers (under drivers/i2c/chips)
-When:	November 2007
-Why:	Obsolete. We have a RTC subsystem with better drivers.
-Who:	Jean Delvare <khali@linux-fr.org>
-
----------------------------
-
 What:	iptables SAME target
 When:	1.1. 2008
 Files:	net/ipv4/netfilter/ipt_SAME.c, include/linux/netfilter_ipv4/ipt_SAME.h
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index 972fa85..66382df 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -145,30 +145,6 @@ static void __init mpc832x_sys_init_IRQ(void)
 #endif				/* CONFIG_QUICC_ENGINE */
 }
 
-#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
-extern ulong ds1374_get_rtc_time(void);
-extern int ds1374_set_rtc_time(ulong);
-
-static int __init mpc832x_rtc_hookup(void)
-{
-	struct timespec tv;
-
-	if (!machine_is(mpc832x_mds))
-		return 0;
-
-	ppc_md.get_rtc_time = ds1374_get_rtc_time;
-	ppc_md.set_rtc_time = ds1374_set_rtc_time;
-
-	tv.tv_nsec = 0;
-	tv.tv_sec = (ppc_md.get_rtc_time) ();
-	do_settimeofday(&tv);
-
-	return 0;
-}
-
-late_initcall(mpc832x_rtc_hookup);
-#endif
-
 /*
  * Called very early, MMU is off, device-tree isn't unflattened
  */
diff --git a/arch/powerpc/platforms/83xx/mpc834x_mds.c b/arch/powerpc/platforms/83xx/mpc834x_mds.c
index 00aed7c..a81bb3c 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_mds.c
@@ -106,30 +106,6 @@ static void __init mpc834x_mds_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
-extern ulong ds1374_get_rtc_time(void);
-extern int ds1374_set_rtc_time(ulong);
-
-static int __init mpc834x_rtc_hookup(void)
-{
-	struct timespec tv;
-
-	if (!machine_is(mpc834x_mds))
-		return 0;
-
-	ppc_md.get_rtc_time = ds1374_get_rtc_time;
-	ppc_md.set_rtc_time = ds1374_set_rtc_time;
-
-	tv.tv_nsec = 0;
-	tv.tv_sec = (ppc_md.get_rtc_time) ();
-	do_settimeofday(&tv);
-
-	return 0;
-}
-
-late_initcall(mpc834x_rtc_hookup);
-#endif
-
 /*
  * Called very early, MMU is off, device-tree isn't unflattened
  */
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index 0f3855c..8d87b9c 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -152,30 +152,6 @@ static void __init mpc836x_mds_init_IRQ(void)
 #endif				/* CONFIG_QUICC_ENGINE */
 }
 
-#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
-extern ulong ds1374_get_rtc_time(void);
-extern int ds1374_set_rtc_time(ulong);
-
-static int __init mpc8360_rtc_hookup(void)
-{
-	struct timespec tv;
-
-	if (!machine_is(mpc836x_mds))
-		return 0;
-
-	ppc_md.get_rtc_time = ds1374_get_rtc_time;
-	ppc_md.set_rtc_time = ds1374_set_rtc_time;
-
-	tv.tv_nsec = 0;
-	tv.tv_sec = (ppc_md.get_rtc_time) ();
-	do_settimeofday(&tv);
-
-	return 0;
-}
-
-late_initcall(mpc8360_rtc_hookup);
-#endif
-
 /*
  * Called very early, MMU is off, device-tree isn't unflattened
  */
diff --git a/arch/ppc/platforms/83xx/mpc834x_sys.c b/arch/ppc/platforms/83xx/mpc834x_sys.c
index b84f8df..cb0a749 100644
--- a/arch/ppc/platforms/83xx/mpc834x_sys.c
+++ b/arch/ppc/platforms/83xx/mpc834x_sys.c
@@ -224,26 +224,6 @@ mpc834x_sys_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-#if defined(CONFIG_I2C_MPC) && defined(CONFIG_SENSORS_DS1374)
-extern ulong	ds1374_get_rtc_time(void);
-extern int	ds1374_set_rtc_time(ulong);
-
-static int __init
-mpc834x_rtc_hookup(void)
-{
-	struct timespec	tv;
-
-	ppc_md.get_rtc_time = ds1374_get_rtc_time;
-	ppc_md.set_rtc_time = ds1374_set_rtc_time;
-
-	tv.tv_nsec = 0;
-	tv.tv_sec = (ppc_md.get_rtc_time)();
-	do_settimeofday(&tv);
-
-	return 0;
-}
-late_initcall(mpc834x_rtc_hookup);
-#endif
 static __inline__ void
 mpc834x_sys_set_bat(void)
 {
diff --git a/arch/ppc/platforms/85xx/tqm85xx.c b/arch/ppc/platforms/85xx/tqm85xx.c
index 4ee2bd1..27ce389 100644
--- a/arch/ppc/platforms/85xx/tqm85xx.c
+++ b/arch/ppc/platforms/85xx/tqm85xx.c
@@ -258,27 +258,6 @@ int tqm85xx_show_cpuinfo(struct seq_file *m)
 	return 0;
 }
 
-#if defined(CONFIG_I2C) && defined(CONFIG_SENSORS_DS1337)
-extern ulong ds1337_get_rtc_time(void);
-extern int ds1337_set_rtc_time(unsigned long nowtime);
-
-static int __init
-tqm85xx_rtc_hookup(void)
-{
-	struct timespec	tv;
-
-        ppc_md.set_rtc_time = ds1337_set_rtc_time;
-        ppc_md.get_rtc_time = ds1337_get_rtc_time;
-
-	tv.tv_nsec = 0;
-	tv.tv_sec = (ppc_md.get_rtc_time)();
-	do_settimeofday(&tv);
-
-	return 0;
-}
-late_initcall(tqm85xx_rtc_hookup);
-#endif
-
 #ifdef CONFIG_PCI
 /*
  * interrupt routing
diff --git a/arch/ppc/platforms/katana.c b/arch/ppc/platforms/katana.c
index 52f63e6..fe6e88c 100644
--- a/arch/ppc/platforms/katana.c
+++ b/arch/ppc/platforms/katana.c
@@ -838,27 +838,6 @@ katana_find_end_of_memory(void)
 	return bdp->bi_memsize;
 }
 
-#if defined(CONFIG_I2C_MV64XXX) && defined(CONFIG_SENSORS_M41T00)
-extern ulong	m41t00_get_rtc_time(void);
-extern int	m41t00_set_rtc_time(ulong);
-
-static int __init
-katana_rtc_hookup(void)
-{
-	struct timespec	tv;
-
-	ppc_md.get_rtc_time = m41t00_get_rtc_time;
-	ppc_md.set_rtc_time = m41t00_set_rtc_time;
-
-	tv.tv_nsec = 0;
-	tv.tv_sec = (ppc_md.get_rtc_time)();
-	do_settimeofday(&tv);
-
-	return 0;
-}
-late_initcall(katana_rtc_hookup);
-#endif
-
 #if defined(CONFIG_SERIAL_TEXT_DEBUG) && defined(CONFIG_SERIAL_MPSC_CONSOLE)
 static void __init
 katana_map_io(void)
diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index 2e1c24f..5b8eb02 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -4,32 +4,6 @@
 
 menu "Miscellaneous I2C Chip support"
 
-config SENSORS_DS1337
-	tristate "Dallas DS1337 and DS1339 Real Time Clock (DEPRECATED)"
-	depends on EXPERIMENTAL
-	help
-	  If you say yes here you get support for Dallas Semiconductor
-	  DS1337 and DS1339 real-time clock chips.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called ds1337.
-
-	  This driver is deprecated and will be dropped soon. Use
-	  rtc-ds1307 instead.
-
-config SENSORS_DS1374
-	tristate "Dallas DS1374 Real Time Clock (DEPRECATED)"
-	depends on EXPERIMENTAL
-	help
-	  If you say yes here you get support for Dallas Semiconductor
-	  DS1374 real-time clock chips.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called ds1374.
-
-	  This driver is deprecated and will be dropped soon. Use
-	  rtc-ds1374 instead.
-
 config DS1682
 	tristate "Dallas DS1682 Total Elapsed Time Recorder with Alarm"
 	depends on EXPERIMENTAL
@@ -116,18 +90,6 @@ config TPS65010
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps65010.
 
-config SENSORS_M41T00
-	tristate "ST M41T00 RTC chip (DEPRECATED)"
-	depends on PPC32
-	help
-	  If you say yes here you get support for the ST M41T00 RTC chip.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called m41t00.
-
-	  This driver is deprecated and will be dropped soon. Use
-	  rtc-ds1307 or rtc-m41t80 instead.
-
 config SENSORS_MAX6875
 	tristate "Maxim MAX6875 Power supply supervisor"
 	depends on EXPERIMENTAL
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index ca924e1..1d5d1a5 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -2,12 +2,9 @@
 # Makefile for miscellaneous I2C chip drivers.
 #
 
-obj-$(CONFIG_SENSORS_DS1337)	+= ds1337.o
-obj-$(CONFIG_SENSORS_DS1374)	+= ds1374.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_SENSORS_EEPROM)	+= eeprom.o
 obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
-obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
 obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
 obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
diff --git a/drivers/i2c/chips/ds1337.c b/drivers/i2c/chips/ds1337.c
deleted file mode 100644
index ec17d6b..0000000
--- a/drivers/i2c/chips/ds1337.c
+++ /dev/null
@@ -1,410 +0,0 @@
-/*
- *  linux/drivers/i2c/chips/ds1337.c
- *
- *  Copyright (C) 2005 James Chapman <jchapman@katalix.com>
- *
- *	based on linux/drivers/acorn/char/pcf8583.c
- *  Copyright (C) 2000 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Driver for Dallas Semiconductor DS1337 and DS1339 real time clock chip
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
-#include <linux/string.h>
-#include <linux/rtc.h>		/* get the user-level API */
-#include <linux/bcd.h>
-#include <linux/list.h>
-
-/* Device registers */
-#define DS1337_REG_HOUR		2
-#define DS1337_REG_DAY		3
-#define DS1337_REG_DATE		4
-#define DS1337_REG_MONTH	5
-#define DS1337_REG_CONTROL	14
-#define DS1337_REG_STATUS	15
-
-/* FIXME - how do we export these interface constants? */
-#define DS1337_GET_DATE		0
-#define DS1337_SET_DATE		1
-
-/*
- * Functions declaration
- */
-static unsigned short normal_i2c[] = { 0x68, I2C_CLIENT_END };
-
-I2C_CLIENT_INSMOD_1(ds1337);
-
-static int ds1337_attach_adapter(struct i2c_adapter *adapter);
-static int ds1337_detect(struct i2c_adapter *adapter, int address, int kind);
-static void ds1337_init_client(struct i2c_client *client);
-static int ds1337_detach_client(struct i2c_client *client);
-static int ds1337_command(struct i2c_client *client, unsigned int cmd,
-			  void *arg);
-
-/*
- * Driver data (common to all clients)
- */
-static struct i2c_driver ds1337_driver = {
-	.driver = {
-		.name	= "ds1337",
-	},
-	.attach_adapter	= ds1337_attach_adapter,
-	.detach_client	= ds1337_detach_client,
-	.command	= ds1337_command,
-};
-
-/*
- * Client data (each client gets its own)
- */
-struct ds1337_data {
-	struct i2c_client client;
-	struct list_head list;
-};
-
-/*
- * Internal variables
- */
-static LIST_HEAD(ds1337_clients);
-
-static inline int ds1337_read(struct i2c_client *client, u8 reg, u8 *value)
-{
-	s32 tmp = i2c_smbus_read_byte_data(client, reg);
-
-	if (tmp < 0)
-		return -EIO;
-
-	*value = tmp;
-
-	return 0;
-}
-
-/*
- * Chip access functions
- */
-static int ds1337_get_datetime(struct i2c_client *client, struct rtc_time *dt)
-{
-	int result;
-	u8 buf[7];
-	u8 val;
-	struct i2c_msg msg[2];
-	u8 offs = 0;
-
-	if (!dt) {
-		dev_dbg(&client->dev, "%s: EINVAL: dt=NULL\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	msg[0].addr = client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf = &offs;
-
-	msg[1].addr = client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = sizeof(buf);
-	msg[1].buf = &buf[0];
-
-	result = i2c_transfer(client->adapter, msg, 2);
-
-	dev_dbg(&client->dev, "%s: [%d] %02x %02x %02x %02x %02x %02x %02x\n",
-		__FUNCTION__, result, buf[0], buf[1], buf[2], buf[3],
-		buf[4], buf[5], buf[6]);
-
-	if (result == 2) {
-		dt->tm_sec = BCD2BIN(buf[0]);
-		dt->tm_min = BCD2BIN(buf[1]);
-		val = buf[2] & 0x3f;
-		dt->tm_hour = BCD2BIN(val);
-		dt->tm_wday = BCD2BIN(buf[3]) - 1;
-		dt->tm_mday = BCD2BIN(buf[4]);
-		val = buf[5] & 0x7f;
-		dt->tm_mon = BCD2BIN(val) - 1;
-		dt->tm_year = BCD2BIN(buf[6]);
-		if (buf[5] & 0x80)
-			dt->tm_year += 100;
-
-		dev_dbg(&client->dev, "%s: secs=%d, mins=%d, "
-			"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
-			__FUNCTION__, dt->tm_sec, dt->tm_min,
-			dt->tm_hour, dt->tm_mday,
-			dt->tm_mon, dt->tm_year, dt->tm_wday);
-
-		return 0;
-	}
-
-	dev_err(&client->dev, "error reading data! %d\n", result);
-	return -EIO;
-}
-
-static int ds1337_set_datetime(struct i2c_client *client, struct rtc_time *dt)
-{
-	int result;
-	u8 buf[8];
-	u8 val;
-	struct i2c_msg msg[1];
-
-	if (!dt) {
-		dev_dbg(&client->dev, "%s: EINVAL: dt=NULL\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
-		"mday=%d, mon=%d, year=%d, wday=%d\n", __FUNCTION__,
-		dt->tm_sec, dt->tm_min, dt->tm_hour,
-		dt->tm_mday, dt->tm_mon, dt->tm_year, dt->tm_wday);
-
-	buf[0] = 0;		/* reg offset */
-	buf[1] = BIN2BCD(dt->tm_sec);
-	buf[2] = BIN2BCD(dt->tm_min);
-	buf[3] = BIN2BCD(dt->tm_hour);
-	buf[4] = BIN2BCD(dt->tm_wday + 1);
-	buf[5] = BIN2BCD(dt->tm_mday);
-	buf[6] = BIN2BCD(dt->tm_mon + 1);
-	val = dt->tm_year;
-	if (val >= 100) {
-		val -= 100;
-		buf[6] |= (1 << 7);
-	}
-	buf[7] = BIN2BCD(val);
-
-	msg[0].addr = client->addr;
-	msg[0].flags = 0;
-	msg[0].len = sizeof(buf);
-	msg[0].buf = &buf[0];
-
-	result = i2c_transfer(client->adapter, msg, 1);
-	if (result == 1)
-		return 0;
-
-	dev_err(&client->dev, "error writing data! %d\n", result);
-	return -EIO;
-}
-
-static int ds1337_command(struct i2c_client *client, unsigned int cmd,
-			  void *arg)
-{
-	dev_dbg(&client->dev, "%s: cmd=%d\n", __FUNCTION__, cmd);
-
-	switch (cmd) {
-	case DS1337_GET_DATE:
-		return ds1337_get_datetime(client, arg);
-
-	case DS1337_SET_DATE:
-		return ds1337_set_datetime(client, arg);
-
-	default:
-		return -EINVAL;
-	}
-}
-
-/*
- * Public API for access to specific device. Useful for low-level
- * RTC access from kernel code.
- */
-int ds1337_do_command(int bus, int cmd, void *arg)
-{
-	struct list_head *walk;
-	struct list_head *tmp;
-	struct ds1337_data *data;
-
-	list_for_each_safe(walk, tmp, &ds1337_clients) {
-		data = list_entry(walk, struct ds1337_data, list);
-		if (data->client.adapter->nr == bus)
-			return ds1337_command(&data->client, cmd, arg);
-	}
-
-	return -ENODEV;
-}
-
-static int ds1337_attach_adapter(struct i2c_adapter *adapter)
-{
-	return i2c_probe(adapter, &addr_data, ds1337_detect);
-}
-
-/*
- * The following function does more than just detection. If detection
- * succeeds, it also registers the new chip.
- */
-static int ds1337_detect(struct i2c_adapter *adapter, int address, int kind)
-{
-	struct i2c_client *new_client;
-	struct ds1337_data *data;
-	int err = 0;
-	const char *name = "";
-
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_I2C))
-		goto exit;
-
-	if (!(data = kzalloc(sizeof(struct ds1337_data), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto exit;
-	}
-	INIT_LIST_HEAD(&data->list);
-
-	/* The common I2C client data is placed right before the
-	 * DS1337-specific data. 
-	 */
-	new_client = &data->client;
-	i2c_set_clientdata(new_client, data);
-	new_client->addr = address;
-	new_client->adapter = adapter;
-	new_client->driver = &ds1337_driver;
-	new_client->flags = 0;
-
-	/*
-	 * Now we do the remaining detection. A negative kind means that
-	 * the driver was loaded with no force parameter (default), so we
-	 * must both detect and identify the chip. A zero kind means that
-	 * the driver was loaded with the force parameter, the detection
-	 * step shall be skipped. A positive kind means that the driver
-	 * was loaded with the force parameter and a given kind of chip is
-	 * requested, so both the detection and the identification steps
-	 * are skipped.
-	 *
-	 * For detection, we read registers that are most likely to cause
-	 * detection failure, i.e. those that have more bits with fixed
-	 * or reserved values.
-	 */
-
-	/* Default to an DS1337 if forced */
-	if (kind == 0)
-		kind = ds1337;
-
-	if (kind < 0) {		/* detection and identification */
-		u8 data;
-
-		/* Check that status register bits 6-2 are zero */
-		if ((ds1337_read(new_client, DS1337_REG_STATUS, &data) < 0) ||
-		    (data & 0x7c))
-			goto exit_free;
-
-		/* Check for a valid day register value */
-		if ((ds1337_read(new_client, DS1337_REG_DAY, &data) < 0) ||
-		    (data == 0) || (data & 0xf8))
-			goto exit_free;
-
-		/* Check for a valid date register value */
-		if ((ds1337_read(new_client, DS1337_REG_DATE, &data) < 0) ||
-		    (data == 0) || (data & 0xc0) || ((data & 0x0f) > 9) ||
-		    (data >= 0x32))
-			goto exit_free;
-
-		/* Check for a valid month register value */
-		if ((ds1337_read(new_client, DS1337_REG_MONTH, &data) < 0) ||
-		    (data == 0) || (data & 0x60) || ((data & 0x0f) > 9) ||
-		    ((data >= 0x13) && (data <= 0x19)))
-			goto exit_free;
-
-		/* Check that control register bits 6-5 are zero */
-		if ((ds1337_read(new_client, DS1337_REG_CONTROL, &data) < 0) ||
-		    (data & 0x60))
-			goto exit_free;
-
-		kind = ds1337;
-	}
-
-	if (kind == ds1337)
-		name = "ds1337";
-
-	/* We can fill in the remaining client fields */
-	strlcpy(new_client->name, name, I2C_NAME_SIZE);
-
-	/* Tell the I2C layer a new client has arrived */
-	if ((err = i2c_attach_client(new_client)))
-		goto exit_free;
-
-	/* Initialize the DS1337 chip */
-	ds1337_init_client(new_client);
-
-	/* Add client to local list */
-	list_add(&data->list, &ds1337_clients);
-
-	return 0;
-
-exit_free:
-	kfree(data);
-exit:
-	return err;
-}
-
-static void ds1337_init_client(struct i2c_client *client)
-{
-	u8 status, control;
-
-	/* On some boards, the RTC isn't configured by boot firmware.
-	 * Handle that case by starting/configuring the RTC now.
-	 */
-	status = i2c_smbus_read_byte_data(client, DS1337_REG_STATUS);
-	control = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
-
-	if ((status & 0x80) || (control & 0x80)) {
-		/* RTC not running */
-		u8 buf[1+16];	/* First byte is interpreted as address */
-		struct i2c_msg msg[1];
-
-		dev_dbg(&client->dev, "%s: RTC not running!\n", __FUNCTION__);
-
-		/* Initialize all, including STATUS and CONTROL to zero */
-		memset(buf, 0, sizeof(buf));
-
-		/* Write valid values in the date/time registers */
-		buf[1+DS1337_REG_DAY] = 1;
-		buf[1+DS1337_REG_DATE] = 1;
-		buf[1+DS1337_REG_MONTH] = 1;
-
-		msg[0].addr = client->addr;
-		msg[0].flags = 0;
-		msg[0].len = sizeof(buf);
-		msg[0].buf = &buf[0];
-
-		i2c_transfer(client->adapter, msg, 1);
-	} else {
-		/* Running: ensure that device is set in 24-hour mode */
-		s32 val;
-
-		val = i2c_smbus_read_byte_data(client, DS1337_REG_HOUR);
-		if ((val >= 0) && (val & (1 << 6)))
-			i2c_smbus_write_byte_data(client, DS1337_REG_HOUR,
-						  val & 0x3f);
-	}
-}
-
-static int ds1337_detach_client(struct i2c_client *client)
-{
-	int err;
-	struct ds1337_data *data = i2c_get_clientdata(client);
-
-	if ((err = i2c_detach_client(client)))
-		return err;
-
-	list_del(&data->list);
-	kfree(data);
-	return 0;
-}
-
-static int __init ds1337_init(void)
-{
-	return i2c_add_driver(&ds1337_driver);
-}
-
-static void __exit ds1337_exit(void)
-{
-	i2c_del_driver(&ds1337_driver);
-}
-
-MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
-MODULE_DESCRIPTION("DS1337 RTC driver");
-MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL_GPL(ds1337_do_command);
-
-module_init(ds1337_init);
-module_exit(ds1337_exit);
diff --git a/drivers/i2c/chips/ds1374.c b/drivers/i2c/chips/ds1374.c
deleted file mode 100644
index 8a2ff0c..0000000
--- a/drivers/i2c/chips/ds1374.c
+++ /dev/null
@@ -1,267 +0,0 @@
-/*
- * drivers/i2c/chips/ds1374.c
- *
- * I2C client/driver for the Maxim/Dallas DS1374 Real-Time Clock
- *
- * Author: Randy Vinson <rvinson@mvista.com>
- *
- * Based on the m41t00.c by Mark Greer <mgreer@mvista.com>
- *
- * 2005 (c) MontaVista Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-/*
- * This i2c client/driver wedges between the drivers/char/genrtc.c RTC
- * interface and the SMBus interface of the i2c subsystem.
- * It would be more efficient to use i2c msgs/i2c_transfer directly but, as
- * recommened in .../Documentation/i2c/writing-clients section
- * "Sending and receiving", using SMBus level communication is preferred.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/i2c.h>
-#include <linux/rtc.h>
-#include <linux/bcd.h>
-#include <linux/mutex.h>
-#include <linux/workqueue.h>
-
-#define DS1374_REG_TOD0		0x00
-#define DS1374_REG_TOD1		0x01
-#define DS1374_REG_TOD2		0x02
-#define DS1374_REG_TOD3		0x03
-#define DS1374_REG_WDALM0	0x04
-#define DS1374_REG_WDALM1	0x05
-#define DS1374_REG_WDALM2	0x06
-#define DS1374_REG_CR		0x07
-#define DS1374_REG_SR		0x08
-#define DS1374_REG_SR_OSF	0x80
-#define DS1374_REG_TCR		0x09
-
-#define	DS1374_DRV_NAME		"ds1374"
-
-static DEFINE_MUTEX(ds1374_mutex);
-
-static struct i2c_driver ds1374_driver;
-static struct i2c_client *save_client;
-
-static unsigned short ignore[] = { I2C_CLIENT_END };
-static unsigned short normal_addr[] = { 0x68, I2C_CLIENT_END };
-
-static struct i2c_client_address_data addr_data = {
-	.normal_i2c = normal_addr,
-	.probe = ignore,
-	.ignore = ignore,
-};
-
-static ulong ds1374_read_rtc(void)
-{
-	ulong time = 0;
-	int reg = DS1374_REG_WDALM0;
-
-	while (reg--) {
-		s32 tmp;
-		if ((tmp = i2c_smbus_read_byte_data(save_client, reg)) < 0) {
-			dev_warn(&save_client->dev,
-				 "can't read from rtc chip\n");
-			return 0;
-		}
-		time = (time << 8) | (tmp & 0xff);
-	}
-	return time;
-}
-
-static void ds1374_write_rtc(ulong time)
-{
-	int reg;
-
-	for (reg = DS1374_REG_TOD0; reg < DS1374_REG_WDALM0; reg++) {
-		if (i2c_smbus_write_byte_data(save_client, reg, time & 0xff)
-		    < 0) {
-			dev_warn(&save_client->dev,
-				 "can't write to rtc chip\n");
-			break;
-		}
-		time = time >> 8;
-	}
-}
-
-static void ds1374_check_rtc_status(void)
-{
-	s32 tmp;
-
-	tmp = i2c_smbus_read_byte_data(save_client, DS1374_REG_SR);
-	if (tmp < 0) {
-		dev_warn(&save_client->dev,
-			 "can't read status from rtc chip\n");
-		return;
-	}
-	if (tmp & DS1374_REG_SR_OSF) {
-		dev_warn(&save_client->dev,
-			 "oscillator discontinuity flagged, time unreliable\n");
-		tmp &= ~DS1374_REG_SR_OSF;
-		tmp = i2c_smbus_write_byte_data(save_client, DS1374_REG_SR,
-						tmp & 0xff);
-		if (tmp < 0)
-			dev_warn(&save_client->dev,
-				 "can't clear discontinuity notification\n");
-	}
-}
-
-ulong ds1374_get_rtc_time(void)
-{
-	ulong t1, t2;
-	int limit = 10;		/* arbitrary retry limit */
-
-	mutex_lock(&ds1374_mutex);
-
-	/*
-	 * Since the reads are being performed one byte at a time using
-	 * the SMBus vs a 4-byte i2c transfer, there is a chance that a
-	 * carry will occur during the read. To detect this, 2 reads are
-	 * performed and compared.
-	 */
-	do {
-		t1 = ds1374_read_rtc();
-		t2 = ds1374_read_rtc();
-	} while (t1 != t2 && limit--);
-
-	mutex_unlock(&ds1374_mutex);
-
-	if (t1 != t2) {
-		dev_warn(&save_client->dev,
-			 "can't get consistent time from rtc chip\n");
-		t1 = 0;
-	}
-
-	return t1;
-}
-
-static ulong new_time;
-
-static void ds1374_set_work(struct work_struct *work)
-{
-	ulong t1, t2;
-	int limit = 10;		/* arbitrary retry limit */
-
-	t1 = new_time;
-
-	mutex_lock(&ds1374_mutex);
-
-	/*
-	 * Since the writes are being performed one byte at a time using
-	 * the SMBus vs a 4-byte i2c transfer, there is a chance that a
-	 * carry will occur during the write. To detect this, the write
-	 * value is read back and compared.
-	 */
-	do {
-		ds1374_write_rtc(t1);
-		t2 = ds1374_read_rtc();
-	} while (t1 != t2 && limit--);
-
-	mutex_unlock(&ds1374_mutex);
-
-	if (t1 != t2)
-		dev_warn(&save_client->dev,
-			 "can't confirm time set from rtc chip\n");
-}
-
-static struct workqueue_struct *ds1374_workqueue;
-
-static DECLARE_WORK(ds1374_work, ds1374_set_work);
-
-int ds1374_set_rtc_time(ulong nowtime)
-{
-	new_time = nowtime;
-
-	if (in_interrupt())
-		queue_work(ds1374_workqueue, &ds1374_work);
-	else
-		ds1374_set_work(NULL);
-
-	return 0;
-}
-
-/*
- *****************************************************************************
- *
- *	Driver Interface
- *
- *****************************************************************************
- */
-static int ds1374_probe(struct i2c_adapter *adap, int addr, int kind)
-{
-	struct i2c_client *client;
-	int rc;
-
-	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
-
-	strncpy(client->name, DS1374_DRV_NAME, I2C_NAME_SIZE);
-	client->addr = addr;
-	client->adapter = adap;
-	client->driver = &ds1374_driver;
-
-	ds1374_workqueue = create_singlethread_workqueue("ds1374");
-	if (!ds1374_workqueue) {
-		kfree(client);
-		return -ENOMEM;	/* most expected reason */
-	}
-
-	if ((rc = i2c_attach_client(client)) != 0) {
-		kfree(client);
-		return rc;
-	}
-
-	save_client = client;
-
-	ds1374_check_rtc_status();
-
-	return 0;
-}
-
-static int ds1374_attach(struct i2c_adapter *adap)
-{
-	return i2c_probe(adap, &addr_data, ds1374_probe);
-}
-
-static int ds1374_detach(struct i2c_client *client)
-{
-	int rc;
-
-	if ((rc = i2c_detach_client(client)) == 0) {
-		kfree(i2c_get_clientdata(client));
-		destroy_workqueue(ds1374_workqueue);
-	}
-	return rc;
-}
-
-static struct i2c_driver ds1374_driver = {
-	.driver = {
-		.name	= DS1374_DRV_NAME,
-	},
-	.id = I2C_DRIVERID_DS1374,
-	.attach_adapter = ds1374_attach,
-	.detach_client = ds1374_detach,
-};
-
-static int __init ds1374_init(void)
-{
-	return i2c_add_driver(&ds1374_driver);
-}
-
-static void __exit ds1374_exit(void)
-{
-	i2c_del_driver(&ds1374_driver);
-}
-
-module_init(ds1374_init);
-module_exit(ds1374_exit);
-
-MODULE_AUTHOR("Randy Vinson <rvinson@mvista.com>");
-MODULE_DESCRIPTION("Maxim/Dallas DS1374 RTC I2C Client Driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/chips/m41t00.c b/drivers/i2c/chips/m41t00.c
deleted file mode 100644
index 3fcb646..0000000
--- a/drivers/i2c/chips/m41t00.c
+++ /dev/null
@@ -1,413 +0,0 @@
-/*
- * I2C client/driver for the ST M41T00 family of i2c rtc chips.
- *
- * Author: Mark A. Greer <mgreer@mvista.com>
- *
- * 2005, 2006 (c) MontaVista Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-/*
- * This i2c client/driver wedges between the drivers/char/genrtc.c RTC
- * interface and the SMBus interface of the i2c subsystem.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/i2c.h>
-#include <linux/rtc.h>
-#include <linux/bcd.h>
-#include <linux/workqueue.h>
-#include <linux/platform_device.h>
-#include <linux/m41t00.h>
-#include <asm/time.h>
-#include <asm/rtc.h>
-
-static struct i2c_driver m41t00_driver;
-static struct i2c_client *save_client;
-
-static unsigned short ignore[] = { I2C_CLIENT_END };
-static unsigned short normal_addr[] = { I2C_CLIENT_END, I2C_CLIENT_END };
-
-static struct i2c_client_address_data addr_data = {
-	.normal_i2c	= normal_addr,
-	.probe		= ignore,
-	.ignore		= ignore,
-};
-
-struct m41t00_chip_info {
-	u8	type;
-	char	*name;
-	u8	read_limit;
-	u8	sec;		/* Offsets for chip regs */
-	u8	min;
-	u8	hour;
-	u8	day;
-	u8	mon;
-	u8	year;
-	u8	alarm_mon;
-	u8	alarm_hour;
-	u8	sqw;
-	u8	sqw_freq;
-};
-
-static struct m41t00_chip_info m41t00_chip_info_tbl[] = {
-	{
-		.type		= M41T00_TYPE_M41T00,
-		.name		= "m41t00",
-		.read_limit	= 5,
-		.sec		= 0,
-		.min		= 1,
-		.hour		= 2,
-		.day		= 4,
-		.mon		= 5,
-		.year		= 6,
-	},
-	{
-		.type		= M41T00_TYPE_M41T81,
-		.name		= "m41t81",
-		.read_limit	= 1,
-		.sec		= 1,
-		.min		= 2,
-		.hour		= 3,
-		.day		= 5,
-		.mon		= 6,
-		.year		= 7,
-		.alarm_mon	= 0xa,
-		.alarm_hour	= 0xc,
-		.sqw		= 0x13,
-	},
-	{
-		.type		= M41T00_TYPE_M41T85,
-		.name		= "m41t85",
-		.read_limit	= 1,
-		.sec		= 1,
-		.min		= 2,
-		.hour		= 3,
-		.day		= 5,
-		.mon		= 6,
-		.year		= 7,
-		.alarm_mon	= 0xa,
-		.alarm_hour	= 0xc,
-		.sqw		= 0x13,
-	},
-};
-static struct m41t00_chip_info *m41t00_chip;
-
-ulong
-m41t00_get_rtc_time(void)
-{
-	s32 sec, min, hour, day, mon, year;
-	s32 sec1, min1, hour1, day1, mon1, year1;
-	u8 reads = 0;
-	u8 buf[8], msgbuf[1] = { 0 }; /* offset into rtc's regs */
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= msgbuf,
-		},
-		{
-			.addr	= save_client->addr,
-			.flags	= I2C_M_RD,
-			.len	= 8,
-			.buf	= buf,
-		},
-	};
-
-	sec = min = hour = day = mon = year = 0;
-
-	do {
-		if (i2c_transfer(save_client->adapter, msgs, 2) < 0)
-			goto read_err;
-
-		sec1 = sec;
-		min1 = min;
-		hour1 = hour;
-		day1 = day;
-		mon1 = mon;
-		year1 = year;
-
-		sec = buf[m41t00_chip->sec] & 0x7f;
-		min = buf[m41t00_chip->min] & 0x7f;
-		hour = buf[m41t00_chip->hour] & 0x3f;
-		day = buf[m41t00_chip->day] & 0x3f;
-		mon = buf[m41t00_chip->mon] & 0x1f;
-		year = buf[m41t00_chip->year];
-	} while ((++reads < m41t00_chip->read_limit) && ((sec != sec1)
-			|| (min != min1) || (hour != hour1) || (day != day1)
-			|| (mon != mon1) || (year != year1)));
-
-	if ((m41t00_chip->read_limit > 1) && ((sec != sec1) || (min != min1)
-			|| (hour != hour1) || (day != day1) || (mon != mon1)
-			|| (year != year1)))
-		goto read_err;
-
-	sec = BCD2BIN(sec);
-	min = BCD2BIN(min);
-	hour = BCD2BIN(hour);
-	day = BCD2BIN(day);
-	mon = BCD2BIN(mon);
-	year = BCD2BIN(year);
-
-	year += 1900;
-	if (year < 1970)
-		year += 100;
-
-	return mktime(year, mon, day, hour, min, sec);
-
-read_err:
-	dev_err(&save_client->dev, "m41t00_get_rtc_time: Read error\n");
-	return 0;
-}
-EXPORT_SYMBOL_GPL(m41t00_get_rtc_time);
-
-static void
-m41t00_set(void *arg)
-{
-	struct rtc_time	tm;
-	int nowtime = *(int *)arg;
-	s32 sec, min, hour, day, mon, year;
-	u8 wbuf[9], *buf = &wbuf[1], msgbuf[1] = { 0 };
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= msgbuf,
-		},
-		{
-			.addr	= save_client->addr,
-			.flags	= I2C_M_RD,
-			.len	= 8,
-			.buf	= buf,
-		},
-	};
-
-	to_tm(nowtime, &tm);
-	tm.tm_year = (tm.tm_year - 1900) % 100;
-
-	sec = BIN2BCD(tm.tm_sec);
-	min = BIN2BCD(tm.tm_min);
-	hour = BIN2BCD(tm.tm_hour);
-	day = BIN2BCD(tm.tm_mday);
-	mon = BIN2BCD(tm.tm_mon);
-	year = BIN2BCD(tm.tm_year);
-
-	/* Read reg values into buf[0..7]/wbuf[1..8] */
-	if (i2c_transfer(save_client->adapter, msgs, 2) < 0) {
-		dev_err(&save_client->dev, "m41t00_set: Read error\n");
-		return;
-	}
-
-	wbuf[0] = 0; /* offset into rtc's regs */
-	buf[m41t00_chip->sec] = (buf[m41t00_chip->sec] & ~0x7f) | (sec & 0x7f);
-	buf[m41t00_chip->min] = (buf[m41t00_chip->min] & ~0x7f) | (min & 0x7f);
-	buf[m41t00_chip->hour] = (buf[m41t00_chip->hour] & ~0x3f) | (hour& 0x3f);
-	buf[m41t00_chip->day] = (buf[m41t00_chip->day] & ~0x3f) | (day & 0x3f);
-	buf[m41t00_chip->mon] = (buf[m41t00_chip->mon] & ~0x1f) | (mon & 0x1f);
-	buf[m41t00_chip->year] = year;
-
-	if (i2c_master_send(save_client, wbuf, 9) < 0)
-		dev_err(&save_client->dev, "m41t00_set: Write error\n");
-}
-
-static ulong new_time;
-/* well, isn't this API just _lovely_? */
-static void
-m41t00_barf(struct work_struct *unusable)
-{
-	m41t00_set(&new_time);
-}
-
-static struct workqueue_struct *m41t00_wq;
-static DECLARE_WORK(m41t00_work, m41t00_barf);
-
-int
-m41t00_set_rtc_time(ulong nowtime)
-{
-	new_time = nowtime;
-
-	if (in_interrupt())
-		queue_work(m41t00_wq, &m41t00_work);
-	else
-		m41t00_set(&new_time);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(m41t00_set_rtc_time);
-
-/*
- *****************************************************************************
- *
- *	platform_data Driver Interface
- *
- *****************************************************************************
- */
-static int __init
-m41t00_platform_probe(struct platform_device *pdev)
-{
-	struct m41t00_platform_data *pdata;
-	int i;
-
-	if (pdev && (pdata = pdev->dev.platform_data)) {
-		normal_addr[0] = pdata->i2c_addr;
-
-		for (i=0; i<ARRAY_SIZE(m41t00_chip_info_tbl); i++)
-			if (m41t00_chip_info_tbl[i].type == pdata->type) {
-				m41t00_chip = &m41t00_chip_info_tbl[i];
-				m41t00_chip->sqw_freq = pdata->sqw_freq;
-				return 0;
-			}
-	}
-	return -ENODEV;
-}
-
-static int __exit
-m41t00_platform_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
-static struct platform_driver m41t00_platform_driver = {
-	.probe  = m41t00_platform_probe,
-	.remove = m41t00_platform_remove,
-	.driver = {
-		.owner = THIS_MODULE,
-		.name  = M41T00_DRV_NAME,
-	},
-};
-
-/*
- *****************************************************************************
- *
- *	Driver Interface
- *
- *****************************************************************************
- */
-static int
-m41t00_probe(struct i2c_adapter *adap, int addr, int kind)
-{
-	struct i2c_client *client;
-	int rc;
-
-	if (!i2c_check_functionality(adap, I2C_FUNC_I2C
-			| I2C_FUNC_SMBUS_BYTE_DATA))
-		return 0;
-
-	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
-
-	strlcpy(client->name, m41t00_chip->name, I2C_NAME_SIZE);
-	client->addr = addr;
-	client->adapter = adap;
-	client->driver = &m41t00_driver;
-
-	if ((rc = i2c_attach_client(client)))
-		goto attach_err;
-
-	if (m41t00_chip->type != M41T00_TYPE_M41T00) {
-		/* If asked, disable SQW, set SQW frequency & re-enable */
-		if (m41t00_chip->sqw_freq)
-			if (((rc = i2c_smbus_read_byte_data(client,
-					m41t00_chip->alarm_mon)) < 0)
-			 || ((rc = i2c_smbus_write_byte_data(client,
-					m41t00_chip->alarm_mon, rc & ~0x40)) <0)
-			 || ((rc = i2c_smbus_write_byte_data(client,
-					m41t00_chip->sqw,
-					m41t00_chip->sqw_freq)) < 0)
-			 || ((rc = i2c_smbus_write_byte_data(client,
-					m41t00_chip->alarm_mon, rc | 0x40)) <0))
-				goto sqw_err;
-
-		/* Make sure HT (Halt Update) bit is cleared */
-		if ((rc = i2c_smbus_read_byte_data(client,
-				m41t00_chip->alarm_hour)) < 0)
-			goto ht_err;
-
-		if (rc & 0x40)
-			if ((rc = i2c_smbus_write_byte_data(client,
-					m41t00_chip->alarm_hour, rc & ~0x40))<0)
-				goto ht_err;
-	}
-
-	/* Make sure ST (stop) bit is cleared */
-	if ((rc = i2c_smbus_read_byte_data(client, m41t00_chip->sec)) < 0)
-		goto st_err;
-
-	if (rc & 0x80)
-		if ((rc = i2c_smbus_write_byte_data(client, m41t00_chip->sec,
-				rc & ~0x80)) < 0)
-			goto st_err;
-
-	m41t00_wq = create_singlethread_workqueue(m41t00_chip->name);
-	save_client = client;
-	return 0;
-
-st_err:
-	dev_err(&client->dev, "m41t00_probe: Can't clear ST bit\n");
-	goto attach_err;
-ht_err:
-	dev_err(&client->dev, "m41t00_probe: Can't clear HT bit\n");
-	goto attach_err;
-sqw_err:
-	dev_err(&client->dev, "m41t00_probe: Can't set SQW Frequency\n");
-attach_err:
-	kfree(client);
-	return rc;
-}
-
-static int
-m41t00_attach(struct i2c_adapter *adap)
-{
-	return i2c_probe(adap, &addr_data, m41t00_probe);
-}
-
-static int
-m41t00_detach(struct i2c_client *client)
-{
-	int rc;
-
-	if ((rc = i2c_detach_client(client)) == 0) {
-		kfree(client);
-		destroy_workqueue(m41t00_wq);
-	}
-	return rc;
-}
-
-static struct i2c_driver m41t00_driver = {
-	.driver = {
-		.name	= M41T00_DRV_NAME,
-	},
-	.id		= I2C_DRIVERID_STM41T00,
-	.attach_adapter	= m41t00_attach,
-	.detach_client	= m41t00_detach,
-};
-
-static int __init
-m41t00_init(void)
-{
-	int rc;
-
-	if (!(rc = platform_driver_register(&m41t00_platform_driver)))
-		rc = i2c_add_driver(&m41t00_driver);
-	return rc;
-}
-
-static void __exit
-m41t00_exit(void)
-{
-	i2c_del_driver(&m41t00_driver);
-	platform_driver_unregister(&m41t00_platform_driver);
-}
-
-module_init(m41t00_init);
-module_exit(m41t00_exit);
-
-MODULE_AUTHOR("Mark A. Greer <mgreer@mvista.com>");
-MODULE_DESCRIPTION("ST Microelectronics M41T00 RTC I2C Client Driver");
-MODULE_LICENSE("GPL");
diff --git a/include/linux/m41t00.h b/include/linux/m41t00.h
deleted file mode 100644
index b423360..0000000
--- a/include/linux/m41t00.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Definitions for the ST M41T00 family of i2c rtc chips.
- *
- * Author: Mark A. Greer <mgreer@mvista.com>
- *
- * 2005, 2006 (c) MontaVista Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#ifndef _M41T00_H
-#define _M41T00_H
-
-#define	M41T00_DRV_NAME		"m41t00"
-#define	M41T00_I2C_ADDR		0x68
-
-#define	M41T00_TYPE_M41T00	0
-#define	M41T00_TYPE_M41T81	81
-#define	M41T00_TYPE_M41T85	85
-
-struct m41t00_platform_data {
-	u8	type;
-	u8	i2c_addr;
-	u8	sqw_freq;
-};
-
-/* SQW output disabled, this is default value by power on */
-#define M41T00_SQW_DISABLE	(0)
-
-#define M41T00_SQW_32KHZ	(1<<4)		/* 32.768 KHz */
-#define M41T00_SQW_8KHZ		(2<<4)		/* 8.192 KHz */
-#define M41T00_SQW_4KHZ		(3<<4)		/* 4.096 KHz */
-#define M41T00_SQW_2KHZ		(4<<4)		/* 2.048 KHz */
-#define M41T00_SQW_1KHZ		(5<<4)		/* 1.024 KHz */
-#define M41T00_SQW_512HZ	(6<<4)		/* 512 Hz */
-#define M41T00_SQW_256HZ	(7<<4)		/* 256 Hz */
-#define M41T00_SQW_128HZ	(8<<4)		/* 128 Hz */
-#define M41T00_SQW_64HZ		(9<<4)		/* 64 Hz */
-#define M41T00_SQW_32HZ		(10<<4)		/* 32 Hz */
-#define M41T00_SQW_16HZ		(11<<4)		/* 16 Hz */
-#define M41T00_SQW_8HZ		(12<<4)		/* 8 Hz */
-#define M41T00_SQW_4HZ		(13<<4)		/* 4 Hz */
-#define M41T00_SQW_2HZ		(14<<4)		/* 2 Hz */
-#define M41T00_SQW_1HZ		(15<<4)		/* 1 Hz */
-
-extern ulong m41t00_get_rtc_time(void);
-extern int m41t00_set_rtc_time(ulong nowtime);
-
-#endif /* _M41T00_H */

