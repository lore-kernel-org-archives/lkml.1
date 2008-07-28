Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYG1R6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYG1R6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbYG1R4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:56:07 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:8293 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbYG1R4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:56:04 -0400
Message-Id: <20080728175514.420074563@de.ibm.com>
References: <20080728175355.734299984@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Jul 2008 19:54:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Melissa Howland <melissah@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 15/15] kmsg: convert monwriter printk messages to kmsg api.
Content-Disposition: inline; filename=815-kmsg-monwriter.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melissa Howland <melissah@us.ibm.com>

Signed-off-by: Melissa Howland <melissah@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 Documentation/s390/kmsg/monwriter |   17 +++++++++++++++++
 drivers/s390/char/monwriter.c     |    4 +++-
 2 files changed, 20 insertions(+), 1 deletion(-)

Index: quilt-2.6/Documentation/s390/kmsg/monwriter
===================================================================
--- /dev/null
+++ quilt-2.6/Documentation/s390/kmsg/monwriter
@@ -0,0 +1,17 @@
+/*?
+ * Tag: monwriter.1
+ * Text: "Writing monitor data failed with rc=%i"
+ * Severity: Error
+ * Parameter:
+ *   @1: return code
+ * Description:
+ * The monitor stream application device driver used the z/VM diagnose call
+ * DIAG X'DC' to start writing monitor data. z/VM returned an error and the
+ * monitor data cannot be written. If the return code is 5, your z/VM guest
+ * virtual machine is not authorized to write monitor data.
+ * User action:
+ * If the return code is 5, ensure that your z/VM guest virtual machine's
+ * entry in the z/VM directory includes the OPTION APPLMON statement.
+ * For other return codes see the section about DIAGNOSE Code X'DC'
+ * in "z/VM CP Programming Services".
+ */
Index: quilt-2.6/drivers/s390/char/monwriter.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/monwriter.c
+++ quilt-2.6/drivers/s390/char/monwriter.c
@@ -24,7 +24,9 @@
 #include <asm/io.h>
 #include <asm/appldata.h>
 #include <asm/monwriter.h>
+#include <asm/kmsg.h>
 
+#define KMSG_COMPONENT "monwriter"
 #define MONWRITE_MAX_DATALEN	4010
 
 static int mon_max_bufs = 255;
@@ -66,7 +68,7 @@ static int monwrite_diag(struct monwrite
 		return rc;
 	if (rc == 5)
 		return -EPERM;
-	printk("DIAG X'DC' error with return code: %i\n", rc);
+	kmsg_err(1,"Writing monitor data failed with rc=%i\n", rc);
 	return -EINVAL;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

