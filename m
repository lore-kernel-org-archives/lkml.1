Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbYFWUYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbYFWUYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbYFWUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:24:15 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:45208 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYFWUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:24:14 -0400
Message-ID: <48600697.4080800@keyaccess.nl>
Date: Mon, 23 Jun 2008 22:24:55 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Zhang Rui <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc, enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl> <485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl> <485E6F12.4010307@keyaccess.nl> <alpine.LFD.1.10.0806231333030.2984@localhost.localdomain> <4860028E.5000304@keyaccess.nl>
In-Reply-To: <4860028E.5000304@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------060609020005030406050203"
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060609020005030406050203
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 23-06-08 22:07, Rene Herman wrote:

> On 23-06-08 19:54, Len Brown wrote:
> 
>> Rene,
>> Thank you for reporting this.
>>
>> I agree that this failure is an unwelcome surprise to those users
>> who upgrade to 2.6.26 but are still using libsensors <= 2.10.6.
>>
>> Jean, Mark, Hans,
>>
>> I'm actually fine with adding a temporary kernel config option
>> along the lines Rene suggested to ease the  migration
>> to linux-2.6.26 for those users.
>>
>> But the config option would need to be scheduled for removal
>> after a certain period (say 6 months) so we don't have to maintain
>> it forever.
>>
>> More importantly, I think it would also have to be disabled by default
>> so that it would not have a negative impact on what we think are the
>> majority of properly configured systems.  After all, we fixed this
>> bug in user-space about out 4 months ago and as you point out, the
>> distro upgrade path is actually quite well looked after.
>>
>> So I'm not sure how useful it would be to the target users.
>> After they run into the problem, they'd probably google it
>> and find that they can either tweak a kernel config option
>> or upgrade libsensors.  And we'd prefer that they do the
>> later rather than the former, yes?
>>
>> just let me know.
> 
> Thank you for the reason. Yes, people upgrading libsensors would be 
> preferred and this issue should show up in google now.
> 
> Frankly, if I had gone to the lm-sensors homepage and had seen a fixed 
> 2.x version available I'd no doubt have shrugged it off then and there 
> so I might as well do so now that Delvare announced that it's _going_ to 
> be there real soon. 2.10.7 should be painless enough as an upgrade, it's 
> needing lm-sensors 3.0(.2) and all its listed accompanying patches to 
> programs depending on libsensors which triggered this thread.
> 
> So, <shrug>. I know how to fix my own systems, others will be able to 
> find out and once lm-sensors 2.10.7 is available, it's not a big deal 
> anymore.
> 
> That said, here's the "make it optional" patch tweaked according to your 
> comments. Feel free to drop it on the floor...

Typo(s) in the feature-removal-schedule (only change).

Rene.

--------------060609020005030406050203
Content-Type: text/plain;
 name="0001-acpi-thermal-allow-disabling-of-thermal-zone-hwmon.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-acpi-thermal-allow-disabling-of-thermal-zone-hwmon.patc";
 filename*1="h"

>From 7b41d17346cdd1f9db1223c024bd9f4604ee5c82 Mon Sep 17 00:00:00 2001
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

This makes the hwmon support optional (enabled by default) and
comments that it needs a new enough lm-sensors userspace. This
also immediately schedules the option for removal again as this
is only intended to not break systems over the 2.6.26 upgrade
when new enough lm-sensors is not yet available or widely
deployed.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
CC: Len Brown <lenb@kernel.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Zhang Rui <rui.zhang@intel.com>
CC: Mark M. Hoffman <mhoffman@lightlink.com>
CC: Jean Delvare <khali@linux-fr.org>
CC: linux-acpi@vger.kernel.org
CC: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/thermal/Kconfig                    |   10 ++++++++++
 drivers/thermal/thermal_sys.c              |    4 ++--
 include/linux/thermal.h                    |    6 ++----
 4 files changed, 23 insertions(+), 6 deletions(-)

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
index 4b62852..0b359ab 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -12,3 +12,13 @@ menuconfig THERMAL
 	  cooling devices.
 	  All platforms with ACPI thermal support can use this driver.
 	  If you want this support, you should say Y or M here.
+
+config THERMAL_HWMON
+	bool "Hardware monitoring support"
+	depends on HWMON=y || HWMON=THERMAL
+	default y
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


--------------060609020005030406050203--
