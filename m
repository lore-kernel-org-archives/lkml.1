Return-Path: <linux-kernel-owner+w=401wt.eu-S967803AbXEHEaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967803AbXEHEaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967784AbXEHE35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:29:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:45818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780AbXEHE3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:29:51 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 8 May 2007 14:29:29 +1000
Message-Id: <1070508042929.28767@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 003 of 5] md: Remove the slash from the name of a kmem_cache used by raid5.
References: <20070508142718.28571.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


SLUB doesn't like slashes as it wants to use the cache name
as the name of a directory (or symlink) in sysfs.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-05-07 14:36:01.000000000 +1000
+++ ./drivers/md/raid5.c	2007-05-07 15:08:45.000000000 +1000
@@ -931,8 +931,8 @@ static int grow_stripes(raid5_conf_t *co
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5/%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5/%s-alt", mdname(conf->mddev));
+	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
+	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
