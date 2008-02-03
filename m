Return-Path: <linux-kernel-owner+w=401wt.eu-S1763129AbYBCEV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763129AbYBCEV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 23:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYBCEVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 23:21:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:42815 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYBCEVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 23:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F/fhlpAxHK911gp3HVVdZhOK1uuAMX7MMKLtsdcfjnxZRw1p3VoFUt2XDZKTeJAC26x0rZ7FRLd2mQj0DXAGta2y7cDCw2HqYatB81IDKCD0XZktz0ucyhojvt1BYflsNMyRyh1Pp91ulZwzxgUG6Kic54mEvM5Qf0cmam2OPcI=
Subject: [PATCH] jbd/jbd2: sparse warnings in revoke.c, journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Stephen C. Tweedie" <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 20:21:53 -0800
Message-Id: <1202012513.1844.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jbd/revoke.c:176:29: warning: Using plain integer as NULL pointer
fs/jbd/revoke.c:182:28: warning: Using plain integer as NULL pointer
fs/jbd/journal.c:1622:2: warning: Using plain integer as NULL pointer
fs/jbd/journal.c:1629:28: warning: Using plain integer as NULL pointer

fs/jbd2/revoke.c:177:34: warning: Using plain integer as NULL pointer
fs/jbd2/revoke.c:183:33: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:222:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:222:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:234:3: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:234:3: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:1972:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:1979:33: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:2005:13: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:2012:17: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jbd/journal.c  |    4 ++--
 fs/jbd/revoke.c   |    4 ++--
 fs/jbd2/journal.c |   12 ++++++------
 fs/jbd2/revoke.c  |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 5d14243..0459657 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1619,14 +1619,14 @@ static int journal_init_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(journal_head_cache == 0);
+	J_ASSERT(!journal_head_cache);
 	journal_head_cache = kmem_cache_create("journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (journal_head_cache == 0) {
+	if (!journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index ad2eacf..d5f8eee 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -173,13 +173,13 @@ int __init journal_init_revoke_caches(void)
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (revoke_record_cache == 0)
+	if (!revoke_record_cache)
 		return -ENOMEM;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (revoke_table_cache == 0) {
+	if (!revoke_table_cache) {
 		kmem_cache_destroy(revoke_record_cache);
 		revoke_record_cache = NULL;
 		return -ENOMEM;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 96ba846..748b87c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -219,7 +219,7 @@ static int jbd2_journal_start_thread(journal_t *journal)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 
-	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	wait_event(journal->j_wait_done_commit, journal->j_task != NULL);
 	return 0;
 }
 
@@ -231,7 +231,7 @@ static void journal_kill_thread(journal_t *journal)
 	while (journal->j_task) {
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
-		wait_event(journal->j_wait_done_commit, journal->j_task == 0);
+		wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
@@ -1969,14 +1969,14 @@ static int journal_init_jbd2_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(jbd2_journal_head_cache == 0);
+	J_ASSERT(!jbd2_journal_head_cache);
 	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (jbd2_journal_head_cache == 0) {
+	if (!jbd2_journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
@@ -2002,14 +2002,14 @@ static struct journal_head *journal_alloc_journal_head(void)
 	atomic_inc(&nr_journal_heads);
 #endif
 	ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
-	if (ret == 0) {
+	if (!ret) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __FUNCTION__);
 			last_warning = jiffies;
 		}
-		while (ret == 0) {
+		while (!ret) {
 			yield();
 			ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
 		}
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index df36f42..2e1453a 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -174,13 +174,13 @@ int __init jbd2_journal_init_revoke_caches(void)
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (jbd2_revoke_record_cache == 0)
+	if (!jbd2_revoke_record_cache)
 		return -ENOMEM;
 
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (jbd2_revoke_table_cache == 0) {
+	if (!jbd2_revoke_table_cache) {
 		kmem_cache_destroy(jbd2_revoke_record_cache);
 		jbd2_revoke_record_cache = NULL;
 		return -ENOMEM;
-- 
1.5.4.rc5.1138.g2602



