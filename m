Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbYAYHYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbYAYHYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbYAYHPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:47502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbYAYHPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Emil Medve <Emilian.Medve@Freescale.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 030/196] driver core: Make the dev_*() family of macros in device.h complete
Date: Thu, 24 Jan 2008 23:09:28 -0800
Message-Id: <1201245134-4876-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Medve <Emilian.Medve@Freescale.com>

Removed duplicates defined elsewhere

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/i2c/chips/isp1301_omap.c |    6 ------
 drivers/isdn/gigaset/gigaset.h   |    6 ------
 include/linux/device.h           |   24 +++++++++++++++---------
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index b767603..ebfbb29 100644
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
index cf4ae5c..dbbbe89 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -565,6 +565,21 @@ extern const char *dev_driver_string(struct device *dev);
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
@@ -586,15 +601,6 @@ dev_vdbg(struct device * dev, const char * fmt, ...)
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
1.5.3.8

