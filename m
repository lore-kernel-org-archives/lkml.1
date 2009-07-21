Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZGUGEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZGUGEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZGUGEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:04:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:55920 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZGUGE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:29 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: Fix v9fs show_options
Date: Tue, 21 Jul 2009 00:03:52 -0600
Message-Id: <1248156236-3005-3-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the delimiter ',' before the options when they are passed
and check if no option parameters are passed to prevent displaying
NULL in /proc/mounts.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 2f8a3f2... 072dce0... M	fs/9p/vfs_super.c
 fs/9p/vfs_super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 2f8a3f2..072dce0 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -218,8 +218,8 @@ static void v9fs_kill_super(struct super_block *s)
 static int v9fs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct v9fs_session_info *v9ses = mnt->mnt_sb->s_fs_info;
-
-	seq_printf(m, "%s", v9ses->options);
+	if (v9ses->options != NULL)
+		seq_printf(m, ",%s", v9ses->options);
 	return 0;
 }
 
-- 
1.6.0.4

