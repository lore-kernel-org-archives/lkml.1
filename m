Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYJMIYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYJMIYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYJMIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:24:41 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:50342 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYJMIYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:24:39 -0400
Date: Mon, 13 Oct 2008 10:23:22 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] claw: fix compile bug.
Message-ID: <20081013082322.GA17793@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit b9d3aed7e1e50183085fcd2af643bf42d6b4bd95
"[S390] more bus_id -> dev_name conversions" introduced this compile bug:

  CC      drivers/s390/net/claw.o
drivers/s390/net/claw.c: In function 'claw_new_device':
drivers/s390/net/claw.c:2917: error: expected ')' before 'ret'
drivers/s390/net/claw.c:2917: warning: too few arguments for format
make[2]: *** [drivers/s390/net/claw.o] Error 1
make[1]: *** [drivers/s390/net] Error 2

Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/net/claw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/s390/net/claw.c
===================================================================
--- linux-2.6.orig/drivers/s390/net/claw.c
+++ linux-2.6/drivers/s390/net/claw.c
@@ -2913,7 +2913,7 @@ claw_new_device(struct ccwgroup_device *
 	if (ret != 0) {
 		printk(KERN_WARNING
 			"claw: ccw_device_set_online %s WRITE failed "
-		       "with ret = %d\n", dev_name(&cgdev->cdev[WRITE]->dev)
+		       "with ret = %d\n", dev_name(&cgdev->cdev[WRITE]->dev),
 		       ret);
 		goto out;
 	}
