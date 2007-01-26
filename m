Return-Path: <linux-kernel-owner+w=401wt.eu-S1030842AbXAZQsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030842AbXAZQsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030846AbXAZQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:48:41 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59296 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030845AbXAZQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:48:40 -0500
Date: Fri, 26 Jan 2007 17:48:31 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Remove check for ssd in chpids_show().
Message-ID: <20070126164831.GF11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Remove check for ssd in chpids_show().

Since ssd_info is now available before the subchannel is registered,
we don't need to check whether it is available.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/device.c linux-2.6-patched/drivers/s390/cio/device.c
--- linux-2.6/drivers/s390/cio/device.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device.c	2007-01-26 17:27:51.000000000 +0100
@@ -234,11 +234,8 @@ chpids_show (struct device * dev, struct
 	ssize_t ret = 0;
 	int chp;
 
-	if (ssd)
-		for (chp = 0; chp < 8; chp++)
-			ret += sprintf (buf+ret, "%02x ", ssd->chpid[chp]);
-	else
-		ret += sprintf (buf, "n/a");
+	for (chp = 0; chp < 8; chp++)
+		ret += sprintf (buf+ret, "%02x ", ssd->chpid[chp]);
 	ret += sprintf (buf+ret, "\n");
 	return min((ssize_t)PAGE_SIZE, ret);
 }
