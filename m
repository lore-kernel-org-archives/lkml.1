Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbXD0OPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbXD0OPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXD0OGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:21 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:20288 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbXD0OE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:57 -0400
Message-Id: <20070427140515.277009760@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 15/38] cio: cm_enable memory leak.
Content-Disposition: inline; filename=113-cio-leak.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

We allocage two pages when channel path measurements are enabled
via cm_enable. We must not forget to free them again when
channel path measurements are disabled again.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/chsc.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/chsc.c	2007-04-27 16:04:55.000000000 +0200
+++ quilt-2.6/drivers/s390/cio/chsc.c	2007-04-27 16:04:55.000000000 +0200
@@ -818,7 +818,7 @@
 		} else
 			chsc_remove_cmg_attr(css);
 	}
-	if (enable && !css->cm_enabled) {
+	if (!css->cm_enabled) {
 		free_page((unsigned long)css->cub_addr1);
 		free_page((unsigned long)css->cub_addr2);
 	}

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

