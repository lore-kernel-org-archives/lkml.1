Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYBFQ46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYBFQ46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYBFQ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:56:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58464 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYBFQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:56:50 -0500
Date: Wed, 6 Feb 2008 17:56:49 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add explanation of I_DIRTY_DATASYNC bit
Message-ID: <20080206165649.GC23382@atrey.karlin.mff.cuni.cz>
References: <20080206162920.GB3475@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206162920.GB3475@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explanation of I_DIRTY_DATASYNC bit.

Signed-off-by: Jan Kara <jack@suse.cz>

---
Fixed a typo...

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
+ *			these changes separately from I_DIRTY_SYNC so that we
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
