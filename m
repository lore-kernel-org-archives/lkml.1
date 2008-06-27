Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYF0GwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYF0GwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYF0Gtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:49:52 -0400
Received: from mail.suse.de ([195.135.220.2]:46682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYF0Gtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:49:51 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:49:43 +1000
Message-Id: <1080627064943.10337@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Nikanth Karthikesan" <knikanth@novell.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 004 of 29] md: linear: correct disk numbering error check
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Nikanth Karthikesan" <knikanth@novell.com>

Correct disk numbering problem check.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/linear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2008-06-27 15:19:55.000000000 +1000
+++ ./drivers/md/linear.c	2008-06-27 15:31:20.000000000 +1000
@@ -126,7 +126,7 @@ static linear_conf_t *linear_conf(mddev_
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
-		if (j < 0 || j > raid_disks || disk->rdev) {
+		if (j < 0 || j >= raid_disks || disk->rdev) {
 			printk("linear: disk numbering problem. Aborting!\n");
 			goto out;
 		}
