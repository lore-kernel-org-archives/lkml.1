Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYIXWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYIXWGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYIXWBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:01:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:52228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbYIXWAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:34 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 21/39] ocfs2: fix printk format warnings
Date: Wed, 24 Sep 2008 15:01:02 -0700
Message-Id: <1222293680-15451-22-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build warnings:

fs/ocfs2/xattr.c: In function 'ocfs2_half_xattr_bucket':
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 7 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 8 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 7 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 8 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 7 has type 'long int'
fs/ocfs2/xattr.c:3282: warning: format '%d' expects type 'int', but argument 8 has type 'long int'
fs/ocfs2/xattr.c: In function 'ocfs2_xattr_set_entry_in_bucket':
fs/ocfs2/xattr.c:4092: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
fs/ocfs2/xattr.c:4092: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
fs/ocfs2/xattr.c:4092: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 090449f..1b349c7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3264,7 +3264,8 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	xe = &xh->xh_entries[start];
 	len = sizeof(struct ocfs2_xattr_entry) * (count - start);
 	mlog(0, "mv xattr entry len %d from %d to %d\n", len,
-	     (char *)xe - (char *)xh, (char *)xh->xh_entries - (char *)xh);
+	     (int)((char *)xe - (char *)xh),
+	     (int)((char *)xh->xh_entries - (char *)xh));
 	memmove((char *)xh->xh_entries, (char *)xe, len);
 	xe = &xh->xh_entries[count - start];
 	len = sizeof(struct ocfs2_xattr_entry) * start;
@@ -4073,8 +4074,8 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog(0, "Set xattr entry len = %d index = %d in bucket %llu\n",
-	     xi->value_len, xi->name_index,
+	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
+	     (unsigned long)xi->value_len, xi->name_index,
 	     (unsigned long long)xs->bucket.bhs[0]->b_blocknr);
 
 	if (!xs->bucket.bhs[1]) {
-- 
1.5.4.5

