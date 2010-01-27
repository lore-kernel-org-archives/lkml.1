Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771Ab0A0Urs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0A0Urs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489Ab0A0Uqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1538 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab0A0Uqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:34 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 05/13] drivers/block/floppy.c: DPRINT neatening
Date: Wed, 27 Jan 2010 12:46:21 -0800
Message-Id: <d12952d3dce4f13d709e6833334f3d4a6f601438.1264624291.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move DPRINT macro definition above 1st use
Consolidate a format string (>80 columns)
Add a newline to an unterminated message
Comment neatened

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f37193c..8700c6a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -149,8 +149,11 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG		/* debug disk change line */
 
+#define DPRINT(format, args...) \
+	pr_info("floppy%d: " format, current_drive, ##args)
+
+#define DCL_DEBUG		/* debug disk change line */
 #ifdef DCL_DEBUG
 #define debug_dcl(test, fmt, args...) \
 	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##args); } while (0)
@@ -159,7 +162,6 @@
 	do { if (0) DPRINT(fmt, ##args); } while (0)
 #endif
 
-
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
 #include <linux/module.h>
@@ -308,9 +310,6 @@ static bool initialized;
 #define UDRWE	(&write_errors[drive])
 #define UFDCS	(&fdc_state[FDC(drive)])
 
-#define DPRINT(format, args...) \
-	pr_info("floppy%d: " format, current_drive, ##args)
-
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
 
@@ -345,7 +344,7 @@ static bool initialized;
  */
 #define MAX_REPLIES 16
 static unsigned char reply_buffer[MAX_REPLIES];
-static int inr;			/* size of reply buffer, when called from interrupt */
+static int inr;		/* size of reply buffer, when called from interrupt */
 #define ST0		(reply_buffer[0])
 #define ST1		(reply_buffer[1])
 #define ST2		(reply_buffer[2])
@@ -755,8 +754,7 @@ static int disk_change(int drive)
 		if (UDRS->keep_data >= 0) {
 			if ((UDP->flags & FTD_MSG) &&
 			    current_type[drive] != NULL)
-				DPRINT("Disk type is undefined after "
-				       "disk change\n");
+				DPRINT("Disk type is undefined after disk change\n");
 			current_type[drive] = NULL;
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
@@ -1447,7 +1445,7 @@ static int interpret_errors(void)
 	char bad;
 
 	if (inr != 7) {
-		DPRINT("-- FDC reply error");
+		DPRINT("-- FDC reply error\n");
 		FDCS->reset = 1;
 		return 1;
 	}
-- 
1.6.6.rc0.57.gad7a

