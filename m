Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYE1V5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYE1V5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYE1V4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:56:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:54463 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753424AbYE1V4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:56:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Silence warnings about non-uptodate buffers
Date: Wed, 28 May 2008 23:56:12 +0200
Message-Id: <12120117743119-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12120117733479-git-send-email-jack@suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When underlying block device becomes unavailable (e.g. someone pulling an
USB stick from under us), kernel produces warning about non-uptodate buffer
(superblock) being marked dirty. Silence these warnings by making buffer
uptodate before marking it dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/journal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 2e24567..55de8f7 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1261,6 +1261,7 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
 	spin_unlock(&journal->j_state_lock);
 
 	BUFFER_TRACE(bh, "marking dirty");
+	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	if (wait)
 		sync_dirty_buffer(bh);
-- 
1.5.2.4

