Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbXAYFGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbXAYFGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933249AbXAYFGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:06:42 -0500
Received: from ns.suse.de ([195.135.220.2]:46736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbXAYFGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:06:40 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Thu, 25 Jan 2007 16:06:16 +1100
Message-Id: <1070125050616.21497@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md: Remove unnecessary printk when raid5 gets an unaligned read.
References: <20070125160528.21465.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more... (sorry about the dribs-and-drabs approach)
NeilBrown


### Comments for Changeset

raid5_mergeable_bvec tries to ensure that raid5 never sees a read
request that does not fit within just one chunk.  However as we
must always accept a single-page read, that is not always possible.

So when "in_chunk_boundary" fails, it might be unusual, but it is not
a problem and printing a message every time is a bad idea.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-01-25 15:57:56.000000000 +1100
+++ ./drivers/md/raid5.c	2007-01-25 15:55:43.000000000 +1100
@@ -2630,7 +2630,7 @@ static int chunk_aligned_read(request_qu
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		printk("chunk_aligned_read : non aligned\n");
+		PRINTK("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
