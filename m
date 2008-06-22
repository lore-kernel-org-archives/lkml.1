Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYFVV6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYFVV6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYFVV6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:58:22 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35675 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYFVV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:58:21 -0400
Message-ID: <485ECB23.4010305@keyaccess.nl>
Date: Sun, 22 Jun 2008 23:58:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc, enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl>	<485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl> <485E6F12.4010307@keyaccess.nl> <485E94ED.10602@hhs.nl> <485E992B.8010101@keyaccess.nl>
In-Reply-To: <485E992B.8010101@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------070303080305060107030109"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070303080305060107030109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 22-06-08 20:25, Rene Herman wrote:

> Another way to solve it _could_ be to just make up a device link if 
> something generic is available so that sensors doesn't trip over it
> in the first place but I don't know if that's a good option. You
> might.

This also works for me and, if correct, is ofcourse better than the 
CONFIG option. Wants a comment from the thermal_zone side (for which 
Zhang Rui seems the correct CC?) though.

Rene

--------------070303080305060107030109
Content-Type: text/plain;
 name="0001-thermal-link-the-virtual-thermal-thermal_zoneN-devi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-thermal-link-the-virtual-thermal-thermal_zoneN-devi.pat";
 filename*1="ch"

>From b51a5f4105f6b5ff52a2819a96dabe2ca3116128 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sun, 22 Jun 2008 23:45:04 +0200
Subject: [PATCH] thermal: link the virtual/thermal/thermal_zoneN device for hwmon

2.6.26-rc gained a hwmon interface to the ACPI Thermal Zone
driver which unfortunately breaks lm-sensors 2 userspace and
renders all other (subsequent) hwmon sensors inoperable also.

Many systems, current slackware systems among them, are still
using lm-sensors 2 and would be affected.

The problem is userspace tripping over an absent "device"
link in the ACPI Thermal Zone sysfs /sys/class/hwmon/hwmonN
directory. This just adds the virtual "thermal/thermal_zoneN"
device as a device backlink which satisfies lm-sensors again.

Tested and looks fairly obvious, but this wants comment from
a thermal_zone person, to confirm/deny that this is a proper
device pointer to use here for one.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Zhang Rui <rui.zhang@intel.com>
CC: Mark M. Hoffman <mhoffman@lightlink.com>
CC: Jean Delvare <khali@linux-fr.org>
CC: linux-acpi@vger.kernel.org
CC: lm-sensors@lm-sensors.org
CC; linux-kernel@vger.kernal.org
---
 drivers/thermal/thermal_sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6098787..c21e03c 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -357,7 +357,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 
 	INIT_LIST_HEAD(&hwmon->tz_list);
 	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
-	hwmon->device = hwmon_device_register(NULL);
+	hwmon->device = hwmon_device_register(&tz->device);
 	if (IS_ERR(hwmon->device)) {
 		result = PTR_ERR(hwmon->device);
 		goto free_mem;
-- 
1.5.5


--------------070303080305060107030109--
