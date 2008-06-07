Return-Path: <linux-kernel-owner+w=401wt.eu-S1763843AbYFGBVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763843AbYFGBVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbYFGBJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:34 -0400
Received: from sous-sol.org ([216.99.217.87]:42518 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375AbYFGBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:23 -0400
Message-Id: <20080607010635.472492057@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:03:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>
Subject: [patch 47/50] md: fix uninitialized use of mddev->recovery_wait
Content-Disposition: inline; filename=md-fix-uninitialized-use-of-mddev-recovery_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

upstream commit: a6d8113a986c66aeb379a26b6e0062488b3e59e1

If an array was created with --assume-clean we will oops when trying to
set ->resync_max.

Fix this by initializing ->recovery_wait in mddev_find.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -274,6 +274,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
+	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
 	new->resync_max = MaxSector;
 
@@ -5559,7 +5560,6 @@ void md_do_sync(mddev_t *mddev)
 		window/2,(unsigned long long) max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
-	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
 	if (j>2) {

-- 
