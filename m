Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYGNWFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYGNWFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbYGNWCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:11 -0400
Received: from mail.suse.de ([195.135.220.2]:49944 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049AbYGNWCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:09 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 08/17] ocfs2: Fix CONFIG_OCFS2_DEBUG_FS #ifdefs
Date: Mon, 14 Jul 2008 15:01:41 -0700
Message-Id: <1216072910-27226-9-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

A couple places use OCFS2_DEBUG_FS where they really mean
CONFIG_OCFS2_DEBUG_FS.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c    |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9698338..a8c19cb 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -329,7 +329,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
 
-#ifdef OCFS2_DEBUG_FS
+#ifdef CONFIG_OCFS2_DEBUG_FS
 	status = 1;
 #else
 	status = journal_extend(handle, nblocks);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index be774bd..28e492e 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -498,7 +498,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 
-#ifdef OCFS2_DEBUG_FS
+#ifdef CONFIG_OCFS2_DEBUG_FS
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
 		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-- 
1.5.4.1

