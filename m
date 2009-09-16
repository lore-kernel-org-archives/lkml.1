Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbZIPNxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbZIPNxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZIPNxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:53:23 -0400
Received: from smtp.nokia.com ([192.100.122.230]:26553 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbZIPNxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:53:22 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: penberg@cs.helsinki.fi, Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH v3] media: video: pwc: Use kernel's simple_strtol()
Date: Wed, 16 Sep 2009 16:53:15 +0300
Message-Id: <1253109195-25915-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <84144f020909160543s38daa8ebs989b9da09802d681@mail.gmail.com>
References: <84144f020909160543s38daa8ebs989b9da09802d681@mail.gmail.com>
X-OriginalArrivalTime: 16 Sep 2009 13:53:18.0827 (UTC) FILETIME=[0BDA4BB0:01CA36D5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Change own implementation of pwc_atoi() by simple_strtol(x, NULL, 10).

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/media/video/pwc/pwc-if.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f976df4..89b620f 100644
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
@@ -2078,13 +2066,16 @@ static int __init usb_pwc_init(void)
 				}
 				else {
 					/* No type or serial number specified, just a number. */
-					device_hint[i].device_node = pwc_atoi(s);
+					device_hint[i].device_node =
+						simple_strtol(s, NULL, 10);
 				}
 			}
 			else {
 				/* There's a colon, so we have at least a type and a device node */
-				device_hint[i].type = pwc_atoi(s);
-				device_hint[i].device_node = pwc_atoi(colon + 1);
+				device_hint[i].type =
+					simple_strtol(s, NULL, 10);
+				device_hint[i].device_node =
+					simple_strtol(colon + 1, NULL, 10);
 				if (*dot != '\0') {
 					/* There's a serial number as well */
 					int k;
-- 
1.5.6.5

