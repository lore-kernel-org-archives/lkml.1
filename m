Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXGAHiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXGAHiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbXGAHgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:36:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45625 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbXGAHge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:36:34 -0400
Subject: [EXT4 set 2][PATCH 3/5] cleanups: set_jbd2_64bit_feature for >16TB
	ext4 fs
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:36:32 -0400
Message-Id: <1183275392.4010.122.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
than 32bit block sizes during mount time.  This ensure proper record
lenth when writing to the journal.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
---
 fs/ext4/super.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 16:15:54.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 16:16:10.000000000 -0700
@@ -1804,6 +1804,13 @@
 		goto failed_mount3;
 	}
 
+	if (ext4_blocks_count(es) > 0xffffffffULL &&
+	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
+				       JBD2_FEATURE_INCOMPAT_64BIT)) {
+		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
+		goto failed_mount4;
+	}
+
 	/* We have now updated the journal if required, so we can
 	 * validate the data journaling mode. */
 	switch (test_opt(sb, DATA_FLAGS)) {


