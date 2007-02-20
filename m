Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXBTGgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXBTGgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932853AbXBTGf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:35:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:58923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbXBTGfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:35:50 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Feb 2007 17:35:05 +1100
Message-Id: <1070220063505.16178@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 6] md: Clean out unplug and other queue function on md shutdown
References: <20070220172544.15678.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The mddev and queue might be used for another array which does not
set these, so they need to be cleared.

Signed-off-by: NeilBrown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-02-20 17:13:54.000000000 +1100
+++ ./drivers/md/md.c	2007-02-20 17:13:08.000000000 +1100
@@ -3322,6 +3322,9 @@ static int do_md_stop(mddev_t * mddev, i
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);
 			mddev->pers->stop(mddev);
+			mddev->queue->merge_bvec_fn = NULL;
+			mddev->queue->unplug_fn = NULL;
+			mddev->queue->issue_flush_fn = NULL;
 			if (mddev->pers->sync_request)
 				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
 
