Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYF0Gzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYF0Gzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbYF0Guz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:50:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:43210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbYF0Guv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:50:51 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:50:44 +1000
Message-Id: <1080627065044.10508@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 013 of 29] md: Don't reject HOT_REMOVE_DISK request for an array that is not yet started.
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is really no need for this test here, and there are valid
cases for selectively removing devices from an array that
it not actually active.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ---
 1 file changed, 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:20:38.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:01.000000000 +1000
@@ -4300,9 +4300,6 @@ static int hot_remove_disk(mddev_t * mdd
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 
-	if (!mddev->pers)
-		return -ENODEV;
-
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENXIO;
