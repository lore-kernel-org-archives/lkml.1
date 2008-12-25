Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYLYOfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYLYOfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYLYOfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:35:31 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51815 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYLYOf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:35:29 -0500
Date: Thu, 25 Dec 2008 15:35:27 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: swhiteho@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] fs/gfs2: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251535080.22039@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

SPIN_LOCK_UNLOCKED is deprecated.  The following makes the change suggested
in Documentation/spinlocks.txt

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
declarer name DEFINE_SPINLOCK;
identifier xxx_lock;
@@

- spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
+ DEFINE_SPINLOCK(xxx_lock);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/fs/gfs2/glock.c b/fs/gfs2/glock.c
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -65,7 +65,7 @@ static struct dentry *gfs2_root;
 static struct workqueue_struct *glock_workqueue;
 static LIST_HEAD(lru_list);
 static atomic_t lru_count = ATOMIC_INIT(0);
-static spinlock_t lru_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(lru_lock);
 
 #define GFS2_GL_HASH_SHIFT      15
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
