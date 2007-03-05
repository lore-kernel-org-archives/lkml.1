Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbXCEWnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbXCEWnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXCEWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:43:11 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:49137 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXCEWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:42:49 -0500
Date: Mon, 5 Mar 2007 23:42:49 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Call cancel_halt_clear even when actl == 0.
Message-ID: <20070305224249.GK22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Call cancel_halt_clear even when actl == 0.

The subchannel may just be status pending, even with actl == 0. We
must go through the cancel_halt_clear procedure to put the subchannel
into a defined state.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_fsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/device_fsm.c linux-2.6-patched/drivers/s390/cio/device_fsm.c
--- linux-2.6/drivers/s390/cio/device_fsm.c	2007-03-05 22:51:58.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device_fsm.c	2007-03-05 22:51:58.000000000 +0100
@@ -144,8 +144,8 @@ ccw_device_cancel_halt_clear(struct ccw_
 	ret = stsch(sch->schid, &sch->schib);
 	if (ret || !sch->schib.pmcw.dnv)
 		return -ENODEV; 
-	if (!sch->schib.pmcw.ena || sch->schib.scsw.actl == 0)
-		/* Not operational or no activity -> done. */
+	if (!sch->schib.pmcw.ena)
+		/* Not operational -> done. */
 		return 0;
 	/* Stage 1: cancel io. */
 	if (!(sch->schib.scsw.actl & SCSW_ACTL_HALT_PEND) &&
