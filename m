Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXJOEfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXJOEfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXJOEee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:34:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:51154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbXJOEed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:34:33 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Oct 2007 14:34:25 +1000
Message-Id: <1071015043425.5436@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 5] md: Fix a bug in some never-used code.
References: <20071015143136.5200.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


http://bugzilla.kernel.org/show_bug.cgi?id=3277

There is a seq_printf here that isn't being passed a 'seq'.
Howeve as the code is inside #ifdef MD_DEBUG, nobody noticed.

Also remove some extra spaces.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid0.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-10-15 14:05:58.000000000 +1000
+++ ./drivers/md/raid0.c	2007-10-15 14:06:05.000000000 +1000
@@ -472,7 +472,7 @@ bad_map:
 	bio_io_error(bio);
 	return 0;
 }
-			   
+
 static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG
@@ -480,18 +480,18 @@ static void raid0_status (struct seq_fil
 	int j, k, h;
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-  
+
 	h = 0;
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		seq_printf(seq, "      z%d", j);
 		if (conf->hash_table[h] == conf->strip_zone+j)
-			seq_printf("(h%d)", h++);
+			seq_printf(seq, "(h%d)", h++);
 		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			seq_printf (seq, "%s/", bdevname(
+			seq_printf(seq, "%s/", bdevname(
 				conf->strip_zone[j].dev[k]->bdev,b));
 
-		seq_printf (seq, "] zo=%d do=%d s=%d\n",
+		seq_printf(seq, "] zo=%d do=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,
 				conf->strip_zone[j].dev_offset,
 				conf->strip_zone[j].size);
