Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYAVDv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYAVDv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYAVDvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:51:44 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51675 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbYAVDvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:51:43 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 49/49] jbd2: sparse pointer use of zero as null
Date: Mon, 21 Jan 2008 22:02:28 -0500
Message-Id: <1200970948-17903-50-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-49-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
 <1200970948-17903-39-git-send-email-tytso@mit.edu>
 <1200970948-17903-40-git-send-email-tytso@mit.edu>
 <1200970948-17903-41-git-send-email-tytso@mit.edu>
 <1200970948-17903-42-git-send-email-tytso@mit.edu>
 <1200970948-17903-43-git-send-email-tytso@mit.edu>
 <1200970948-17903-44-git-send-email-tytso@mit.edu>
 <1200970948-17903-45-git-send-email-tytso@mit.edu>
 <1200970948-17903-46-git-send-email-tytso@mit.edu>
 <1200970948-17903-47-git-send-email-tytso@mit.edu>
 <1200970948-17903-48-git-send-email-tytso@mit.edu>
 <1200970948-17903-49-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

Get rid of sparse related warnings from places that use integer as NULL
pointer.  (Ported from upstream ext3/jbd changes.)

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/transaction.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 0c8adab..b9b0b6f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1182,7 +1182,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	}
 
 	/* That test should have eliminated the following case: */
-	J_ASSERT_JH(jh, jh->b_frozen_data == 0);
+	J_ASSERT_JH(jh, jh->b_frozen_data == NULL);
 
 	JBUFFER_TRACE(jh, "file as BJ_Metadata");
 	spin_lock(&journal->j_list_lock);
@@ -1532,7 +1532,7 @@ void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	if (jh->b_jlist != BJ_None)
-		J_ASSERT_JH(jh, transaction != 0);
+		J_ASSERT_JH(jh, transaction != NULL);
 
 	switch (jh->b_jlist) {
 	case BJ_None:
@@ -1601,11 +1601,11 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 	if (buffer_locked(bh) || buffer_dirty(bh))
 		goto out;
 
-	if (jh->b_next_transaction != 0)
+	if (jh->b_next_transaction != NULL)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != 0 && jh->b_cp_transaction == 0) {
+	if (jh->b_transaction != NULL && jh->b_cp_transaction == NULL) {
 		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
@@ -1613,7 +1613,7 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 			jbd2_journal_remove_journal_head(bh);
 			__brelse(bh);
 		}
-	} else if (jh->b_cp_transaction != 0 && jh->b_transaction == 0) {
+	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1973,7 +1973,7 @@ void __jbd2_journal_file_buffer(struct journal_head *jh,
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
-				jh->b_transaction == 0);
+				jh->b_transaction == NULL);
 
 	if (jh->b_transaction && jh->b_jlist == jlist)
 		return;
-- 
1.5.4.rc3.31.g1271-dirty

