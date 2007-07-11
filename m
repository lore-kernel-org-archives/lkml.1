Return-Path: <linux-kernel-owner+w=401wt.eu-S1765566AbXGKSZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566AbXGKSZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXGKSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:25:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59754 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379AbXGKSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:25:09 -0400
Date: Wed, 11 Jul 2007 13:20:33 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 2][PATCH 3/5] cleanups: set_jbd2_64bit_feature for
 >16TB ext4 fs
Message-ID: <20070711132033.3d6f5efe@rx8>
In-Reply-To: <20070710163022.333ece67.akpm@linux-foundation.org>
References: <1183275392.4010.122.camel@localhost.localdomain>
	<20070710163022.333ece67.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
 fs/ext4/super.c |    7 	7 +	0 -	0 !
 1 file changed, 7 insertions(+)

Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2007-07-11 09:36:00.000000000 -0500
+++ linux-2.6/fs/ext4/super.c	2007-07-11 09:36:20.000000000 -0500
@@ -1804,6 +1804,13 @@ static int ext4_fill_super (struct super
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
