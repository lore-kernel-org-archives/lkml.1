Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYEQMMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYEQMMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 08:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYEQMMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 08:12:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbYEQMMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 08:12:37 -0400
Subject: [RFC] make wext wireless bits optional and deprecate them
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 17 May 2008 14:12:17 +0200
Message-Id: <1211026337.3827.25.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /sys/class/net/*/wireless/ direcory is, as far as I know, not
used by anyone. Additionally, the same data is available via wext
ioctls. Hence the sysfs files are pretty much useless. This patch
makes them optional and schedules them for removal.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 net/core/net-sysfs.c                       |    4 ++--
 net/wireless/Kconfig                       |   11 +++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

--- everything.orig/net/core/net-sysfs.c	2008-05-17 13:22:21.000000000 +0200
+++ everything/net/core/net-sysfs.c	2008-05-17 13:23:43.000000000 +0200
@@ -318,7 +318,7 @@ static struct attribute_group netstat_gr
 	.attrs  = netstat_attrs,
 };
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT_SYSFS
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct device *d, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -460,7 +460,7 @@ int netdev_register_kobject(struct net_d
 	if (net->get_stats)
 		*groups++ = &netstat_group;
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT_SYSFS
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
--- everything.orig/net/wireless/Kconfig	2008-05-17 13:22:21.000000000 +0200
+++ everything/net/wireless/Kconfig	2008-05-17 14:09:01.000000000 +0200
@@ -29,3 +29,14 @@ config WIRELESS_EXT
 
 	  Say N (if you can) unless you know you need wireless
 	  extensions for external modules.
+
+config WIRELESS_EXT_SYSFS
+	bool "Wireless extensions sysfs files"
+	default y
+	depends on WIRELESS_EXT && SYSFS
+	help
+	  This option enables the deprecated wireless statistics
+	  files in /sys/class/net/*/wireless/. The same information
+	  is available via the ioctls as well.
+
+	  Say Y if you have programs using it (we don't know of any).
--- everything.orig/Documentation/feature-removal-schedule.txt	2008-05-17 13:22:20.000000000 +0200
+++ everything/Documentation/feature-removal-schedule.txt	2008-05-17 14:08:37.000000000 +0200
@@ -304,3 +304,11 @@ When:	2.6.26
 Why:	Implementation became generic; users should now include
 	linux/semaphore.h instead.
 Who:	Matthew Wilcox <willy@linux.intel.com>
+
+---------------------------
+
+What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
+	(in net/core/net-sysfs.c)
+When:	June 2009
+Why:	Not used by anyone, over 1K .text/.data size reduction.
+Who:	Johannes Berg <johannes@sipsolutions.net>


