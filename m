Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXD0OPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXD0OPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbXD0OFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:05:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:29119 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbXD0OEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:55 -0400
Message-Id: <20070427140513.133020917@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 06/38] cio: observe chpid valid flag
Content-Disposition: inline; filename=104-cio-chpid-valid.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Check validity flag of CHPID description data before continuing with
channel-path initialization.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chp.c |    4 ++++
 1 files changed, 4 insertions(+)

Index: quilt-2.6/drivers/s390/cio/chp.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/chp.c	2007-04-27 16:04:53.000000000 +0200
+++ quilt-2.6/drivers/s390/cio/chp.c	2007-04-27 16:04:53.000000000 +0200
@@ -339,6 +339,10 @@
 	ret = chsc_determine_channel_path_description(chpid, &chp->desc);
 	if (ret)
 		goto out_free;
+	if ((chp->desc.flags & 0x80) == 0) {
+		ret = -ENODEV;
+		goto out_free;
+	}
 	/* Get channel-measurement characteristics. */
 	if (css_characteristics_avail && css_chsc_characteristics.scmc
 	    && css_chsc_characteristics.secm) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

