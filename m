Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXHVJMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXHVJMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXHVIx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:57 -0400
Received: from 1wt.eu ([62.212.114.60]:2178 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977AbXHVIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:56 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084028.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:22 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jan Kara <jack@suse.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Kirill Korotaev <dev@openvz.org>, <linux-ext4@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 38/58] jbd2 commit: fix transaction dropping
Content-Disposition: inline; filename=0038-jbd2-commit-fix-transaction-dropping.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/jbd2/commit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6bd8005..7d29549 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -897,7 +897,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
-- 
1.5.2.5

-- 
