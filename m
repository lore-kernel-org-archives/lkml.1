Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYC3X2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYC3X2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbYC3X2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:28:37 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59139 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYC3X2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:28:36 -0400
Date: Mon, 31 Mar 2008 02:28:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make dm_{,un}register_dirty_log_type() static
Message-ID: <20080330232824.GV28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global dm_{,un}register_dirty_log_type() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/md/dm-log.c |    6 ++----
 drivers/md/dm-log.h |    3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

5d0ca5f52a1c756246411406890c10b2d5cdd081 diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 2a74b21..0d65cc7 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -17,7 +17,7 @@
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
-int dm_register_dirty_log_type(struct dirty_log_type *type)
+static int dm_register_dirty_log_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	type->use_count = 0;
@@ -27,7 +27,7 @@ int dm_register_dirty_log_type(struct dirty_log_type *type)
 	return 0;
 }
 
-int dm_unregister_dirty_log_type(struct dirty_log_type *type)
+static int dm_unregister_dirty_log_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 
@@ -782,7 +782,5 @@ void dm_dirty_log_exit(void)
 	dm_unregister_dirty_log_type(&_core_type);
 }
 
-EXPORT_SYMBOL(dm_register_dirty_log_type);
-EXPORT_SYMBOL(dm_unregister_dirty_log_type);
 EXPORT_SYMBOL(dm_create_dirty_log);
 EXPORT_SYMBOL(dm_destroy_dirty_log);
diff --git a/drivers/md/dm-log.h b/drivers/md/dm-log.h
index 3fae87e..c45fc25 100644
--- a/drivers/md/dm-log.h
+++ b/drivers/md/dm-log.h
@@ -110,9 +110,6 @@ struct dirty_log_type {
 		      char *result, unsigned int maxlen);
 };
 
-int dm_register_dirty_log_type(struct dirty_log_type *type);
-int dm_unregister_dirty_log_type(struct dirty_log_type *type);
-
 
 /*
  * Make sure you use these two functions, rather than calling

