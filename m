Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbXD0OLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbXD0OLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXD0OG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:59 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:20291 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbXD0OFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:05:00 -0400
Message-Id: <20070427140518.425608573@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 28/38] sclp: initialize early.
Content-Disposition: inline; filename=131-sclp-init.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Add explicit sclp initialization for those sclp users that do not
register with the interface.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/sclp.c |    8 ++++++++
 1 files changed, 8 insertions(+)

Index: quilt-2.6/drivers/s390/char/sclp.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/sclp.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/drivers/s390/char/sclp.c	2007-04-27 16:04:59.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/timer.h>
 #include <linux/reboot.h>
 #include <linux/jiffies.h>
+#include <linux/init.h>
 #include <asm/types.h>
 #include <asm/s390_ext.h>
 
@@ -930,3 +931,10 @@
 	sclp_init_mask(1);
 	return 0;
 }
+
+static __init int sclp_initcall(void)
+{
+	return sclp_init();
+}
+
+arch_initcall(sclp_initcall);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

