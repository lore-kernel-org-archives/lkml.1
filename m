Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbXJ3Tvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbXJ3Tvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbXJ3Tvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:51:32 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57081 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbXJ3Tvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:51:31 -0400
From: Emil Medve <Emilian.Medve@Freescale.com>
To: mochel@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       hjlipp@web.de, tilman@imap.cc, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de, mac@melware.de,
       linux-omap-open-source@linux.omap.com
Cc: Emil Medve <Emilian.Medve@Freescale.com>
Subject: [PATCH v2] Make the dev_*() family of macros in device.h complete
Date: Tue, 30 Oct 2007 14:37:14 -0500
Message-Id: <1193773034-4588-1-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: git-send-email 1.5.3.GIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicates defined elsewhere

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
---

The macros are defined in the relative order KERN_* are defined in kernel.h

linux-2.6> scripts/checkpatch.pl 0001-Make-the-dev_-family-of-macros-in-device.h-comple.patch 
Your patch has no obvious style problems and is ready for submission.

 drivers/i2c/chips/isp1301_omap.c |    6 ------
 drivers/isdn/gigaset/gigaset.h   |    6 ------
 include/linux/device.h           |   24 +++++++++++++++---------
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index fe04e46..35b9909 100644
--- a/drivers/i2c/chips/isp1301_omap.c
+++ b/drivers/i2c/chips/isp1301_omap.c
@@ -259,12 +259,6 @@ static inline const char *state_name(struct isp1301 *isp)
 	return state_string(isp->otg.state);
 }
 
-#ifdef	VERBOSE
-#define	dev_vdbg			dev_dbg
-#else
-#define	dev_vdbg(dev, fmt, arg...)	do{}while(0)
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 /* NOTE:  some of this ISP1301 setup is specific to H2 boards;
diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/gigaset.h
index a0317ab..02bdaf2 100644
--- a/drivers/isdn/gigaset/gigaset.h
+++ b/drivers/isdn/gigaset/gigaset.h
@@ -106,12 +106,6 @@ enum debuglevel {
 					 activated */
 };
 
-/* missing from linux/device.h ... */
-#ifndef dev_notice
-#define dev_notice(dev, format, arg...)		\
-	dev_printk(KERN_NOTICE , dev , format , ## arg)
-#endif
-
 /* Kernel message macros for situations where dev_printk and friends cannot be
  * used for lack of reliable access to a device structure.
  * linux/usb.h already contains these but in an obsolete form which clutters
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..99a6b7f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -557,6 +557,21 @@ extern const char *dev_driver_string(struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , (dev)->bus_id , ## arg)
 
+#define dev_emerg(dev, format, arg...)		\
+	dev_printk(KERN_EMERG , dev , format , ## arg)
+#define dev_alert(dev, format, arg...)		\
+	dev_printk(KERN_ALERT , dev , format , ## arg)
+#define dev_crit(dev, format, arg...)		\
+	dev_printk(KERN_CRIT , dev , format , ## arg)
+#define dev_err(dev, format, arg...)		\
+	dev_printk(KERN_ERR , dev , format , ## arg)
+#define dev_warn(dev, format, arg...)		\
+	dev_printk(KERN_WARNING , dev , format , ## arg)
+#define dev_notice(dev, format, arg...)		\
+	dev_printk(KERN_NOTICE , dev , format , ## arg)
+#define dev_info(dev, format, arg...)		\
+	dev_printk(KERN_INFO , dev , format , ## arg)
+
 #ifdef DEBUG
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
@@ -578,15 +593,6 @@ dev_vdbg(struct device * dev, const char * fmt, ...)
 }
 #endif
 
-#define dev_err(dev, format, arg...)		\
-	dev_printk(KERN_ERR , dev , format , ## arg)
-#define dev_info(dev, format, arg...)		\
-	dev_printk(KERN_INFO , dev , format , ## arg)
-#define dev_warn(dev, format, arg...)		\
-	dev_printk(KERN_WARNING , dev , format , ## arg)
-#define dev_notice(dev, format, arg...)		\
-	dev_printk(KERN_NOTICE , dev , format , ## arg)
-
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
1.5.3.GIT

