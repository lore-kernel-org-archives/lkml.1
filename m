Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYD2Dfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYD2Dfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbYD2De5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:34:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:57646 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbYD2Deh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:34:37 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 13:34:54 +1000
Message-Id: <1080429033454.20325@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 9] md: Skip all metadata update processing when using external metadata.
References: <20080429133104.20146.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All the metadata update processing for external metadata is on
in user-space or through the sysfs interfaces, so make "md_update_sb"
a no-op in that case.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:55.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
@@ -1651,6 +1651,8 @@ static void md_update_sb(mddev_t * mddev
 	int sync_req;
 	int nospares = 0;
 
+	if (mddev->external)
+		return;
 repeat:
 	spin_lock_irq(&mddev->write_lock);
 
