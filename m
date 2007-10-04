Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbXJDLku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbXJDLku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbXJDL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:23 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53244 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbXJDL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:27 -0400
Message-Id: <20071004112828.970680427@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:22 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ralph Wuerthner <rwuerthn@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 16/34] zcrypt: fix ap_reset_domain()
Content-Disposition: inline; filename=016-zcrypt-reset.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

Resetting of a all queues within a domain requires that a domain must 
be selected first.

Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/crypto/ap_bus.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/crypto/ap_bus.c
===================================================================
--- quilt-2.6.orig/drivers/s390/crypto/ap_bus.c
+++ quilt-2.6/drivers/s390/crypto/ap_bus.c
@@ -1231,8 +1231,9 @@ static void ap_reset_domain(void)
 {
 	int i;
 
-	for (i = 0; i < AP_DEVICES; i++)
-		ap_reset_queue(AP_MKQID(i, ap_domain_index));
+	if (ap_domain_index != -1)
+		for (i = 0; i < AP_DEVICES; i++)
+			ap_reset_queue(AP_MKQID(i, ap_domain_index));
 }
 
 static void ap_reset_all(void)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

