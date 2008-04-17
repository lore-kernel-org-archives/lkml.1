Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbYDQBHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbYDQBHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYDQBGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:06:41 -0400
Received: from sous-sol.org ([216.99.217.87]:58720 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbYDQBGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:39 -0400
Message-Id: <20080417010310.097225560@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Brown <neilb@suse.de>
Subject: md: remove the super sysfs attribute from devices in an md array
Content-Disposition: inline; filename=md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: NeilBrown <neilb@suse.de>

upstream commit: 0e82989d95cc46cc58622381eafa54f7428ee679

Exposing the binary blob which is the md 'super-block' via sysfs doesn't
really fit with the whole sysfs model, and ever since commit
8118a859dc7abd873193986c77a8d9bdb877adc8 ("sysfs: fix off-by-one error
in fill_read_buffer()") it doesn't actually work at all (as the size of
the blob is often one page).

(akpm: as in, fs/sysfs/file.c:fill_read_buffer() goes BUG)

So just remove it altogether.  It isn't really useful.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/md.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1847,17 +1847,6 @@ static struct rdev_sysfs_entry rdev_stat
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
@@ -1959,7 +1948,6 @@ __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_
 
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
-	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,

-- 
