Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYAQWln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYAQWln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbYAQWgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:45 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36251 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbYAQWgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:37 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 15/30] ocfs2: build warnings fix
Date: Thu, 17 Jan 2008 14:35:41 -0800
Message-Id: <1200609356-17788-16-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix these types of warnings:

fs/ocfs2/resize.c: In function ‘ocfs2_group_extend’:
fs/ocfs2/resize.c:358: warning: format ‘%llu’ expects type ‘long long
unsigned int’, but argument 6 has type ‘long unsigned int’

u64 needs to be casted to unsigned long long when printing as %llu

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/resize.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index ba305c1..84e06b6 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -356,7 +356,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	}
 
 	mlog(0, "extend the last group at %llu, new clusters = %d\n",
-	     le64_to_cpu(group->bg_blkno), new_clusters);
+	     (unsigned long long)le64_to_cpu(group->bg_blkno), new_clusters);
 
 	handle = ocfs2_start_trans(osb, OCFS2_GROUP_EXTEND_CREDITS);
 	if (IS_ERR(handle)) {
@@ -547,7 +547,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
 	if (ret < 0) {
 		mlog(ML_ERROR, "Can't read the group descriptor # %llu "
-		     "from the device.", input->group);
+		     "from the device.", (unsigned long long)input->group);
 		goto out;
 	}
 
@@ -560,7 +560,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	}
 
 	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
-	     input->group, input->chain, input->clusters);
+	     (unsigned long long)input->group, input->chain, input->clusters);
 
 	handle = ocfs2_start_trans(osb, OCFS2_GROUP_ADD_CREDITS);
 	if (IS_ERR(handle)) {
-- 
1.5.3.6

