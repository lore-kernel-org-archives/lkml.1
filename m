Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbZIPIyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbZIPIyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZIPIx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:53:59 -0400
Received: from mail-px0-f176.google.com ([209.85.216.176]:65457 "EHLO
	mail-px0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZIPIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:53:58 -0400
X-Greylist: delayed 1814 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 04:53:58 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=g0cYFFxrc35xj3EBlk97OcMG7AbeEhuhqmbsi7NTQX9SsgU+fIYdaB/E5E2WvyeeJR
         6EONIKaDFUWcXHlic5Z249wvP2L3Duptk7NzczIryDvzeASGOYluK9bOmzyzh55KqGO0
         1OFSu56+F3snxYXUuvq8OPsyMtmZPaL+Gifxs=
From: Jinzc <zhenchengjin@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jinzc <zhenchengjin@gmail.com>
Subject: [PATCH] md: set the md raid 4,5,6  thead name by its level
Date: Wed, 16 Sep 2009 16:54:57 +0800
Message-Id: <1253091297-3889-1-git-send-email-zhenchengjin@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the current edition, if you create a md raid 4,5,6
the name of md thread is mdx_raid5. If you create a raid 4,6
the name mdx_raid4, mdx_raid6 are better than mdx_raid5.

Signed-off-by: Jinzc <zhenchengjin@gmail.com>
---
 drivers/md/raid5.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b8a2c5d..f78f711 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4334,6 +4334,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	int raid_disk, memory;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
+	char thread_name[64];
 
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
@@ -4447,10 +4448,12 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
 			memory, mdname(mddev));
 
-	conf->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	sprintf(thread_name, "%%s_raid%d", conf->level);
+	conf->thread = md_register_thread(raid5d, mddev, thread_name);
+
 	if (!conf->thread) {
 		printk(KERN_ERR
-		       "raid5: couldn't allocate thread for %s\n",
+		       "raid%d: couldn't allocate thread for %s\n", conf->level,
 		       mdname(mddev));
 		goto abort;
 	}
-- 
1.6.1.3

