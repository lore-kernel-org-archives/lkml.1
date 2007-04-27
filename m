Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbXD0TD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbXD0TD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXD0S6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:50729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbXD0S6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/46] qeth: Remove usage of subsys.rwsem
Date: Fri, 27 Apr 2007 11:53:43 -0700
Message-Id: <11777001442148-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001413571-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

the current driver tree contains the removal of subsys.rwsem.
Unfortunately, this breaks qeth. However, it should be no problem to
fix the walking of the devices for /proc/qeth:

No need to take subsys.rwsem during walking the devices,
driver_find_devices() should already suffice.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/net/qeth_proc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_proc.c b/drivers/s390/net/qeth_proc.c
index 81f805c..89d56c8 100644
--- a/drivers/s390/net/qeth_proc.c
+++ b/drivers/s390/net/qeth_proc.c
@@ -37,7 +37,6 @@ qeth_procfile_seq_start(struct seq_file *s, loff_t *offset)
 	struct device *dev = NULL;
 	loff_t nr = 0;
 
-	down_read(&qeth_ccwgroup_driver.driver.bus->subsys.rwsem);
 	if (*offset == 0)
 		return SEQ_START_TOKEN;
 	while (1) {
@@ -53,7 +52,6 @@ qeth_procfile_seq_start(struct seq_file *s, loff_t *offset)
 static void
 qeth_procfile_seq_stop(struct seq_file *s, void* it)
 {
-	up_read(&qeth_ccwgroup_driver.driver.bus->subsys.rwsem);
 }
 
 static void *
-- 
1.5.1.2

