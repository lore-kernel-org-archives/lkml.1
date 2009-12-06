Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZLFHFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZLFHFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZLFHFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:05:30 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54697 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZLFHFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vK+/ZULEPcOJcRdiEvbgSGiuQi4x596vY5zcmSDl/Q4uDBHfKAsUz+6iKoATJ/cCf8
         eU8znkyMWCxTqe1i87X2cx2oFjrHkBZf0elY/Z4nw+obFRywldolCLfsAIDdjgwM8Wbw
         UFgMuOEqZQQgd3L/GdYVMsNfsGAU9ljhEFxlE=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v8 2/8] Loongson: YeeLoong: add platform driver
Date: Sun,  6 Dec 2009 15:01:42 +0800
Message-Id: <5a8742a71e96ba40bee34fb37478cc8339e76530.1260082252.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <d6bb11d33fe01abd6de945117ce647af73841f00.1260082252.git.wuzhangjin@gmail.com>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
 <d6bb11d33fe01abd6de945117ce647af73841f00.1260082252.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260082252.git.wuzhangjin@gmail.com>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds platform driver for YeeLoong, Currently, This driver is
"empty", the subdrivers will be added in the coming patches.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/mach-loongson/ec_kb3310b.h |  191 ++++++++++++++++++++++
 arch/mips/loongson/lemote-2f/Makefile            |    2 +-
 arch/mips/loongson/lemote-2f/ec_kb3310b.c        |   12 +-
 arch/mips/loongson/lemote-2f/ec_kb3310b.h        |  188 ---------------------
 arch/mips/loongson/lemote-2f/platform.c          |   40 +++++
 arch/mips/loongson/lemote-2f/pm.c                |    4 +-
 arch/mips/loongson/lemote-2f/reset.c             |    2 +-
 drivers/platform/Makefile                        |    1 +
 drivers/platform/mips/Kconfig                    |    8 +
 drivers/platform/mips/Makefile                   |    5 +
 drivers/platform/mips/yeeloong_laptop.c          |   60 +++++++
 11 files changed, 313 insertions(+), 200 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/ec_kb3310b.h
 delete mode 100644 arch/mips/loongson/lemote-2f/ec_kb3310b.h
 create mode 100644 arch/mips/loongson/lemote-2f/platform.c
 create mode 100644 drivers/platform/mips/Makefile
 create mode 100644 drivers/platform/mips/yeeloong_laptop.c

