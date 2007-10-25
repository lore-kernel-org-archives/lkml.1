Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbXJYUTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbXJYUTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXJYUTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:19:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbXJYUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:19:39 -0400
Date: Thu, 25 Oct 2007 13:19:06 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dtor@insightbb.com, pavel@ucw.cz, lenb@kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] apanel: space savings.
Message-ID: <20071025131906.36847ed7@shemminger-laptop>
In-Reply-To: <20071024160300.85e1cbda.akpm@linux-foundation.org>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	<200709140130.59732.dtor@insightbb.com>
	<20070916215516.2934abad@oldman.hemminger.net>
	<200709161623.00286.dtor@insightbb.com>
	<20071023125555.38d63567@shemminger-laptop>
	<20071024160300.85e1cbda.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the device_names they are only used for debug
messages. Add paren's for one expression.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/input/misc/apanel.c	2007-10-25 09:20:23.000000000 -0700
+++ b/drivers/input/misc/apanel.c	2007-10-25 12:07:00.000000000 -0700
@@ -27,7 +27,7 @@
 #include <linux/leds.h>
 
 #define APANEL_NAME	"Fujitsu Application Panel"
-#define APANEL_VERSION	"1.3"
+#define APANEL_VERSION	"1.3.1"
 #define APANEL		"apanel"
 
 /* How often we poll keys - msecs */
@@ -40,6 +40,7 @@ enum apanel_devid {
 	APANEL_DEV_CDBTN  = 2,
 	APANEL_DEV_LCD	  = 3,
 	APANEL_DEV_LED	  = 4,
+
 	APANEL_DEV_MAX,
 };
 
@@ -53,14 +54,6 @@ enum apanel_chip {
 /* Result of BIOS snooping/probing -- what features are supported */
 static enum apanel_chip device_chip[APANEL_DEV_MAX];
 
-/* names for APANEL_XXX */
-static const char *device_names[APANEL_DEV_MAX] __initdata = {
-	[APANEL_DEV_APPBTN] = "Application Buttons",
-	[APANEL_DEV_LCD]    = "LCD",
-	[APANEL_DEV_LED]    = "LED",
-	[APANEL_DEV_CDBTN]  = "CD Buttons",
-};
-
 #define MAX_PANEL_KEYS	12
 
 struct apanel {
@@ -123,7 +116,7 @@ static void apanel_poll(struct input_pol
 
 	dev_dbg(&ipdev->input->dev, APANEL ": data %#x\n", data);
 	for (i = 0; i < ipdev->input->keycodemax; i++)
-		if (1ul << i & data)
+		if ((1u << i) & data)
 			report_key(idev, ap->keymap[i]);
 }
 
@@ -366,17 +359,14 @@ static int __init apanel_init(void)
 		}
 
 		if (devno >= APANEL_DEV_MAX)
-			pr_notice(APANEL ": unknown device %d found\n", devno);
+			pr_notice(APANEL ": unknown device %u found\n", devno);
 		else if (device_chip[devno] != CHIP_NONE)
-			pr_warning(APANEL ": duplicate entry for %s\n",
-				   device_names[devno]);
+			pr_warning(APANEL ": duplicate entry for devno %u\n", devno);
 
 		else if (method != 1 && method != 2 && method != 4) {
-			pr_notice(APANEL ": unknown  method %u for %s\n",
-				  method, device_names[devno]);
+			pr_notice(APANEL ": unknown method %u for devno %u\n",
+				  method, devno);
 		} else {
-			pr_debug(APANEL ": %s found.\n", device_names[devno]);
-
 			device_chip[devno] = (enum apanel_chip) chip;
 			++found;
 		}
