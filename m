Return-Path: <linux-kernel-owner+w=401wt.eu-S936331AbYD1Pny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936331AbYD1Pny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964945AbYD1Pjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35018 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938AbYD1Pjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:39 -0400
Date: Mon, 28 Apr 2008 18:39:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Heinz Mauelshagen <hjm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make dm_dirty_log_{init,exit}() static
Message-ID: <20080428153906.GK2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dm_dirty_log_{init,exit}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/md/dm-log.c |    4 ++--
 drivers/md/dm.h     |    6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

9fc29a7361124f1b56119645584cbe17d59e0e02 diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 67a6f31..5b48478 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -831,7 +831,7 @@ static struct dm_dirty_log_type _disk_type = {
 	.status = disk_status,
 };
 
-int __init dm_dirty_log_init(void)
+static int __init dm_dirty_log_init(void)
 {
 	int r;
 
@@ -848,7 +848,7 @@ int __init dm_dirty_log_init(void)
 	return r;
 }
 
-void __exit dm_dirty_log_exit(void)
+static void __exit dm_dirty_log_exit(void)
 {
 	dm_dirty_log_type_unregister(&_disk_type);
 	dm_dirty_log_type_unregister(&_core_type);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 8c03b63..1e59a0b 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -100,12 +100,6 @@ int dm_lock_for_deletion(struct mapped_device *md);
 
 void dm_kobject_uevent(struct mapped_device *md);
 
-/*
- * Dirty log
- */
-int dm_dirty_log_init(void);
-void dm_dirty_log_exit(void);
-
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
 

