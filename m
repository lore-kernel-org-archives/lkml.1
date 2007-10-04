Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbXJDJYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbXJDJYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbXJDJRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759514AbXJDJRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:51 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/51] [GFS2] fixed a NULL pointer assignment BUG
Date: Thu,  4 Oct 2007 09:49:13 +0100
Message-Id: <11914878271468-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878252873-git-send-email-swhiteho@redhat.com>
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
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6c820cb..c1c6672 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -292,8 +292,9 @@ static int init_sb(struct gfs2_sbd *sdp, int silent, int undo)
 		fs_err(sdp, "can't get root dentry\n");
 		error = -ENOMEM;
 		iput(inode);
-	}
-	sb->s_root->d_op = &gfs2_dops;
+	} else
+		sb->s_root->d_op = &gfs2_dops;
+	
 out:
 	gfs2_glock_dq_uninit(&sb_gh);
 	return error;
-- 
1.5.1.2

