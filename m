Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYK0KrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYK0KrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYK0KdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:25 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:52332 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYK0Kca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:30 -0500
Message-Id: <20081127103141.255592521@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:31:08 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Melissa Howland <melissah@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 48/60] convert monwriter printks to pr_xxx macros.
Content-Disposition: inline; filename=163-kmsg-monwriter.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melissa Howland <melissah@us.ibm.com>

Signed-off-by: Melissa Howland <melissah@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/monwriter.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/char/monwriter.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/monwriter.c
+++ quilt-2.6/drivers/s390/char/monwriter.c
@@ -8,6 +8,9 @@
  * Author(s): Melissa Howland <Melissa.Howland@us.ibm.com>
  */
 
+#define KMSG_COMPONENT "monwriter"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -64,9 +67,9 @@ static int monwrite_diag(struct monwrite
 	rc = appldata_asm(&id, fcn, (void *) buffer, myhdr->datalen);
 	if (rc <= 0)
 		return rc;
+	pr_err("Writing monitor data failed with rc=%i\n", rc);
 	if (rc == 5)
 		return -EPERM;
-	printk("DIAG X'DC' error with return code: %i\n", rc);
 	return -EINVAL;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

