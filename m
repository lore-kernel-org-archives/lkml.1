Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZIPLn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZIPLn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZIPLn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:43:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:35778 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbZIPLn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:43:27 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH] media: video: pwc: Use kernel's simple_strtol()
Date: Wed, 16 Sep 2009 14:42:27 +0300
Message-Id: <1253101347-25038-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 16 Sep 2009 11:42:29.0935 (UTC) FILETIME=[C58C6BF0:01CA36C2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Change own implementation of atoi() by simple_strtol(x, NULL, 10).

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/media/video/pwc/pwc-if.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f976df4..cb995c6 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -68,6 +68,7 @@
 #endif
 #include <linux/vmalloc.h>
 #include <asm/io.h>
+#include <linux/kernel.h>		/* simple_strtol() */
 
 #include "pwc.h"
 #include "pwc-kiara.h"
@@ -1916,17 +1917,9 @@ disconnect_out:
 	unlock_kernel();
 }
 
-/* *grunt* We have to do atoi ourselves :-( */
-static int pwc_atoi(const char *s)
+static inline int pwc_atoi(const char *s)
 {
-	int k = 0;
-
-	k = 0;
-	while (*s != '\0' && *s >= '0' && *s <= '9') {
-		k = 10 * k + (*s - '0');
-		s++;
-	}
-	return k;
+	return (int)simple_strtol(s, NULL, 10);
 }
 
 
-- 
1.5.6.5

