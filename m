Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYFXRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYFXRiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYFXRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:38:16 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:54737 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYFXRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:38:15 -0400
Message-ID: <48613130.7090004@keyaccess.nl>
Date: Tue, 24 Jun 2008 19:38:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
CC: Zhang Rui <rui.zhang@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       Jean Delvare <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors
 2 userspace
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no> <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca> <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org> <1214279258.3001.76.camel@rzhang-dt.sh.intel.com> <20080624121455.GM7306@mars.solarsys.private>
In-Reply-To: <20080624121455.GM7306@mars.solarsys.private>
Content-Type: multipart/mixed;
 boundary="------------030105050804060908000406"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030105050804060908000406
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 24-06-08 14:14, Mark M. Hoffman wrote:

> * Zhang Rui <rui.zhang@intel.com> [2008-06-24 11:47:38 +0800]:
> 
> (snip)
> 
>> Following is a possible solution which is also from Rene,
>> while I think CONFIG_THERMAL_HWMON should be "default n".
> 
> I agree that it should default off.  With that change...
> 
> Acked-by: Mark M. Hoffman <mhoffman@lightlink.com>

Len suggested the default be hwmon support enabled; I'm okay either way. 
Here it is again with only the 'default y' dropped (and such noted in 
the changelog).

Before it slips from the thread -- this again while noting that with a 
fixed libsensors 2 on the way just not fixing it is an option.

Rene

--------------030105050804060908000406
Content-Type: text/plain;
 name="0001-acpi-thermal-allow-disabling-of-thermal-zone-hwmon.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-acpi-thermal-allow-disabling-of-thermal-zone-hwmon.patc";
 filename*1="h"

>From 85b13a5ad5b6561f9ca7c2dd6889f0d1bf0af2f4 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Mon, 23 Jun 2008 21:50:25 +0200
Subject: [PATCH] acpi/thermal: allow disabling of thermal zone hwmon support

2.6.26-rc gained a hwmon interface to the Thermal Zone driver
which unfortunately breaks lm-sensors 2 userspace and renders
all other (subsequent) hwmon sensors inoperable also.

Many systems, current slackware and derivative systems among
them, are using lm-sensors 2 and would be affected. A new
lm-sensors 2.10.7 release is needed to fix this from the user
side.

This makes the hwmon support optional, disabled by default and
comments that it needs a new enough lm-sensors userspace. This
also immediately schedules the option for removal again as this
is only intended to not break systems over the 2.6.26 upgrade
when new enough lm-sensors is not yet available or widely
deployed.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Mark M. Hoffman <mhoffman@lightlink.com>
CC: Len Brown <lenb@kernel.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Zhang Rui <rui.zhang@intel.com>
CC: Jean Delvare <khali@linux-fr.org>
CC: linux-acpi@vger.kernel.org
CC: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/thermal/Kconfig                    |    9 +++++++++
 drivers/thermal/thermal_sys.c              |    4 ++--
 include/linux/thermal.h                    |    6 ++----
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5b3f31f..46ece3f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -312,3 +312,12 @@ When:	2.6.26
 Why:	Implementation became generic; users should now include
 	linux/semaphore.h instead.
 Who:	Matthew Wilcox <willy@linux.intel.com>
+
+---------------------------
+
+What:	CONFIG_THERMAL_HWMON
+When:	January 2009
+Why:	This option was introduced just to allow older lm-sensors userspace
+	to keep working over the upgrade to 2.6.26. At the scheduled time of
+	removal fixed lm-sensors (2.x or 3.x) should be readily available.
+Who:	Rene Herman <rene.herman@gmail.com>
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 4b62852..6787354 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -12,3 +12,12 @@ menuconfig THERMAL
 	  cooling devices.
 	  All platforms with ACPI thermal support can use this driver.
 	  If you want this support, you should say Y or M here.
+
+config THERMAL_HWMON
+	bool "Hardware monitoring support"
+	depends on HWMON=y || HWMON=THERMAL
+	help
+	  The generic thermal sysfs driver's hardware monitoring support
+	  requires a 2.10.7/3.0.2 or later lm-sensors userspace.
+
+	  Say Y unless you need support for older lm-sensors.
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6098787..fe07462 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -295,8 +295,8 @@ thermal_cooling_device_trip_point_show(struct device *dev,
 
 /* Device management */
 
-#if defined(CONFIG_HWMON) ||	\
-	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
+#if defined(CONFIG_THERMAL_HWMON)
+
 /* hwmon sys I/F */
 #include <linux/hwmon.h>
 static LIST_HEAD(thermal_hwmon_list);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 06d3e6e..917707e 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -66,8 +66,7 @@ struct thermal_cooling_device {
 				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
-#if defined(CONFIG_HWMON) ||	\
-	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
+#if defined(CONFIG_THERMAL_HWMON)
 /* thermal zone devices with the same type share one hwmon device */
 struct thermal_hwmon_device {
 	char type[THERMAL_NAME_LENGTH];
@@ -94,8 +93,7 @@ struct thermal_zone_device {
 	struct idr idr;
 	struct mutex lock;	/* protect cooling devices list */
 	struct list_head node;
-#if defined(CONFIG_HWMON) ||	\
-	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
+#if defined(CONFIG_THERMAL_HWMON)
 	struct list_head hwmon_node;
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
-- 
1.5.5


--------------030105050804060908000406--
