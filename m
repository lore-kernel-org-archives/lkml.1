Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYADKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYADKSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYADKSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:18:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:3435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYADKSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:18:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,244,1196668800"; 
   d="scan'208";a="314224691"
Subject: [linux-pm][PATCH] base: Change power/wakeup output from "" to
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: pavel@ucw.cz, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel
Date: Fri, 04 Jan 2008 18:10:14 +0800
Message-Id: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a device can't support wakeup, its /sys/devices/.../power/wakeup output is
empty, this is confusing, a user doesn't know if it supports wakeup feature
unless he/she read the ralated source code, for this case, it is more
reasonable to output "unsupported". Otherwise, no matter what value the user
sets to /sys/devices/.../power/wakeup, the result is the same:  Invalid argument,
so the user doesn't know why.

This patch changes empty output to "unsupported" in order that a user knows
wakeup feature isn't supported by this device when he/she
'cat /sys/devices/.../power/wakeup', please consider to apply, thanks.

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/sysfs.c	2008-01-04 16:50:54.000000000 +0800
+++ b/drivers/base/power/sysfs.c	2008-01-04 17:14:42.000000000 +0800
@@ -49,7 +49,7 @@ wake_show(struct device * dev, struct de
 {
 	return sprintf(buf, "%s\n", device_can_wakeup(dev)
 		? (device_may_wakeup(dev) ? enabled : disabled)
-		: "");
+		: "unsupported");
 }
 
 static ssize_t


