Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZF3ULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZF3ULi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZF3ULb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:11:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZF3ULa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:11:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Fix lock imbalance
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 30 Jun 2009 21:10:13 +0100
Message-ID: <20090630201013.1166.64996.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Don't unlock on vfs_rejected_lock path in afs_do_setlk, since the lock
is unlocked after abort_attempt label.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
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
 