diff --git a/arch/mips/include/asm/mach-loongson/ec_kb3310b.h b/arch/mips/include/asm/mach-loongson/ec_kb3310b.h
new file mode 100644
index 0000000..4fccb5d
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/ec_kb3310b.h
@@ -0,0 +1,191 @@
+/*
+ * KB3310B Embedded Controller
+ *
+ *  Copyright (C) 2008 Lemote Inc.
+ *  Author: liujl <liujl@lemote.com>, 2008-03-14
+ *  Copyright (C) 2009 Lemote Inc.
+ *  Author: Wu Zhangjin <wuzhangjin@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _EC_KB3310B_H
+#define _EC_KB3310B_H
+
+extern unsigned char ec_read(unsigned short addr);
+extern void ec_write(unsigned short addr, unsigned char val);
+extern int ec_query_seq(unsigned char cmd);
+extern int ec_query_event_num(void);
+extern int ec_get_event_num(void);
+
+typedef int (*sci_handler) (int status);
+extern sci_handler yeeloong_report_lid_status;
+
+#define SCI_IRQ_NUM 0x0A
+
+/*
+ * The following registers are determined by the EC index configuration.
+ * 1, fill the PORT_HIGH as EC register high part.
+ * 2, fill the PORT_LOW as EC register low part.
+ * 3, fill the PORT_DATA as EC register write data or get the data from it.
+ */
+#define	EC_IO_PORT_HIGH	0x0381
+#define	EC_IO_PORT_LOW	0x0382
+#define	EC_IO_PORT_DATA	0x0383
+
+/*
+ * EC delay time is 500us for register and status access
+ */
+#define	EC_REG_DELAY	500	/* unit : us */
+#define	EC_CMD_TIMEOUT	0x1000
+
+/*
+ * EC access port for SCI communication
+ */
+#define	EC_CMD_PORT		0x66
+#define	EC_STS_PORT		0x66
+#define	EC_DAT_PORT		0x62
+#define	CMD_INIT_IDLE_MODE	0xdd
+#define	CMD_EXIT_IDLE_MODE	0xdf
+#define	CMD_INIT_RESET_MODE	0xd8
+#define	CMD_REBOOT_SYSTEM	0x8c
+#define	CMD_GET_EVENT_NUM	0x84
+#define	CMD_PROGRAM_PIECE	0xda
+
+/* Temperature & Fan registers */
+#define	REG_TEMPERATURE_VALUE	0xF458
+#define	REG_FAN_AUTO_MAN_SWITCH 0xF459
+#define	BIT_FAN_AUTO		0
+#define	BIT_FAN_MANUAL		1
+#define	REG_FAN_CONTROL		0xF4D2
+#define	BIT_FAN_CONTROL_ON	(1 << 0)
+#define	BIT_FAN_CONTROL_OFF	(0 << 0)
+#define	REG_FAN_STATUS		0xF4DA
+#define	BIT_FAN_STATUS_ON	(1 << 0)
+#define	BIT_FAN_STATUS_OFF	(0 << 0)
+#define	REG_FAN_SPEED_HIGH	0xFE22
+#define	REG_FAN_SPEED_LOW	0xFE23
+#define	REG_FAN_SPEED_LEVEL	0xF4CC
+/* Fan speed divider */
+#define	FAN_SPEED_DIVIDER	480000	/* (60*1000*1000/62.5/2)*/
+
+/* Battery registers */
+#define	REG_BAT_DESIGN_CAP_HIGH		0xF77D
+#define	REG_BAT_DESIGN_CAP_LOW		0xF77E
+#define	REG_BAT_FULLCHG_CAP_HIGH	0xF780
+#define	REG_BAT_FULLCHG_CAP_LOW		0xF781
+#define	REG_BAT_DESIGN_VOL_HIGH		0xF782
+#define	REG_BAT_DESIGN_VOL_LOW		0xF783
+#define	REG_BAT_CURRENT_HIGH		0xF784
+#define	REG_BAT_CURRENT_LOW		0xF785
+#define	REG_BAT_VOLTAGE_HIGH		0xF786
+#define	REG_BAT_VOLTAGE_LOW		0xF787
+#define	REG_BAT_TEMPERATURE_HIGH	0xF788
+#define	REG_BAT_TEMPERATURE_LOW		0xF789
+#define	REG_BAT_RELATIVE_CAP_HIGH	0xF492
+#define	REG_BAT_RELATIVE_CAP_LOW	0xF493
+#define	REG_BAT_VENDOR			0xF4C4
+#define	FLAG_BAT_VENDOR_SANYO		0x01
+#define	FLAG_BAT_VENDOR_SIMPLO		0x02
+#define	REG_BAT_CELL_COUNT		0xF4C6
+#define	FLAG_BAT_CELL_3S1P		0x03
+#define	FLAG_BAT_CELL_3S2P		0x06
+#define	REG_BAT_CHARGE			0xF4A2
+#define	FLAG_BAT_CHARGE_DISCHARGE	0x01
+#define	FLAG_BAT_CHARGE_CHARGE		0x02
+#define	FLAG_BAT_CHARGE_ACPOWER		0x00
+#define	REG_BAT_STATUS			0xF4B0
+#define	BIT_BAT_STATUS_LOW		(1 << 5)
+#define	BIT_BAT_STATUS_DESTROY		(1 << 2)
+#define	BIT_BAT_STATUS_FULL		(1 << 1)
+#define	BIT_BAT_STATUS_IN		(1 << 0)
+#define	REG_BAT_CHARGE_STATUS		0xF4B1
+#define	BIT_BAT_CHARGE_STATUS_OVERTEMP	(1 << 2)
+#define	BIT_BAT_CHARGE_STATUS_PRECHG	(1 << 1)
+#define	REG_BAT_STATE			0xF482
+#define	BIT_BAT_STATE_CHARGING		(1 << 1)
+#define	BIT_BAT_STATE_DISCHARGING	(1 << 0)
+#define	REG_BAT_POWER			0xF440
+#define	BIT_BAT_POWER_S3		(1 << 2)
+#define	BIT_BAT_POWER_ON		(1 << 1)
+#define	BIT_BAT_POWER_ACIN		(1 << 0)
+
+/* Audio: rd/wr */
+#define	REG_AUDIO_VOLUME	0xF46C
+#define	REG_AUDIO_MUTE		0xF4E7
+#define	REG_AUDIO_BEEP		0xF4D0
+/* USB port power or not: rd/wr */
+#define	REG_USB0_FLAG		0xF461
+#define	REG_USB1_FLAG		0xF462
+#define	REG_USB2_FLAG		0xF463
+#define	BIT_USB_FLAG_ON		1
+#define	BIT_USB_FLAG_OFF	0
+/* LID */
+#define	REG_LID_DETECT		0xF4BD
+#define	BIT_LID_DETECT_ON	1
+#define	BIT_LID_DETECT_OFF	0
+/* CRT */
+#define	REG_CRT_DETECT		0xF4AD
+#define	BIT_CRT_DETECT_PLUG	1
+#define	BIT_CRT_DETECT_UNPLUG	0
+/* LCD backlight brightness adjust: 9 levels */
+#define	REG_DISPLAY_BRIGHTNESS	0xF4F5
+/* Black screen Status */
+#define	BIT_DISPLAY_LCD_ON	1
+#define	BIT_DISPLAY_LCD_OFF	0
+/* LCD backlight control: off/restore */
+#define	REG_BACKLIGHT_CTRL	0xF7BD
+#define	BIT_BACKLIGHT_ON	1
+#define	BIT_BACKLIGHT_OFF	0
+/* Reset the machine auto-clear: rd/wr */
+#define	REG_RESET		0xF4EC
+#define	BIT_RESET_ON		1
+/* Light the led: rd/wr */
+#define	REG_LED			0xF4C8
+#define	BIT_LED_RED_POWER	(1 << 0)
+#define	BIT_LED_ORANGE_POWER	(1 << 1)
+#define	BIT_LED_GREEN_CHARGE	(1 << 2)
+#define	BIT_LED_RED_CHARGE	(1 << 3)
+#define	BIT_LED_NUMLOCK		(1 << 4)
+/* Test led mode, all led on/off */
+#define	REG_LED_TEST		0xF4C2
+#define	BIT_LED_TEST_IN		1
+#define	BIT_LED_TEST_OUT	0
+/* Camera on/off */
+#define	REG_CAMERA_STATUS	0xF46A
+#define	BIT_CAMERA_STATUS_ON	1
+#define	BIT_CAMERA_STATUS_OFF	0
+#define	REG_CAMERA_CONTROL	0xF7B7
+#define	BIT_CAMERA_CONTROL_OFF	0
+#define	BIT_CAMERA_CONTROL_ON	1
+/* Wlan Status */
+#define	REG_WLAN		0xF4FA
+#define	BIT_WLAN_ON		1
+#define	BIT_WLAN_OFF		0
+#define	REG_DISPLAY_LCD		0xF79F
+
+/* SCI Event Number from EC */
+enum {
+	EVENT_LID = 0x23,	/*  Turn on/off LID */
+	EVENT_DISPLAY_TOGGLE,	/*  Fn+F3 for display switch */
+	EVENT_SLEEP,		/*  Fn+F1 for entering sleep mode */
+	EVENT_OVERTEMP,		/*  Over-temperature happened */
+	EVENT_CRT_DETECT,	/*  CRT is connected */
+	EVENT_CAMERA,		/*  Camera on/off */
+	EVENT_USB_OC2,		/*  USB2 Over Current occurred */
+	EVENT_USB_OC0,		/*  USB0 Over Current occurred */
+	EVENT_BLACK_SCREEN,	/*  Turn on/off backlight */
+	EVENT_AUDIO_MUTE,	/*  Mute on/off */
+	EVENT_DISPLAY_BRIGHTNESS,/* LCD backlight brightness adjust */
+	EVENT_AC_BAT,		/*  AC & Battery relative issue */
+	EVENT_AUDIO_VOLUME,	/*  Volume adjust */
+	EVENT_WLAN,		/*  Wlan on/off */
+};
+
+#define EVENT_START	EVENT_LID
+#define EVENT_END	EVENT_WLAN
+
+#endif /* !_EC_KB3310B_H */
diff --git a/arch/mips/loongson/lemote-2f/Makefile b/arch/mips/loongson/lemote-2f/Makefile
index 4d84b27..470156e 100644
--- a/arch/mips/loongson/lemote-2f/Makefile
+++ b/arch/mips/loongson/lemote-2f/Makefile
@@ -2,7 +2,7 @@
 # Makefile for lemote loongson2f family machines
 #
 
