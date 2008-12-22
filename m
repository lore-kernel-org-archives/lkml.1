Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYLVWDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYLVWDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbYLVVuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:50:04 -0500
Received: from mx1.suse.de ([195.135.220.2]:41726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbYLVVuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:50:02 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 41/56] ocfs2/quota: sparse fixes for quota
Date: Mon, 22 Dec 2008 13:48:22 -0800
Message-Id: <1229982517-3455-42-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

Fix 2 minor things in quota. They are both found by sparse check.
1. an endian bug in ocfs2_local_quota_add_chunk.
2. change olq_alloc_dquot to static.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_local.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 9b22643..5353c42 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -988,7 +988,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		goto out_trans;
 	}
 	lock_buffer(bh);
-	dchunk->dqc_free = ol_quota_entries_per_block(sb);
+	dchunk->dqc_free = cpu_to_le32(ol_quota_entries_per_block(sb));
 	memset(dchunk->dqc_bitmap, 0,
 	       sb->s_blocksize - sizeof(struct ocfs2_local_disk_chunk) -
 	       OCFS2_QBLK_RESERVED_SPACE);
@@ -1110,7 +1110,7 @@ out:
 	return ERR_PTR(status);
 }
 
-void olq_alloc_dquot(struct buffer_head *bh, void *private)
+static void olq_alloc_dquot(struct buffer_head *bh, void *private)
 {
 	int *offset = private;
 	struct ocfs2_local_disk_chunk *dchunk;
-- 
1.5.6

