Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbXFEVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbXFEVum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765668AbXFEVue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:50:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54669 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761890AbXFEVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:50:33 -0400
Date: Tue, 5 Jun 2007 23:50:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/afs/: possible cleanups
Message-ID: <20070605215035.GH5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global functions static:
  - rxrpc.c: afs_send_pages()
  - vlocation.c: afs_vlocation_queue_for_updates()
  - write.c: afs_writepages_region()
- make the following needlessly global variables static:
  - mntpt.c: afs_mntpt_expiry_timeout
  - proc.c: afs_vlocation_states[]
  - server.c: afs_server_timeout
  - vlocation.c: afs_vlocation_timeout
  - vlocation.c: afs_vlocation_update_timeout
- #if 0 the following unused function:
  - cell.c: afs_get_cell_maybe()
- #if 0 the following unused variables:
  - callback.c: afs_vnode_update_timeout
  - cmservice.c: struct afs_cm_workqueue

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/afs/callback.c  |    2 ++
 fs/afs/cell.c      |    2 ++
 fs/afs/cmservice.c |    2 ++
 fs/afs/internal.h  |    1 -
 fs/afs/mntpt.c     |    2 +-
 fs/afs/proc.c      |    2 +-
 fs/afs/rxrpc.c     |    3 ++-
 fs/afs/server.c    |    2 +-
 fs/afs/vlocation.c |    6 +++---
 fs/afs/write.c     |    6 +++---
 10 files changed, 17 insertions(+), 11 deletions(-)

--- linux-2.6.22-rc3-mm1/fs/afs/callback.c.old	2007-06-05 21:45:34.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/callback.c	2007-06-05 21:46:40.000000000 +0200
@@ -20,7 +20,9 @@
 #include <linux/sched.h>
 #include "internal.h"
 
+#if 0
 unsigned afs_vnode_update_timeout = 10;
+#endif  /*  0  */
 
 #define afs_breakring_space(server) \
 	CIRC_SPACE((server)->cb_break_head, (server)->cb_break_tail,	\
--- linux-2.6.22-rc3-mm1/fs/afs/cell.c.old	2007-06-05 21:47:20.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/cell.c	2007-06-05 21:47:39.000000000 +0200
@@ -265,6 +265,7 @@
 	return cell;
 }
 
+#if 0
 /*
  * try and get a cell record
  */
@@ -280,6 +281,7 @@
 	write_unlock(&afs_cells_lock);
 	return cell;
 }
+#endif  /*  0  */
 
 /*
  * destroy a cell record
--- linux-2.6.22-rc3-mm1/fs/afs/cmservice.c.old	2007-06-05 21:48:06.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/cmservice.c	2007-06-05 21:48:19.000000000 +0200
@@ -16,7 +16,9 @@
 #include "internal.h"
 #include "afs_cm.h"
 
+#if 0
 struct workqueue_struct *afs_cm_workqueue;
+#endif  /*  0  */
 
 static int afs_deliver_cb_init_call_back_state(struct afs_call *,
 					       struct sk_buff *, bool);
--- linux-2.6.22-rc3-mm1/fs/afs/internal.h.old	2007-06-05 21:48:48.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/internal.h	2007-06-05 21:48:55.000000000 +0200
@@ -570,7 +570,6 @@
  */
 extern const struct inode_operations afs_mntpt_inode_operations;
 extern const struct file_operations afs_mntpt_file_operations;
-extern unsigned long afs_mntpt_expiry_timeout;
 
 extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
 extern void afs_mntpt_kill_timer(void);
--- linux-2.6.22-rc3-mm1/fs/afs/mntpt.c.old	2007-06-05 21:49:03.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/mntpt.c	2007-06-05 21:49:11.000000000 +0200
@@ -42,7 +42,7 @@
 static LIST_HEAD(afs_vfsmounts);
 static DECLARE_DELAYED_WORK(afs_mntpt_expiry_timer, afs_mntpt_expiry_timed_out);
 
-unsigned long afs_mntpt_expiry_timeout = 10 * 60;
+static unsigned long afs_mntpt_expiry_timeout = 10 * 60;
 
 /*
  * check a symbolic link to see whether it actually encodes a mountpoint
--- linux-2.6.22-rc3-mm1/fs/afs/proc.c.old	2007-06-05 21:49:35.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/proc.c	2007-06-05 21:49:43.000000000 +0200
@@ -513,7 +513,7 @@
 	up_read(&cell->vl_sem);
 }
 
-const char afs_vlocation_states[][4] = {
+static const char afs_vlocation_states[][4] = {
 	[AFS_VL_NEW]			= "New",
 	[AFS_VL_CREATING]		= "Crt",
 	[AFS_VL_VALID]			= "Val",
--- linux-2.6.22-rc3-mm1/fs/afs/rxrpc.c.old	2007-06-05 21:50:05.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/rxrpc.c	2007-06-05 21:50:19.000000000 +0200
@@ -239,7 +239,8 @@
 /*
  * attach the data from a bunch of pages on an inode to a call
  */
-int afs_send_pages(struct afs_call *call, struct msghdr *msg, struct kvec *iov)
+static int afs_send_pages(struct afs_call *call, struct msghdr *msg,
+			  struct kvec *iov)
 {
 	struct page *pages[8];
 	unsigned count, n, loop, offset, to;
--- linux-2.6.22-rc3-mm1/fs/afs/server.c.old	2007-06-05 21:50:45.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/server.c	2007-06-05 21:50:52.000000000 +0200
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-unsigned afs_server_timeout = 10;	/* server timeout in seconds */
+static unsigned afs_server_timeout = 10;	/* server timeout in seconds */
 
 static void afs_reap_server(struct work_struct *);
 
--- linux-2.6.22-rc3-mm1/fs/afs/vlocation.c.old	2007-06-05 21:51:17.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/vlocation.c	2007-06-05 21:51:55.000000000 +0200
@@ -15,8 +15,8 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
-unsigned afs_vlocation_update_timeout = 10 * 60;
+static unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
+static unsigned afs_vlocation_update_timeout = 10 * 60;
 
 static void afs_vlocation_reaper(struct work_struct *);
 static void afs_vlocation_updater(struct work_struct *);
@@ -335,7 +335,7 @@
 /*
  * queue a vlocation record for updates
  */
-void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
+static void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
 {
 	struct afs_vlocation *xvl;
 
--- linux-2.6.22-rc3-mm1/fs/afs/write.c.old	2007-06-05 21:52:28.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/afs/write.c	2007-06-05 21:52:38.000000000 +0200
@@ -510,9 +510,9 @@
 /*
  * write a region of pages back to the server
  */
-int afs_writepages_region(struct address_space *mapping,
-			  struct writeback_control *wbc,
-			  pgoff_t index, pgoff_t end, pgoff_t *_next)
+static int afs_writepages_region(struct address_space *mapping,
+				 struct writeback_control *wbc,
+				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct afs_writeback *wb;

