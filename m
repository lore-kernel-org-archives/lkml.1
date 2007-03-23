Return-Path: <linux-kernel-owner+w=401wt.eu-S934269AbXCWBKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269AbXCWBKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbXCWBKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:10:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934266AbXCWBKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:10:16 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 12:10:10 +1100
Message-Id: <1070323011010.5928@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 3] md: Allow raid4 arrays to be reshaped.
References: <20070323120828.5793.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


All that is missing the the function pointers in raid4_pers.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++++
 1 file changed, 4 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-23 11:13:29.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-23 11:13:29.000000000 +1100
@@ -4727,6 +4727,10 @@ static struct mdk_personality raid4_pers
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+#ifdef CONFIG_MD_RAID5_RESHAPE
+	.check_reshape	= raid5_check_reshape,
+	.start_reshape  = raid5_start_reshape,
+#endif
 	.quiesce	= raid5_quiesce,
 };
 
