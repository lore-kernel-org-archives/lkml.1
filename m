Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXGIQdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXGIQdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbXGIQYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbXGIQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:08 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Fix typo in rename of directories
Date: Mon,  9 Jul 2007 17:02:38 +0100
Message-Id: <11839970542719-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970521835-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

A typo caused us to pass a NULL pointer when renaming directories. It
was accidentally introduced in: [GFS2] Clean up inode number handling

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 9cc07f4..84051b9 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -749,7 +749,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_end_trans;
 
-		error = gfs2_dir_mvino(ip, &name, nip, DT_DIR);
+		error = gfs2_dir_mvino(ip, &name, ndip, DT_DIR);
 		if (error)
 			goto out_end_trans;
 	} else {
-- 
1.5.1.2

