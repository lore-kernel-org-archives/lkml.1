Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZDPMc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZDPMc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZDPMb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:31:58 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52743 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757241AbZDPMb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:31:57 -0400
Date: Thu, 16 Apr 2009 21:31:56 +0900 (JST)
Message-Id: <20090416.213156.112612071.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 5/5] bio-cgroup: Add a cgroup support to dm-ioband
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090416.213105.189713999.ryov@valinux.co.jp>
References: <20090416.212931.71100972.ryov@valinux.co.jp>
	<20090416.213019.104045053.ryov@valinux.co.jp>
	<20090416.213105.189713999.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, dm-ioband can work with the bio cgroup.

Based on 2.6.30-rc1
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 drivers/md/dm-ioband-type.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6.30-rc1/drivers/md/dm-ioband-type.c
===================================================================
--- linux-2.6.30-rc1.orig/drivers/md/dm-ioband-type.c
+++ linux-2.6.30-rc1/drivers/md/dm-ioband-type.c
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 #include <linux/bio.h>
+#include <linux/biotrack.h>
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-ioband.h"
@@ -53,14 +54,7 @@ static int ioband_node(struct bio *bio)
 
 static int ioband_cgroup(struct bio *bio)
 {
-	/*
-	 * This function should return the ID of the cgroup which
-	 * issued "bio". The ID of the cgroup which the current
-	 * process belongs to won't be suitable ID for this purpose,
-	 * since some BIOs will be handled by kernel threads like aio
-	 * or pdflush on behalf of the process requesting the BIOs.
-	 */
-	return 0;	/* not implemented yet */
+	return get_bio_cgroup_id(bio);
 }
 
 struct group_type dm_ioband_group_type[] = {