-obj-y += irq.o reset.o ec_kb3310b.o
+obj-y += irq.o reset.o ec_kb3310b.o platform.o
 
 #
 # Suspend Support
diff --git a/arch/mips/loongson/lemote-2f/ec_kb3310b.c b/arch/mips/loongson/lemote-2f/ec_kb3310b.c
index 4d84111..734d2d0 100644
--- a/arch/mips/loongson/lemote-2f/ec_kb3310b.c
+++ b/arch/mips/loongson/lemote-2f/ec_kb3310b.c
@@ -14,7 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 
-#include "ec_kb3310b.h"
+#include <ec_kb3310b.h>
 
 static DEFINE_SPINLOCK(index_access_lock);
 static DEFINE_SPINLOCK(port_access_lock);
@@ -76,12 +76,9 @@ int ec_query_seq(unsigned char cmd)
 	}
 
 	if (timeout <= 0) {
-		printk(KERN_ERR "%s: deadable error : timeout...\n", __func__);
+		pr_err("%s: deadable error : timeout...\n", __func__);
 		ret = -EINVAL;
-	} else
-		printk(KERN_INFO
-			   "(%x/%d)ec issued command %d status : 0x%x\n",
-			   timeout, EC_CMD_TIMEOUT - timeout, cmd, status);
+	}
 
 	spin_unlock_irqrestore(&port_access_lock, flags);
 
