Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYCNEiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYCNEiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 00:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYCNEig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 00:38:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:40865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYCNEif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 00:38:35 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Mar 2008 15:38:25 +1100
Message-Id: <1080314043825.11111@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md: Remove the 'super' sysfs attribute from devices in an 'md' array.
References: <20080314153739.11056.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Exposing the binary blob which is the md 'super-block' via sysfs
doesn't really fit with the sysfs model, and since commit
   8118a859dc7abd873193986c77a8d9bdb877adc8
it doesn't actually work at all (as the size of the blob is often one page).

So just remove it altogether.  It isn't really useful.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   12 ------------
 1 file changed, 12 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-03-14 15:16:48.000000000 +1100
+++ ./drivers/md/md.c	2008-03-14 15:18:12.000000000 +1100
@@ -1864,17 +1864,6 @@ static struct rdev_sysfs_entry rdev_stat
 __ATTR(state, S_IRUGO|S_IWUSR, state_show, state_store);
 
 static ssize_t
-super_show(mdk_rdev_t *rdev, char *page)
-{
-	if (rdev->sb_loaded && rdev->sb_size) {
-		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
-		return rdev->sb_size;
-	} else
-		return 0;
-}
-static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
-
-static ssize_t
 errors_show(mdk_rdev_t *rdev, char *page)
 {
 	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
@@ -2060,7 +2049,6 @@ __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_
 
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
-	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
