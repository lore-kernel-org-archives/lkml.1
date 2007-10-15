Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbXJOEgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbXJOEgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXJOEe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:34:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:51164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbXJOEe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:34:56 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Oct 2007 14:34:49 +1000
Message-Id: <1071015043449.5545@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Dan Williams" <dan.j.williams@intel.com>
Subject: [PATCH 005 of 5] md: Fix type that is stopping raid5 grow from working.
References: <20071015143136.5200.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This kmem_cache_create is creating a cache that already exists.  We
could us the alternate name, just like we do a few lines up.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Dan Williams" <dan.j.williams@intel.com>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-10-15 14:12:03.000000000 +1000
+++ ./drivers/md/raid5.c	2007-10-15 14:12:06.000000000 +1000
@@ -1380,7 +1380,7 @@ static int resize_stripes(raid5_conf_t *
 	if (!sc)
 		return -ENOMEM;
 
-	sc_q = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+	sc_q = kmem_cache_create(conf->sq_cache_name[1-conf->active_name],
 			       (sizeof(struct stripe_queue)+(newsize-1) *
 				sizeof(struct r5_queue_dev)) +
 				r5_io_weight_size(newsize) +
