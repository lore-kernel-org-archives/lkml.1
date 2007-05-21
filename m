Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbXEUBes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbXEUBes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEUBde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:33:34 -0400
Received: from ns.suse.de ([195.135.220.2]:56621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbXEUBdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:33:33 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 21 May 2007 11:33:21 +1000
Message-Id: <1070521013321.6740@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 004 of 7] md: Improve message about invalid superblock during autodetect.
References: <20070521111837.20906.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


People try to use raid auto-detect with version-1 superblocks (which
is not supported) and get confused when they are told they have an
invalid superblock.
So be more explicit, and say it it is not a valid v0.90 superblock.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-21 11:14:54.000000000 +1000
+++ ./drivers/md/md.c	2007-05-21 11:16:16.000000000 +1000
@@ -2073,9 +2073,11 @@ static mdk_rdev_t *md_import_device(dev_
 		err = super_types[super_format].
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
-			printk(KERN_WARNING 
-				"md: %s has invalid sb, not importing!\n",
-				bdevname(rdev->bdev,b));
+			printk(KERN_WARNING
+				"md: %s does not have a valid v%d.%d "
+			       "superblock, not importing!\n",
+				bdevname(rdev->bdev,b),
+			       super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
@@ -5772,7 +5774,7 @@ static void autostart_arrays(int part)
 	for (i = 0; i < dev_cnt; i++) {
 		dev_t dev = detected_devices[i];
 
-		rdev = md_import_device(dev,0, 0);
+		rdev = md_import_device(dev,0, 90);
 		if (IS_ERR(rdev))
 			continue;
 
