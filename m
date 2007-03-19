Return-Path: <linux-kernel-owner+w=401wt.eu-S933887AbXCSNCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbXCSNCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933892AbXCSNCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:02:37 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:16224 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933887AbXCSNCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:02:35 -0400
Date: Mon, 19 Mar 2007 14:02:47 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com
Subject: [S390] cio: allow 0 and 1 as input for channel path status attribute
Message-ID: <20070319130247.GE1292@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

[S390] cio: allow 0 and 1 as input for channel path status attribute

Channel path status can now be modified by writing '0' and '1'
to the sysfs status attribute in addition to 'offline' and
'online' respectively.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/chsc.c linux-2.6-patched/drivers/s390/cio/chsc.c
--- linux-2.6/drivers/s390/cio/chsc.c	2007-03-19 13:09:34.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.c	2007-03-19 13:09:36.000000000 +0100
@@ -1169,9 +1169,9 @@ chp_status_write(struct device *dev, str
 	if (!num_args)
 		return count;
 
-	if (!strnicmp(cmd, "on", 2))
+	if (!strnicmp(cmd, "on", 2) || !strcmp(cmd, "1"))
 		error = s390_vary_chpid(cp->chpid, 1);
-	else if (!strnicmp(cmd, "off", 3))
+	else if (!strnicmp(cmd, "off", 3) || !strcmp(cmd, "0"))
 		error = s390_vary_chpid(cp->chpid, 0);
 	else
 		error = -EINVAL;