@@ -118,8 +115,7 @@ int ec_get_event_num(void)
 		udelay(EC_REG_DELAY);
 	}
 	if (timeout <= 0) {
-		pr_info("%s: get event number timeout.\n", __func__);
-
+		pr_err("%s: get event number timeout.\n", __func__);
 		return -EINVAL;
 	}
 	value = inb(EC_DAT_PORT);
diff --git a/arch/mips/loongson/lemote-2f/ec_kb3310b.h b/arch/mips/loongson/lemote-2f/ec_kb3310b.h
deleted file mode 100644
index 1595a21..0000000
--- a/arch/mips/loongson/lemote-2f/ec_kb3310b.h
+++ /dev/null
@@ -1,188 +0,0 @@
-/*
- * KB3310B Embedded Controller
- *
- *  Copyright (C) 2008 Lemote Inc.
- *  Author: liujl <liujl@lemote.com>, 2008-03-14
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _EC_KB3310B_H
-#define _EC_KB3310B_H
-
-extern unsigned char ec_read(unsigned short addr);
-extern void ec_write(unsigned short addr, unsigned char val);
-extern int ec_query_seq(unsigned char cmd);
-extern int ec_query_event_num(void);
-extern int ec_get_event_num(void);
-
-typedef int (*sci_handler) (int status);
-extern sci_handler yeeloong_report_lid_status;
-
-#define SCI_IRQ_NUM 0x0A
-
-/*
- * The following registers are determined by the EC index configuration.
- * 1, fill the PORT_HIGH as EC register high part.
- * 2, fill the PORT_LOW as EC register low part.
- * 3, fill the PORT_DATA as EC register write data or get the data from it.
- */
-#define	EC_IO_PORT_HIGH	0x0381
-#define	EC_IO_PORT_LOW	0x0382
-#define	EC_IO_PORT_DATA	0x0383
-
-/*
- * EC delay time is 500us for register and status access
- */
-#define	EC_REG_DELAY	500	/* unit : us */
-#define	EC_CMD_TIMEOUT	0x1000
-
-/*
- * EC access port for SCI communication
- */
-#define	EC_CMD_PORT		0x66
-#define	EC_STS_PORT		0x66
-#define	EC_DAT_PORT		0x62
-#define	CMD_INIT_IDLE_MODE	0xdd
-#define	CMD_EXIT_IDLE_MODE	0xdf
-#define	CMD_INIT_RESET_MODE	0xd8
-#define	CMD_REBOOT_SYSTEM	0x8c
-#define	CMD_GET_EVENT_NUM	0x84
-#define	CMD_PROGRAM_PIECE	0xda
-
-/* temperature & fan registers */
-#define	REG_TEMPERATURE_VALUE	0xF458
-#define	REG_FAN_AUTO_MAN_SWITCH 0xF459
-#define	BIT_FAN_AUTO		0
-#define	BIT_FAN_MANUAL		1
-#define	REG_FAN_CONTROL		0xF4D2
-#define	BIT_FAN_CONTROL_ON	(1 << 0)
-#define	BIT_FAN_CONTROL_OFF	(0 << 0)
-#define	REG_FAN_STATUS		0xF4DA
-#define	BIT_FAN_STATUS_ON	(1 << 0)
-#define	BIT_FAN_STATUS_OFF	(0 << 0)
-#define	REG_FAN_SPEED_HIGH	0xFE22
-#define	REG_FAN_SPEED_LOW	0xFE23
-#define	REG_FAN_SPEED_LEVEL	0xF4CC
-/* fan speed divider */
-#define	FAN_SPEED_DIVIDER	480000	/* (60*1000*1000/62.5/2)*/
-
-/* battery registers */
-#define	REG_BAT_DESIGN_CAP_HIGH		0xF77D
-#define	REG_BAT_DESIGN_CAP_LOW		0xF77E
-#define	REG_BAT_FULLCHG_CAP_HIGH	0xF780
-#define	REG_BAT_FULLCHG_CAP_LOW		0xF781
-#define	REG_BAT_DESIGN_VOL_HIGH		0xF782
-#define	REG_BAT_DESIGN_VOL_LOW		0xF783
-#define	REG_BAT_CURRENT_HIGH		0xF784
-#define	REG_BAT_CURRENT_LOW		0xF785
-#define	REG_BAT_VOLTAGE_HIGH		0xF786
-#define	REG_BAT_VOLTAGE_LOW		0xF787
-#define	REG_BAT_TEMPERATURE_HIGH	0xF788
-#define	REG_BAT_TEMPERATURE_LOW		0xF789
-#define	REG_BAT_RELATIVE_CAP_HIGH	0xF492
-#define	REG_BAT_RELATIVE_CAP_LOW	0xF493
-#define	REG_BAT_VENDOR			0xF4C4
-#define	FLAG_BAT_VENDOR_SANYO		0x01
-#define	FLAG_BAT_VENDOR_SIMPLO		0x02
-#define	REG_BAT_CELL_COUNT		0xF4C6
-#define	FLAG_BAT_CELL_3S1P		0x03
-#define	FLAG_BAT_CELL_3S2P		0x06
-#define	REG_BAT_CHARGE			0xF4A2
-#define	FLAG_BAT_CHARGE_DISCHARGE	0x01
-#define	FLAG_BAT_CHARGE_CHARGE		0x02
-#define	FLAG_BAT_CHARGE_ACPOWER		0x00
-#define	REG_BAT_STATUS			0xF4B0
-#define	BIT_BAT_STATUS_LOW		(1 << 5)
-#define	BIT_BAT_STATUS_DESTROY		(1 << 2)
-#define	BIT_BAT_STATUS_FULL		(1 << 1)
-#define	BIT_BAT_STATUS_IN		(1 << 0)
-#define	REG_BAT_CHARGE_STATUS		0xF4B1
-#define	BIT_BAT_CHARGE_STATUS_OVERTEMP	(1 << 2)
-#define	BIT_BAT_CHARGE_STATUS_PRECHG	(1 << 1)
-#define	REG_BAT_STATE			0xF482
-#define	BIT_BAT_STATE_CHARGING		(1 << 1)
-#define	BIT_BAT_STATE_DISCHARGING	(1 << 0)
-#define	REG_BAT_POWER			0xF440
-#define	BIT_BAT_POWER_S3		(1 << 2)
-#define	BIT_BAT_POWER_ON		(1 << 1)
-#define	BIT_BAT_POWER_ACIN		(1 << 0)
-
-/* other registers */
-/* Audio: rd/wr */
-#define	REG_AUDIO_VOLUME	0xF46C
-#define	REG_AUDIO_MUTE		0xF4E7
-#define	REG_AUDIO_BEEP		0xF4D0
-/* USB port power or not: rd/wr */
-#define	REG_USB0_FLAG		0xF461
-#define	REG_USB1_FLAG		0xF462
-#define	REG_USB2_FLAG		0xF463
-#define	BIT_USB_FLAG_ON		1
-#define	BIT_USB_FLAG_OFF	0
-/* LID */
-#define	REG_LID_DETECT		0xF4BD
-#define	BIT_LID_DETECT_ON	1
-#define	BIT_LID_DETECT_OFF	0
-/* CRT */
-#define	REG_CRT_DETECT		0xF4AD
-#define	BIT_CRT_DETECT_PLUG	1
-#define	BIT_CRT_DETECT_UNPLUG	0
-/* LCD backlight brightness adjust: 9 levels */
-#define	REG_DISPLAY_BRIGHTNESS	0xF4F5
-/* Black screen Status */
-#define	BIT_DISPLAY_LCD_ON	1
-#define	BIT_DISPLAY_LCD_OFF	0
-/* LCD backlight control: off/restore */
-#define	REG_BACKLIGHT_CTRL	0xF7BD
-#define	BIT_BACKLIGHT_ON	1
-#define	BIT_BACKLIGHT_OFF	0
-/* Reset the machine auto-clear: rd/wr */
-#define	REG_RESET		0xF4EC
-#define	BIT_RESET_ON		1
-/* Light the led: rd/wr */
-#define	REG_LED			0xF4C8
-#define	BIT_LED_RED_POWER	(1 << 0)
-#define	BIT_LED_ORANGE_POWER	(1 << 1)
-#define	BIT_LED_GREEN_CHARGE	(1 << 2)
-#define	BIT_LED_RED_CHARGE	(1 << 3)
-#define	BIT_LED_NUMLOCK		(1 << 4)
-/* Test led mode, all led on/off */
-#define	REG_LED_TEST		0xF4C2
-#define	BIT_LED_TEST_IN		1
-#define	BIT_LED_TEST_OUT	0
-/* Camera on/off */
-#define	REG_CAMERA_STATUS	0xF46A
-#define	BIT_CAMERA_STATUS_ON	1
-#define	BIT_CAMERA_STATUS_OFF	0
-#define	REG_CAMERA_CONTROL	0xF7B7
-#define	BIT_CAMERA_CONTROL_OFF	0
-#define	BIT_CAMERA_CONTROL_ON	1
-/* Wlan Status */
-#define	REG_WLAN		0xF4FA
-#define	BIT_WLAN_ON		1
-#define	BIT_WLAN_OFF		0
-#define	REG_DISPLAY_LCD		0xF79F
-
-/* SCI Event Number from EC */
-enum {
-	EVENT_LID = 0x23,	/*  LID open/close */
-	EVENT_DISPLAY_TOGGLE,	/*  Fn+F3 for display switch */
-	EVENT_SLEEP,		/*  Fn+F1 for entering sleep mode */
-	EVENT_OVERTEMP,		/*  Over-temperature happened */
-	EVENT_CRT_DETECT,	/*  CRT is connected */
-	EVENT_CAMERA,		/*  Camera on/off */
-	EVENT_USB_OC2,		/*  USB2 Over Current occurred */
-	EVENT_USB_OC0,		/*  USB0 Over Current occurred */
-	EVENT_BLACK_SCREEN,	/*  Turn on/off backlight */
-	EVENT_AUDIO_MUTE,	/*  Mute on/off */
-	EVENT_DISPLAY_BRIGHTNESS,/* LCD backlight brightness adjust */
-	EVENT_AC_BAT,		/*  AC & Battery relative issue */
-	EVENT_AUDIO_VOLUME,	/*  Volume adjust */
-	EVENT_WLAN,		/*  Wlan on/off */
-	EVENT_END
-};
-
-#endif /* !_EC_KB3310B_H */
diff --git a/arch/mips/loongson/lemote-2f/platform.c b/arch/mips/loongson/lemote-2f/platform.c
new file mode 100644
index 0000000..0e7b27d
--- /dev/null
+++ b/arch/mips/loongson/lemote-2f/platform.c
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2009 Lemote Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+#include <asm/bootinfo.h>
+
+static struct platform_device yeeloong_pdev = {
+	.name = "yeeloong_laptop",
+	.id = -1,
+};
+
+static int __init lemote2f_platform_init(void)
+{
+	struct platform_device *pdev = NULL;
+
+	switch (mips_machtype) {
+	case MACH_LEMOTE_YL2F89:
+		pdev = &yeeloong_pdev;
+		break;
+	default:
+		break;
+
+	}
+
+	if (pdev != NULL)
+		return platform_device_register(pdev);
+
+	return -ENODEV;
+}
+
+arch_initcall(lemote2f_platform_init);
diff --git a/arch/mips/loongson/lemote-2f/pm.c b/arch/mips/loongson/lemote-2f/pm.c
index d7af2e6..0d5698a 100644
--- a/arch/mips/loongson/lemote-2f/pm.c
+++ b/arch/mips/loongson/lemote-2f/pm.c
@@ -23,7 +23,7 @@
 #include <loongson.h>
 
 #include <cs5536/cs5536_mfgpt.h>
