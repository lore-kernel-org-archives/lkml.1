Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYD2DgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYD2DgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYD2De7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:34:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:36609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbYD2Deo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:34:44 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 13:35:00 +1000
Message-Id: <1080429033500.20337@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 9] md: Reinitialise more mddev fields in do_md_stop.
References: <20080429133104.20146.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I keep finding problems where an mddev gets reused and some fields
has a value from a previous usage that confuses the new usage.  So
clear all fields that could possible need clearing when calling do_md_stop.

Also initialise the 'level' of a new array to LEVEL_NONE (which isn't 0).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
@@ -276,6 +276,7 @@ static mddev_t * mddev_find(dev_t unit)
 	init_waitqueue_head(&new->sb_wait);
 	new->reshape_position = MaxSector;
 	new->resync_max = MaxSector;
+	new->level = LEVEL_NONE;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -3713,6 +3714,30 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
 		mddev->persistent = 0;
+		mddev->level = LEVEL_NONE;
+		mddev->clevel[0] = 0;
+		mddev->flags = 0;
+		mddev->ro = 0;
+		mddev->metadata_type[0] = 0;
+		mddev->chunk_size = 0;
+		mddev->ctime = mddev->utime = 0;
+		mddev->layout = 0;
+		mddev->max_disks = 0;
+		mddev->events = 0;
+		mddev->delta_disks = 0;
+		mddev->new_level = LEVEL_NONE;
+		mddev->new_layout = 0;
+		mddev->new_chunk = 0;
+		mddev->curr_resync = 0;
+		mddev->resync_mismatches = 0;
+		mddev->suspend_lo = mddev->suspend_hi = 0;
+		mddev->sync_speed_min = mddev->sync_speed_max = 0;
+		mddev->recovery = 0;
+		mddev->in_sync = 0;
+		mddev->changed = 0;
+		mddev->degraded = 0;
+		mddev->barriers_work = 0;
+		mddev->safemode = 0;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
