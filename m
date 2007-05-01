Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXEASRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXEASRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXEASRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:17:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030608AbXEASRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:17:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Fix use of __exit functions from __init path
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, geert@linux-m68k.org, dhowells@redhat.com
Date: Tue, 01 May 2007 19:17:06 +0100
Message-ID: <20070501181706.28008.10566.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix use of __exit functions from __init path.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/callback.c  |    2 +-
 fs/afs/internal.h  |    4 ++--
 fs/afs/vlocation.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 639399f..9bdbf36 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -468,7 +468,7 @@ int __init afs_callback_update_init(void)
 /*
  * shut down the callback update process
  */
-void __exit afs_callback_update_kill(void)
+void afs_callback_update_kill(void)
 {
 	destroy_workqueue(afs_callback_update_worker);
 }
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index c0404b4..f1bd47e 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -401,7 +401,7 @@ extern void afs_give_up_callback(struct afs_vnode *);
 extern void afs_dispatch_give_up_callbacks(struct work_struct *);
 extern void afs_flush_callback_breaks(struct afs_server *);
 extern int __init afs_callback_update_init(void);
-extern void __exit afs_callback_update_kill(void);
+extern void afs_callback_update_kill(void);
 
 /*
  * cell.c
@@ -605,7 +605,7 @@ extern struct afs_vlocation *afs_vlocation_lookup(struct afs_cell *,
 						  struct key *,
 						  const char *, size_t);
 extern void afs_put_vlocation(struct afs_vlocation *);
-extern void __exit afs_vlocation_purge(void);
+extern void afs_vlocation_purge(void);
 
 /*
  * vnode.c
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index 6c8e95a..3370cdb 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -602,7 +602,7 @@ int __init afs_vlocation_update_init(void)
 /*
  * discard all the volume location records for rmmod
  */
-void __exit afs_vlocation_purge(void)
+void afs_vlocation_purge(void)
 {
 	afs_vlocation_timeout = 0;
 

