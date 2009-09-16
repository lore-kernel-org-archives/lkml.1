Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbZIPM0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbZIPM0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbZIPM0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:26:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59032 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZIPM0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:26:33 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH v2] media: video: pwc: Use kernel's simple_strtol()
Date: Wed, 16 Sep 2009 15:26:29 +0300
Message-Id: <1253103989-25635-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090916120529.GB18050@centrinvest.ru>
References: <20090916120529.GB18050@centrinvest.ru>
X-OriginalArrivalTime: 16 Sep 2009 12:26:29.0586 (UTC) FILETIME=[EAE73320:01CA36C8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Change own implementation of pwc_atoi() by simple_strtol(x, NULL, 10).

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/media/video/pwc/pwc-if.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f976df4..0037a8c 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -68,6 +68,7 @@
 #endif
 #include <linux/vmalloc.h>
 #include <asm/io.h>
+#include <linux/kernel.h>		/* simple_strtol() */
 
 #include "pwc.h"
 #include "pwc-kiara.h"
@@ -1916,19 +1917,6 @@ disconnect_out:
 	unlock_kernel();
 }
 
-/* *grunt* We have to do atoi ourselves :-( */
-static int pwc_atoi(const char *s)
-{
-	int k = 0;
-
-	k = 0;
-	while (*s != '\0' && *s >= '0' && *s <= '9') {
-		k = 10 * k + (*s - '0');
-		s++;
-	}
-	return k;
-}
-
 
 /*
  * Initialization code & module stuff
@@ -2078,13 +2066,13 @@ static int __init usb_pwc_init(void)
 				}
 				else {
 					/* No type or serial number specified, just a number. */
-					device_hint[i].device_node = pwc_atoi(s);
+					device_hint[i].device_node = (int)simple_strtol(s, NULL, 10);
 				}
 			}
 			else {
 				/* There's a colon, so we have at least a type and a device node */
-				device_hint[i].type = pwc_atoi(s);
-				device_hint[i].device_node = pwc_atoi(colon + 1);
+				device_hint[i].type = (int)simple_strtol(s, NULL, 10);
+				device_hint[i].device_node = (int)simple_strtol(colon + 1, NULL, 10);
 				if (*dot != '\0') {
 					/* There's a serial number as well */
 					int k;
-- 
1.5.6.5