-#include "ec_kb3310b.h"
+#include <ec_kb3310b.h>
 
 #define I8042_KBD_IRQ		1
 #define I8042_CTR_KBDINT	0x01
@@ -100,7 +100,7 @@ int wakeup_loongson(void)
 	if (irq < 0)
 		return 0;
 
-	printk(KERN_INFO "%s: irq = %d\n", __func__, irq);
+	pr_info("%s: irq = %d\n", __func__, irq);
 
 	if (irq == I8042_KBD_IRQ)
 		return 1;
diff --git a/arch/mips/loongson/lemote-2f/reset.c b/arch/mips/loongson/lemote-2f/reset.c
index 51d1a60..4627659 100644
--- a/arch/mips/loongson/lemote-2f/reset.c
+++ b/arch/mips/loongson/lemote-2f/reset.c
@@ -20,7 +20,7 @@
 #include <loongson.h>
 
 #include <cs5536/cs5536.h>
-#include "ec_kb3310b.h"
+#include <ec_kb3310b.h>
 
 static void reset_cpu(void)
 {
diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index 782953a..8bdc97c 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_X86)		+= x86/
+obj-$(CONFIG_MIPS)		+= mips/
diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 2f77693..5ac5215 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -14,5 +14,13 @@ menuconfig MIPS_PLATFORM_DEVICES
 
 if MIPS_PLATFORM_DEVICES
 
