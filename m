Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbZEOMYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbZEOMYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZEOMW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:22:57 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:42340 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbZEOMWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:22:54 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KJOQDP-02-5L9-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/22] edac: fold __func__ into edac_debug_printk
Date: Fri, 15 May 2009 14:22:13 +0200
Message-ID: <1242390153-24493-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:39.0649 (UTC) FILETIME=[D6A09910:01C9D557]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shortens debugfX() calls a bit.

CC: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_core.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 6ad95c8..48d3b14 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -76,10 +76,11 @@
 extern int edac_debug_level;
 
 #ifndef CONFIG_EDAC_DEBUG_VERBOSE
-#define edac_debug_printk(level, fmt, arg...)                            \
-	do {                                                             \
-		if (level <= edac_debug_level)                           \
-			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
+#define edac_debug_printk(level, fmt, arg...)                           \
+	do {                                                            \
+		if (level <= edac_debug_level)                          \
+			edac_printk(KERN_DEBUG, EDAC_DEBUG,		\
+				    "%s: " fmt, __func__, ##arg);	\
 	} while (0)
 #else  /* CONFIG_EDAC_DEBUG_VERBOSE */
 #define edac_debug_printk(level, fmt, arg...)                            \
-- 
1.6.2.4


