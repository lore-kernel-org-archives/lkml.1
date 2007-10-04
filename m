Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXJDJXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXJDJXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759488AbXJDJRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759482AbXJDJRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/51] [GFS2] use list_for_each_entry instead
Date: Thu,  4 Oct 2007 09:49:09 +0100
Message-Id: <11914878191964-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878173677-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index f0bcaa2..32b2859 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -808,7 +808,6 @@ static struct super_block* get_gfs2_sb(const char *dev_name)
 	struct nameidata nd;
 	struct file_system_type *fstype;
 	struct super_block *sb = NULL, *s;
-	struct list_head *l;
 	int error;
 
 	error = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
@@ -820,8 +819,7 @@ static struct super_block* get_gfs2_sb(const char *dev_name)
 	error = vfs_getattr(nd.mnt, nd.dentry, &stat);
 
 	fstype = get_fs_type("gfs2");
-	list_for_each(l, &fstype->fs_supers) {
-		s = list_entry(l, struct super_block, s_instances);
+	list_for_each_entry(s, &fstype->fs_supers, s_instances) {
 		if ((S_ISBLK(stat.mode) && s->s_dev == stat.rdev) ||
 		    (S_ISDIR(stat.mode) && s == nd.dentry->d_inode->i_sb)) {
 			sb = s;
-- 
1.5.1.2

