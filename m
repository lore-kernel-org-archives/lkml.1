Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZGHUIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZGHUIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbZGHUId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:08:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46649 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbZGHUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dMIHJrN1cEt8vIcQlRHOVOhXhOEaCDYpTJ/3rBhZIgp9OgW0jx2pV9EvhimbRgK+Nj
         NUtfHB4nfG8ZYUhMGGMExgRCsxsIQW8TlDljP46RrYswyLneYG6m8+85JbM7qvs3MhEt
         LV2ZQEL5dyrIF6877LCxsNClG1XISj6Qe1tls=
Message-ID: <4A54FC7E.1020902@gmail.com>
Date: Wed, 08 Jul 2009 22:07:26 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] staging/rt*: don't confuse user of rt3070 driver with
 rt2870 strings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 3/3] staging/rt*: don't confuse user of rt3070 driver with rt2870 strings

Original author didn't bother to change strings for rt3070 driver. Fix it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Next steps could be:
- removal of loading configuration from kernel
- removal of driver "versions"

Bart, are you preparing some patches for these drivers?
---
 drivers/staging/rt2860/rt_linux.h      |   33 ++++++++++++++++---------------
 drivers/staging/rt2860/sta_ioctl.c     |    7 +-----
 drivers/staging/rt2870/2870_main_dev.c |    4 +-
 drivers/staging/rt2870/rt2870.h        |    4 +++
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 85175c1..a4cf3f8 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -93,22 +93,23 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 
 // add by kathy
 
-#ifdef RT2860
-#define STA_PROFILE_PATH			"/etc/Wireless/RT2860STA/RT2860STA.dat"
-#define STA_RTMP_FIRMWARE_FILE_NAME "/etc/Wireless/RT2860STA/RT2860STA.bin"
-#define STA_NIC_DEVICE_NAME			"RT2860STA"
-#define STA_DRIVER_VERSION			"1.8.1.1"
-#endif
-#ifdef RT2870
-#define STA_PROFILE_PATH			"/etc/Wireless/RT2870STA/RT2870STA.dat"
-#define STA_RT2870_IMAGE_FILE_NAME  "/etc/Wireless/RT2870STA/rt2870.bin"
-#define STA_NIC_DEVICE_NAME			"RT2870STA"
-#ifndef RT30xx
-#define STA_DRIVER_VERSION			"1.4.0.0"
-#endif
-#ifdef RT30xx
-#define STA_DRIVER_VERSION			"2.0.1.0"
-#endif
+/* order of "if defined()" is important, because for 3070 driver
+   both RT2870 and RT3070 are defined */
+#if defined(RT2860)
+ #define STA_PROFILE_PATH			"/etc/Wireless/RT2860STA/RT2860STA.dat"
+ #define STA_RTMP_FIRMWARE_FILE_NAME "/etc/Wireless/RT2860STA/RT2860STA.bin"
+ #define STA_NIC_DEVICE_NAME			"RT2860STA"
+ #define STA_DRIVER_VERSION			"1.8.1.1"
+#elif defined(RT3070)
+ #define STA_PROFILE_PATH			"/etc/Wireless/RT3070STA/RT3070STA.dat"
+ #define STA_RT2870_IMAGE_FILE_NAME  "/etc/Wireless/RT3070STA/rt2870.bin"
+ #define STA_NIC_DEVICE_NAME			"RT3070STA"
+ #define STA_DRIVER_VERSION			"2.0.1.0"
+#elif defined(RT2870)
+ #define STA_PROFILE_PATH			"/etc/Wireless/RT2870STA/RT2870STA.dat"
+ #define STA_RT2870_IMAGE_FILE_NAME  "/etc/Wireless/RT2870STA/rt2870.bin"
+ #define STA_NIC_DEVICE_NAME			"RT2870STA"
+ #define STA_DRIVER_VERSION			"1.4.0.0"
 #endif
 
 #ifdef RT2860
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index eb0109a..a4f22df 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -531,12 +531,7 @@ rt_ioctl_giwname(struct net_device *dev,
 		   char *name, char *extra)
 {
 //	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#ifdef RT2860
-    strncpy(name, "RT2860 Wireless", IFNAMSIZ);
-#endif
-#ifdef RT2870
-	strncpy(name, "RT2870 Wireless", IFNAMSIZ);
-#endif // RT2870 //
+	strncpy(name, RT28xx_CHIP_NAME " Wireless", IFNAMSIZ);
 	return 0;
 }
 
diff --git a/drivers/staging/rt2870/2870_main_dev.c b/drivers/staging/rt2870/2870_main_dev.c
index dd01c64..154b853 100644
--- a/drivers/staging/rt2870/2870_main_dev.c
+++ b/drivers/staging/rt2870/2870_main_dev.c
@@ -45,7 +45,7 @@
 // *** If you have a solution for the bug in current version of driver, please mail to me.
 // Otherwise post to forum in ralinktech's web site(www.ralinktech.com) and let all users help you. ***
 MODULE_AUTHOR("Paul Lin <paul_lin@ralinktech.com>");
-MODULE_DESCRIPTION("RT2870 Wireless Lan Linux Driver");
+MODULE_DESCRIPTION(RT28xx_CHIP_NAME " Wireless LAN Linux Driver");
 MODULE_LICENSE("GPL");
 #ifdef MODULE_VERSION
 MODULE_VERSION(STA_DRIVER_VERSION);
@@ -1418,7 +1418,7 @@ VOID RT2870_BssBeaconStart(
 		pAd->CommonCfg.BeaconAdjust = 0;
 		pAd->CommonCfg.BeaconFactor = 0xffffffff / (pAd->CommonCfg.BeaconPeriod << 10);
 		pAd->CommonCfg.BeaconRemain = (0xffffffff % (pAd->CommonCfg.BeaconPeriod << 10)) + 1;
-		printk("RT2870_BssBeaconStart:BeaconFactor=%d, BeaconRemain=%d!\n", pAd->CommonCfg.BeaconFactor, pAd->CommonCfg.BeaconRemain);
+		printk(RT28xx_CHIP_NAME "_BssBeaconStart:BeaconFactor=%d, BeaconRemain=%d!\n", pAd->CommonCfg.BeaconFactor, pAd->CommonCfg.BeaconRemain);
 		RTMPSetTimer(&pAd->CommonCfg.BeaconUpdateTimer, pAd->CommonCfg.BeaconPeriod);
 
 	}
diff --git a/drivers/staging/rt2870/rt2870.h b/drivers/staging/rt2870/rt2870.h
index 9679ccb..259a237 100644
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -523,7 +523,11 @@ extern UCHAR EpToQueue[6];
 	{	RTUSB_SET_BULK_FLAG(pAd, fRTUSB_BULK_OUT_PSPOLL);	\
 		RTUSBKickBulkOut(pAd); }
 
+#ifdef RT30xx
+#define RT28xx_CHIP_NAME            "RT3070"
+#else
 #define RT28xx_CHIP_NAME            "RT2870"
+#endif
 #define USB_CYC_CFG                 0x02a4
 #ifndef RT30xx
 #define STATUS_SUCCESS				0x00
-- 
1.6.3.3