+config LEMOTE_YEELOONG2F
+	tristate "Lemote YeeLoong Laptop"
+	depends on LEMOTE_MACH2F
+	help
+	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
+	  compatible to FuLoong2F mini PC, but it has an extra Embedded
+	  Controller(kb3310b) for battery, hotkey, backlight, temperature and
+	  fan management.
 
 endif # MIPS_PLATFORM_DEVICES
diff --git a/drivers/platform/mips/Makefile b/drivers/platform/mips/Makefile
new file mode 100644
index 0000000..506f920
--- /dev/null
+++ b/drivers/platform/mips/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for MIPS Platform-Specific Drivers
+#
+
+obj-$(CONFIG_LEMOTE_YEELOONG2F)	+= yeeloong_laptop.o
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
new file mode 100644
index 0000000..85fc7ed
--- /dev/null
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -0,0 +1,60 @@
+/*
+ * Driver for YeeLoong laptop extras
+ *
+ *  Copyright (C) 2009 Lemote Inc.
+ *  Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+static struct platform_device_id platform_device_ids[] = {
+	{
+		.name = "yeeloong_laptop",
+	},
+	{}
+};
+
+MODULE_DEVICE_TABLE(platform, platform_device_ids);
+
+static struct platform_driver platform_driver = {
+	.driver = {
+		   .name = "yeeloong_laptop",
+		   .owner = THIS_MODULE,
+		   },
+	.id_table = platform_device_ids,
+};
+
+static int __init yeeloong_init(void)
+{
+	int ret;
+
+	pr_info("Load YeeLoong Laptop Platform Specific Driver.\n");
+
+	/* Register platform stuff */
+	ret = platform_driver_register(&platform_driver);
+	if (ret) {
+		pr_err("Fail to register yeeloong platform driver.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit yeeloong_exit(void)
+{
+	platform_driver_unregister(&platform_driver);
+
+	pr_info("Unload YeeLoong Platform Specific Driver.\n");
+}
+
+module_init(yeeloong_init);
+module_exit(yeeloong_exit);
+
+MODULE_AUTHOR("Wu Zhangjin <wuzj@lemote.com>");
+MODULE_DESCRIPTION("YeeLoong laptop driver");
+MODULE_LICENSE("GPL");
-- 
1.6.2.1

