Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYLYOfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYLYOfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYLYOfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:35:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42511 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYLYOfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:35:08 -0500
Date: Thu, 25 Dec 2008 15:35:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mail@davidkiliani.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/7] drivers/staging/meilhaus: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251534450.22039@ask.diku.dk>
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
diff -u -p a/drivers/staging/meilhaus/memain.c b/drivers/staging/meilhaus/memain.c
--- a/drivers/staging/meilhaus/memain.c
+++ b/drivers/staging/meilhaus/memain.c
@@ -79,7 +79,7 @@ MODULE_PARM(major, "i");
 
 static struct file *me_filep = NULL;
 static int me_count = 0;
-static spinlock_t me_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(me_lock);
 static DECLARE_RWSEM(me_rwsem);
 
 /* Board instances are kept in a global list */
