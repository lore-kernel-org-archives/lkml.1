Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXHGLQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXHGLQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbXHGLPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:15:12 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:2212 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106AbXHGLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:15:08 -0400
Message-Id: <20070807111844.909113621@de.ibm.com>
References: <20070807111519.972871123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Aug 2007 13:15:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/18] cio: avoid memory leak on error in css_alloc_subchannel().
Content-Disposition: inline; filename=001-cio-leak.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

sch->lock has been allocated in cio_validate_subchannel(), it must be
freed if cio_modify() fails.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/css.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -79,6 +79,7 @@ css_alloc_subchannel(struct subchannel_i
 	sch->schib.pmcw.intparm = (__u32)(unsigned long)sch;
 	ret = cio_modify(sch);
 	if (ret) {
+		kfree(sch->lock);
 		kfree(sch);
 		return ERR_PTR(ret);
 	}

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

