Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbXJVHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbXJVHQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbXJVHPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:15:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:43246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbXJVHPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:15:50 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Oct 2007 17:15:43 +1000
Message-Id: <1071022071543.31256@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Stable <stable@kernel.org>
Subject: [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
References: <20071022171426.31103.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As page->index is unsigned, this all becomes an unsigned comparison, which
 almost always returns an error.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Stable <stable@kernel.org>

### Diffstat output
 ./drivers/md/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-10-22 16:55:48.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-10-22 16:55:52.000000000 +1000
@@ -274,7 +274,7 @@ static int write_sb_page(struct bitmap *
 			if (bitmap->offset < 0) {
 				/* DATA  BITMAP METADATA  */
 				if (bitmap->offset
-				    + page->index * (PAGE_SIZE/512)
+				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					return -EINVAL;
