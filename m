Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbXLNG3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbXLNG3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXLNG0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:26:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:54502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbXLNG0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:26:44 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Dec 2007 17:26:41 +1100
Message-Id: <1071214062641.1908@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 006 of 7] md: Allow an md array to appear with 0 drives if it has external metadata.
References: <20071214171950.1308.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-12-14 16:09:03.000000000 +1100
+++ ./drivers/md/md.c	2007-12-14 16:09:09.000000000 +1100
@@ -4650,9 +4650,10 @@ static int md_ioctl(struct inode *inode,
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
 	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
-	if (!mddev->raid_disks && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
-			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
-	    		&& cmd != GET_BITMAP_FILE) {
+	if ((!mddev->raid_disks && !mddev->external)
+	    && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
+	    && cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
+	    && cmd != GET_BITMAP_FILE) {
 		err = -ENODEV;
 		goto abort_unlock;
 	}
