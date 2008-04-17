Return-Path: <linux-kernel-owner+w=401wt.eu-S933346AbYDQJwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbYDQJwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbYDQJ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933737AbYDQJ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:36 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 38/48] [GFS2] re-support special inode
Date: Thu, 17 Apr 2008 09:39:14 +0100
Message-Id: <1208421647805-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1208421645785-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

a previous commit removed call to
init_special_inode from inode lookuping, this cause problems as:

 # mknod /mnt/gfs2/dev/null c 1 3
 # cat /mnt/gfs2/dev/null
 cat: /mnt/gfs2/dev/null: Invalid argument

without special inode, GFS2 cannot support char device file,
block device file, fifo pipe, and socket file, lose many important
features as a common file system.

this one line patch re add special inode support.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7b9f31e..92ea9af 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -150,6 +150,7 @@ void gfs2_set_iop(struct inode *inode)
 		inode->i_op = &gfs2_symlink_iops;
 	} else {
 		inode->i_op = &gfs2_file_iops;
+		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	}
 
 	unlock_new_inode(inode);
-- 
1.5.1.2

