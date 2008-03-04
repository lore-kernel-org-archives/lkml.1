Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYCDCE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYCDCE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYCDCBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:10568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbYCDCBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IYSQoFTp8AsfnjLgWe76epSKJ6+Zt/i/To/MxFXda3pqYFGcB1kxfmR+g03BhkXZW1jJjg5OVdcPXQi0lxXeeVtEF8RPxHUkU4BBAMAyPj2VeHfYlZMOx0+F0/bxOWnM5EX5SpVQ5bc+XW8uahfhAqFs7u6wthev69HnVCdYsv8=
Subject: [PATCH 10/13] jbd: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Stephen C. Tweedie" <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:05 -0800
Message-Id: <1204596065.22933.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jbd/journal.c     |   18 +++++++++---------
 fs/jbd/revoke.c      |    2 +-
 fs/jbd/transaction.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..c09bd77 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -534,7 +534,7 @@ int log_wait_commit(journal_t *journal, tid_t tid)
 	if (!tid_geq(journal->j_commit_request, tid)) {
 		printk(KERN_EMERG
 		       "%s: error: j_commit_request=%d, tid=%d\n",
-		       __FUNCTION__, journal->j_commit_request, tid);
+		       __func__, journal->j_commit_request, tid);
 	}
 	spin_unlock(&journal->j_state_lock);
 #endif
@@ -599,7 +599,7 @@ int journal_bmap(journal_t *journal, unsigned long blocknr,
 
 			printk(KERN_ALERT "%s: journal block not found "
 					"at offset %lu on %s\n",
-				__FUNCTION__,
+				__func__,
 				blocknr,
 				bdevname(journal->j_dev, b));
 			err = -EIO;
@@ -727,7 +727,7 @@ journal_t * journal_init_dev(struct block_device *bdev,
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		journal = NULL;
 		goto out;
@@ -781,7 +781,7 @@ journal_t * journal_init_inode (struct inode *inode)
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -790,7 +790,7 @@ journal_t * journal_init_inode (struct inode *inode)
 	/* If that failed, give up */
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
-		       __FUNCTION__);
+		       __func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -876,7 +876,7 @@ int journal_create(journal_t *journal)
 		 */
 		printk(KERN_EMERG
 		       "%s: creation of journal on external device!\n",
-		       __FUNCTION__);
+		       __func__);
 		BUG();
 	}
 
@@ -1656,7 +1656,7 @@ static struct journal_head *journal_alloc_journal_head(void)
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
-			       __FUNCTION__);
+			       __func__);
 			last_warning = jiffies;
 		}
 		while (ret == NULL) {
@@ -1793,13 +1793,13 @@ static void __journal_remove_journal_head(struct buffer_head *bh)
 			if (jh->b_frozen_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index ad2eacf..2d8fb96 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -138,7 +138,7 @@ repeat:
 oom:
 	if (!journal_oom_retry)
 		return -ENOMEM;
-	jbd_debug(1, "ENOMEM in %s, retrying\n", __FUNCTION__);
+	jbd_debug(1, "ENOMEM in %s, retrying\n", __func__);
 	yield();
 	goto repeat;
 }
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index c6cbb6c..e6696a4 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -681,7 +681,7 @@ repeat:
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
 					       "%s: OOM for frozen_buffer\n",
-					       __FUNCTION__);
+					       __func__);
 					JBUFFER_TRACE(jh, "oom!");
 					error = -ENOMEM;
 					jbd_lock_bh_state(bh);
@@ -891,7 +891,7 @@ repeat:
 		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
-				__FUNCTION__);
+				__func__);
 			err = -ENOMEM;
 			goto out;
 		}
-- 
1.5.4.3.500.g83a2c


