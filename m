Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbYAVDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbYAVDOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbYAVDGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:51 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65238 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029AbYAVDGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:47 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 46/49] jbd2: add lockdep support
Date: Mon, 21 Jan 2008 22:02:25 -0500
Message-Id: <1200970948-17903-47-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-46-git-send-email-tytso@mit.edu>
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
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

Ported from similar patch for the jbd layer.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/transaction.c |   11 +++++++++++
 include/linux/jbd2.h  |    4 ++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index f30802a..70b3199 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -241,6 +241,8 @@ out:
 	return ret;
 }
 
+static struct lock_class_key jbd2_handle_key;
+
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
@@ -251,6 +253,9 @@ static handle_t *new_handle(int nblocks)
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
+	lockdep_init_map(&handle->h_lockdep_map, "jbd2_handle",
+						&jbd2_handle_key, 0);
+
 	return handle;
 }
 
@@ -293,7 +298,11 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
+		goto out;
 	}
+
+	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+out:
 	return handle;
 }
 
@@ -1419,6 +1428,8 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
+	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+
 	jbd2_free_handle(handle);
 	return err;
 }
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a2645c2..f982d38 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -418,6 +418,10 @@ struct handle_s
 	unsigned int	h_sync:		1;	/* sync-on-close */
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	h_lockdep_map;
+#endif
 };
 
 
-- 
1.5.4.rc3.31.g1271-dirty

