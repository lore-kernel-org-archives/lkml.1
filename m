Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYKMDPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYKMDPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKMDOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:14:55 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50899 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751235AbYKMDOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:14:54 -0500
Date: Thu, 13 Nov 2008 12:15:38 +0900 (JST)
Message-Id: <20081113.121538.598552788702463139.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
Subject: [PATCH 8/8] bio-cgroup: Add a cgroup support to dm-ioband
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20081113.121507.722554765817591488.ryov@valinux.co.jp>
References: <20081113.121357.75173118738921642.ryov@valinux.co.jp>
	<20081113.121433.632868945383117577.ryov@valinux.co.jp>
	<20081113.121507.722554765817591488.ryov@valinux.co.jp>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, dm-ioband can work with the bio cgroup.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

diff -dupr linux-2.6.28-rc2.bc3/drivers/md/dm-ioband-type.c linux-2.6.28-rc2/drivers/md/dm-ioband-type.c
--- linux-2.6.28-rc2.bc3/drivers/md/dm-ioband-type.c	2008-11-12 11:22:19.000000000 +0900
+++ linux-2.6.28-rc2/drivers/md/dm-ioband-type.c	2008-11-12 11:23:18.000000000 +0900
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 #include <linux/bio.h>
+#include <linux/biotrack.h>
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-ioband.h"
@@ -53,13 +54,7 @@ static int ioband_node(struct bio *bio)
 
 static int ioband_cgroup(struct bio *bio)
 {
-  /*
-   * This function should return the ID of the cgroup which issued "bio".
-   * The ID of the cgroup which the current process belongs to won't be
-   * suitable ID for this purpose, since some BIOs will be handled by kernel
-   * threads like aio or pdflush on behalf of the process requesting the BIOs.
-   */
-	return 0;	/* not implemented yet */
+	return get_bio_cgroup_id(bio);
 }
 
 struct group_type dm_ioband_group_type[] = {
