Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbXJDLe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbXJDLe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXJDL26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:58 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:36422 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXJDL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:30 -0400
Message-Id: <20071004112831.509745968@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: vignesh babu <vignesh.babu@wipro.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 25/34] is_power_of_2 in drivers/s390/block/dasd_int.h
Content-Disposition: inline; filename=025-power2-dasd.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: vignesh babu <vignesh.babu@wipro.com>

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/block/dasd_int.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/block/dasd_int.h
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_int.h
+++ quilt-2.6/drivers/s390/block/dasd_int.h
@@ -53,6 +53,7 @@
 #include <linux/genhd.h>
 #include <linux/hdreg.h>
 #include <linux/interrupt.h>
+#include <linux/log2.h>
 #include <asm/ccwdev.h>
 #include <linux/workqueue.h>
 #include <asm/debug.h>
@@ -456,7 +457,7 @@ dasd_free_chunk(struct list_head *chunk_
 static inline int
 dasd_check_blocksize(int bsize)
 {
-	if (bsize < 512 || bsize > 4096 || (bsize & (bsize - 1)) != 0)
+	if (bsize < 512 || bsize > 4096 || !is_power_of_2(bsize))
 		return -EMEDIUMTYPE;
 	return 0;
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

