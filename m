Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbYCFCaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbYCFCaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765487AbYCFCZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:08 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:26847 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762832AbYCFCZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pV9ad22muC4h/tZ8QgPgVWBcfG1GJkmCLq5ZOibegm0L/HJ4gICyKRvou0rQMs+AjGU6cso+hOPd4WfZom30k9RsS59Gck5dmDzxDxGA3xBdSUbmeHBTNX9yzJ9XoD5rYmGVLcwYfjBeiIqKVkqA/Loq8pEmKMkHnGEs5P0iqr4=
Subject: [PATCH 08/16] md: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:55 -0800
Message-Id: <1204770295.14154.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/md/dm-uevent.c |   22 +++++++++++-----------
 drivers/md/raid5.c     |   28 ++++++++++++++--------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index 50377e5..6f65883 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -78,7 +78,7 @@ static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
 
 	event = dm_uevent_alloc(md);
 	if (!event) {
-		DMERR("%s: dm_uevent_alloc() failed", __FUNCTION__);
+		DMERR("%s: dm_uevent_alloc() failed", __func__);
 		goto err_nomem;
 	}
 
@@ -86,32 +86,32 @@ static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
 
 	if (add_uevent_var(&event->ku_env, "DM_TARGET=%s", ti->type->name)) {
 		DMERR("%s: add_uevent_var() for DM_TARGET failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_ACTION=%s", dm_action)) {
 		DMERR("%s: add_uevent_var() for DM_ACTION failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_SEQNUM=%u",
 			   dm_next_uevent_seq(md))) {
 		DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_PATH=%s", path)) {
-		DMERR("%s: add_uevent_var() for DM_PATH failed", __FUNCTION__);
+		DMERR("%s: add_uevent_var() for DM_PATH failed", __func__);
 		goto err_add;
 	}
 
 	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
 			   nr_valid_paths)) {
 		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
-		      __FUNCTION__);
+		      __func__);
 		goto err_add;
 	}
 
@@ -146,25 +146,25 @@ void dm_send_uevents(struct list_head *events, struct kobject *kobj)
 		if (dm_copy_name_and_uuid(event->md, event->name,
 					  event->uuid)) {
 			DMERR("%s: dm_copy_name_and_uuid() failed",
-			      __FUNCTION__);
+			      __func__);
 			goto uevent_free;
 		}
 
 		if (add_uevent_var(&event->ku_env, "DM_NAME=%s", event->name)) {
 			DMERR("%s: add_uevent_var() for DM_NAME failed",
-			      __FUNCTION__);
+			      __func__);
 			goto uevent_free;
 		}
 
 		if (add_uevent_var(&event->ku_env, "DM_UUID=%s", event->uuid)) {
 			DMERR("%s: add_uevent_var() for DM_UUID failed",
-			      __FUNCTION__);
+			      __func__);
 			goto uevent_free;
 		}
 
 		r = kobject_uevent_env(kobj, event->action, event->ku_env.envp);
 		if (r)
-			DMERR("%s: kobject_uevent_env failed", __FUNCTION__);
+			DMERR("%s: kobject_uevent_env failed", __func__);
 uevent_free:
 		dm_uevent_free(event);
 	}
@@ -187,7 +187,7 @@ void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
 	struct dm_uevent *event;
 
 	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
-		DMERR("%s: Invalid event_type %d", __FUNCTION__, event_type);
+		DMERR("%s: Invalid event_type %d", __func__, event_type);
 		goto out;
 	}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2d6f1a5..c95d0eb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -433,7 +433,7 @@ static void ops_run_io(struct stripe_head *sh)
 
 			bi->bi_bdev = rdev->bdev;
 			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
-				__FUNCTION__, (unsigned long long)sh->sector,
+				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
@@ -520,7 +520,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
@@ -569,7 +569,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = sh->disks; i--; ) {
@@ -600,7 +600,7 @@ static void ops_complete_compute5(void *stripe_head_ref)
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	set_bit(R5_UPTODATE, &tgt->flags);
@@ -625,7 +625,7 @@ ops_run_compute5(struct stripe_head *sh, unsigned long pending)
 	int i;
 
 	pr_debug("%s: stripe %llu block: %d\n",
-		__FUNCTION__, (unsigned long long)sh->sector, target);
+		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
 	for (i = disks; i--; )
@@ -653,7 +653,7 @@ static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	set_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
@@ -670,7 +670,7 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -699,7 +699,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 	 */
 	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -744,7 +744,7 @@ static void ops_complete_postxor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
@@ -757,7 +757,7 @@ static void ops_complete_write(void *stripe_head_ref)
 	struct stripe_head *sh = stripe_head_ref;
 	int disks = sh->disks, i, pd_idx = sh->pd_idx;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -787,7 +787,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* check if prexor is active which means only process blocks
@@ -837,7 +837,7 @@ static void ops_complete_check(void *stripe_head_ref)
 	struct stripe_head *sh = stripe_head_ref;
 	int pd_idx = sh->pd_idx;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
@@ -859,7 +859,7 @@ static void ops_run_check(struct stripe_head *sh)
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
-	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
@@ -1759,7 +1759,7 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 	locked++;
 
 	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
-		__FUNCTION__, (unsigned long long)sh->sector,
+		__func__, (unsigned long long)sh->sector,
 		locked, sh->ops.pending);
 
 	return locked;
-- 
1.5.4.GIT


