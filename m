Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbXGKU7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbXGKU7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933147AbXGKU6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:58:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512AbXGKU6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:58:47 -0400
Date: Wed, 11 Jul 2007 21:58:13 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6.23 PATCH 05/18] dm: remove duplicate module name from error msgs
Message-ID: <20070711205813.GW24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

Remove explicit module name from messages as the macro now includes it
automatically.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-mpath.c       |    8 +++-----
 drivers/md/dm-raid1.c       |    5 ++---
 drivers/md/dm-round-robin.c |    2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

Index: linux/drivers/md/dm-mpath.c
===================================================================
--- linux.orig/drivers/md/dm-mpath.c	2007-07-11 21:37:38.000000000 +0100
+++ linux/drivers/md/dm-mpath.c	2007-07-11 21:37:40.000000000 +0100
@@ -1352,15 +1352,14 @@ static int __init dm_multipath_init(void
 
 	r = dm_register_target(&multipath_target);
 	if (r < 0) {
-		DMERR("%s: register failed %d", multipath_target.name, r);
+		DMERR("register failed %d", r);
 		kmem_cache_destroy(_mpio_cache);
 		return -EINVAL;
 	}
 
 	kmultipathd = create_workqueue("kmpathd");
 	if (!kmultipathd) {
-		DMERR("%s: failed to create workqueue kmpathd",
-				multipath_target.name);
+		DMERR("failed to create workqueue kmpathd");
 		dm_unregister_target(&multipath_target);
 		kmem_cache_destroy(_mpio_cache);
 		return -ENOMEM;
@@ -1381,8 +1380,7 @@ static void __exit dm_multipath_exit(voi
 
 	r = dm_unregister_target(&multipath_target);
 	if (r < 0)
-		DMERR("%s: target unregister failed %d",
-		      multipath_target.name, r);
+		DMERR("target unregister failed %d", r);
 	kmem_cache_destroy(_mpio_cache);
 }
 
Index: linux/drivers/md/dm-raid1.c
===================================================================
--- linux.orig/drivers/md/dm-raid1.c	2007-07-11 21:37:32.000000000 +0100
+++ linux/drivers/md/dm-raid1.c	2007-07-11 21:37:40.000000000 +0100
@@ -1335,8 +1335,7 @@ static int __init dm_mirror_init(void)
 
 	r = dm_register_target(&mirror_target);
 	if (r < 0) {
-		DMERR("%s: Failed to register mirror target",
-		      mirror_target.name);
+		DMERR("Failed to register mirror target");
 		dm_dirty_log_exit();
 	}
 
@@ -1349,7 +1348,7 @@ static void __exit dm_mirror_exit(void)
 
 	r = dm_unregister_target(&mirror_target);
 	if (r < 0)
-		DMERR("%s: unregister failed %d", mirror_target.name, r);
+		DMERR("unregister failed %d", r);
 
 	dm_dirty_log_exit();
 }
Index: linux/drivers/md/dm-round-robin.c
===================================================================
--- linux.orig/drivers/md/dm-round-robin.c	2007-07-11 21:37:32.000000000 +0100
+++ linux/drivers/md/dm-round-robin.c	2007-07-11 21:37:40.000000000 +0100
@@ -205,7 +205,7 @@ static void __exit dm_rr_exit(void)
 	int r = dm_unregister_path_selector(&rr_ps);
 
 	if (r < 0)
-		DMERR("round-robin: unregister failed %d", r);
+		DMERR("unregister failed %d", r);
 }
 
 module_init(dm_rr_init);
