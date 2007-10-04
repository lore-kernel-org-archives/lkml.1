Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXJDJZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXJDJZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759165AbXJDJR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbXJDJR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:57 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Wendy Cheng <wcheng@redhat.com>
Subject: [PATCH 23/51] [GFS2] Add a missing gfs2_trans_add_bh()
Date: Thu,  4 Oct 2007 09:49:16 +0100
Message-Id: <11914878323899-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878304004-git-send-email-swhiteho@redhat.com>
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
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This was missing from the dir_split_leaf() function although in
most cases its not a problem due to other functions having
already previously called gfs2_trans_add_bh. This makes certain
that it is correct.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Wendy Cheng <wcheng@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 2beb2f4..08c6dd0 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1043,6 +1043,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 
 	error = gfs2_meta_inode_buffer(dip, &dibh);
 	if (!gfs2_assert_withdraw(GFS2_SB(&dip->i_inode), !error)) {
+		gfs2_trans_add_bh(dip->i_gl, dibh, 1);
 		dip->i_di.di_blocks++;
 		gfs2_set_inode_blocks(&dip->i_inode);
 		gfs2_dinode_out(dip, dibh->b_data);
-- 
1.5.1.2

