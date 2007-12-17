Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXLQStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXLQStT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXLQStL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:49:11 -0500
Received: from styx.suse.cz ([82.119.242.94]:60901 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752936AbXLQStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:49:11 -0500
Date: Mon, 17 Dec 2007 19:49:09 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix compilation warning in dquot.c
Message-ID: <20071217184909.GF25521@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Andrew, would you please apply the patch below? Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Fix compilation warning about discarded const.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/dquot.c b/fs/dquot.c
index 2809768..686ab63 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -965,7 +965,7 @@ err_out:
 }
 #endif
 
-static inline void flush_warnings(struct dquot **dquots, char *warntype)
+static inline void flush_warnings(struct dquot * const *dquots, char *warntype)
 {
 	int i;
 
@@ -1216,7 +1216,7 @@ warn_put_all:
 		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 			if (inode->i_dquot[cnt])
 				mark_dquot_dirty(inode->i_dquot[cnt]);
-	flush_warnings((struct dquot **)inode->i_dquot, warntype);
+	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
