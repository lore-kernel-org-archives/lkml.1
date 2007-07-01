Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbXGAHkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbXGAHkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXGAHhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:37:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36316 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbXGAHhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:37:17 -0400
Subject: [EXT4 set 4][PATCH 2/5] i_version: Add hi 32 bit inode version on
	ext4 on-disk inode
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:37:16 -0400
Message-Id: <1183275436.4010.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
---
Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -342,6 +342,7 @@ struct ext4_inode {
 	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
+	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
 };

 #define i_size_high	i_dir_acl


