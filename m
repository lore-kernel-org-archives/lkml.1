Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYBFQ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYBFQ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYBFQ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:29:22 -0500
Received: from styx.suse.cz ([82.119.242.94]:44786 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415AbYBFQ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:29:22 -0500
Date: Wed, 6 Feb 2008 17:29:20 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add explanation of I_DIRTY_DATASYNC bit
Message-ID: <20080206162920.GB3475@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explanation of I_DIRTY_DATASYNC bit.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 56bd421..475125e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1280,7 +1280,10 @@ struct super_operations {
  * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
  *
  * I_DIRTY_SYNC		Inode itself is dirty.
- * I_DIRTY_DATASYNC	Data-related inode changes pending
+ * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
+ *		`	these changes separately from I_DIRTY_SYNC so that we
+ *			don't have to write inode on fdatasync() when only
+ *			mtime has changed in it.
  * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
  * I_NEW		get_new_inode() sets i_state to I_LOCK|I_NEW.  Both
  *			are cleared by unlock_new_inode(), called from iget().
@@ -1312,8 +1315,6 @@ struct super_operations {
  *			purpose reduces latency and prevents some filesystem-
  *			specific deadlocks.
  *
- * Q: Why does I_DIRTY_DATASYNC exist?  It appears as if it could be replaced
- *    by (I_DIRTY_SYNC|I_DIRTY_PAGES).
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
  *    I_CLEAR?  If not, why?
