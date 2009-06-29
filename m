Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbZF2QC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbZF2QC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbZF2QCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:02:08 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:48797 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZF2QCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:02:06 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: dhowells@redhat.com
Cc: linux-afs@lists.infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/5] FS: afs, fix lock imbalance
Date: Mon, 29 Jun 2009 18:01:11 +0200
Message-Id: <1246291271-3366-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't unlock on vfs_rejected_lock path in afs_do_setlk, since the lock
is unlocked after abort_attempt label.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/afs/flock.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index 210acaf..3ff8bdd 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -432,7 +432,6 @@ vfs_rejected_lock:
 	list_del_init(&fl->fl_u.afs.link);
 	if (list_empty(&vnode->granted_locks))
 		afs_defer_unlock(vnode, key);
-	spin_unlock(&vnode->lock);
 	goto abort_attempt;
 }
 
-- 
1.6.3.2

