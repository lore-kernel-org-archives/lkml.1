Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZH3USh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZH3USh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZH3USg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:18:36 -0400
Received: from xenotime.net ([72.52.64.118]:38347 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754044AbZH3USf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:18:35 -0400
Message-ID: <4A9ADECE.7050900@xenotime.net>
Date: Sun, 30 Aug 2009 13:19:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Mike Miller <mike.miller@hp.com>,
       iss_storagedev@hp.com
Subject: [PATCH] cciss: fix schedule_timeout() parameters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change schedule_timeout() parameter to not be specific to HZ=1000.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
---
 drivers/block/cciss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- lnx-2631-rc7.orig/drivers/block/cciss.c
+++ lnx-2631-rc7/drivers/block/cciss.c
@@ -36,6 +36,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
@@ -3489,7 +3490,7 @@ static int __devinit cciss_pci_init(ctlr
 		if (scratchpad == CCISS_FIRMWARE_READY)
 			break;
 		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);	/* wait 100ms */
+		schedule_timeout(msecs_to_jiffies(100));	/* wait 100ms */
 	}
 	if (scratchpad != CCISS_FIRMWARE_READY) {
 		printk(KERN_WARNING "cciss: Board not ready.  Timed out.\n");
@@ -3615,7 +3616,7 @@ static int __devinit cciss_pci_init(ctlr
 			break;
 		/* delay and try again */
 		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
+		schedule_timeout(msecs_to_jiffies(1));
 	}
 
 #ifdef CCISS_DEBUG
