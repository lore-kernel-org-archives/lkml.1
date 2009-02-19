Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbZBSMvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbZBSMvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZBSMuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:50:52 -0500
Received: from ns1.suse.de ([195.135.220.2]:48751 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZBSMut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:50:49 -0500
Message-ID: <499D543B.6050703@suse.de>
Date: Thu, 19 Feb 2009 13:44:43 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com,
       Frank Seidel <fseidel@suse.de>
Subject: [PATCH] hwmon/hdaps: remove redundant sysfs invert
References: <499569A9.5030202@suse.de>	<499807B4.1050606@suse.de>	<4998120C.3030808@suse.de> <20090215153735.25ee8b05@hyperion.delvare>
In-Reply-To: <20090215153735.25ee8b05@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Get rid of sysfs attribute "invert" as its
redundant to module parameter.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/hwmon/hdaps.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -428,28 +428,6 @@ static ssize_t hdaps_calibrate_store(str
 	return count;
 }
 
-static ssize_t hdaps_invert_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%u\n", hdaps_invert);
-}
-
-static ssize_t hdaps_invert_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t count)
-{
-	int invert;
-
-	if (sscanf(buf, "%d", &invert) != 1 ||
-	    invert < 0 || invert > HDAPS_BOTH_AXES)
-		return -EINVAL;
-
-	hdaps_invert = invert;
-	hdaps_calibrate();
-
-	return count;
-}
-
 static DEVICE_ATTR(position, 0444, hdaps_position_show, NULL);
 static DEVICE_ATTR(variance, 0444, hdaps_variance_show, NULL);
 static DEVICE_ATTR(temp1, 0444, hdaps_temp1_show, NULL);
@@ -457,7 +435,6 @@ static DEVICE_ATTR(temp2, 0444, hdaps_te
 static DEVICE_ATTR(keyboard_activity, 0444, hdaps_keyboard_activity_show, NULL);
 static DEVICE_ATTR(mouse_activity, 0444, hdaps_mouse_activity_show, NULL);
 static DEVICE_ATTR(calibrate, 0644, hdaps_calibrate_show,hdaps_calibrate_store);
-static DEVICE_ATTR(invert, 0644, hdaps_invert_show, hdaps_invert_store);
 
 static struct attribute *hdaps_attributes[] = {
 	&dev_attr_position.attr,
@@ -467,7 +444,6 @@ static struct attribute *hdaps_attribute
 	&dev_attr_keyboard_activity.attr,
 	&dev_attr_mouse_activity.attr,
 	&dev_attr_calibrate.attr,
-	&dev_attr_invert.attr,
 	NULL,
 };
 
