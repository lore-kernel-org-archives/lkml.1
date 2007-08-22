Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbXHVMdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbXHVMdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbXHVMc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:32:59 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:28330 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbXHVMc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:32:57 -0400
Message-Id: <20070822123642.015644219@de.ibm.com>
References: <20070822123603.501231302@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 14:36:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 01/10] cio: dont forget to set last slot to NULL in ccw_uevent().
Content-Disposition: inline; filename=001-cio-uevent.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/cio/device.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -117,7 +117,10 @@ static int ccw_uevent(struct device *dev
 	snprint_alias(modalias_buf, sizeof(modalias_buf), id, "");
 	ret = add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
 			     "MODALIAS=%s", modalias_buf);
-	return ret;
+	if (ret)
+		return ret;
+	envp[i] = NULL;
+	return 0;
 }
 
 struct bus_type ccw_bus_type;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

