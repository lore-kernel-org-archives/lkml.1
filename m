Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbZD1Mrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbZD1Mrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbZD1MrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:47:07 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:40466 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758316AbZD1MrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:47:06 -0400
Date: Tue, 28 Apr 2009 21:47:05 +0900 (JST)
Message-Id: <20090428.214705.112621770.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 6/7] blkio-cgroup: Add a cgroup support to dm-ioband
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090428.214632.189725895.ryov@valinux.co.jp>
References: <20090428.214535.71090234.ryov@valinux.co.jp>
	<20090428.214604.104034341.ryov@valinux.co.jp>
	<20090428.214632.189725895.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, dm-ioband can work with the blkio-cgroup.

Based on 2.6.30-rc3-git3
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 drivers/md/dm-ioband-type.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6.30-rc3-git3/drivers/md/dm-ioband-type.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/drivers/md/dm-ioband-type.c
+++ linux-2.6.30-rc3-git3/drivers/md/dm-ioband-type.c
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 #include <linux/bio.h>
+#include <linux/biotrack.h>
 #include "dm.h"
 #include "dm-ioband.h"
 
@@ -52,14 +53,7 @@ static int ioband_node(struct bio *bio)
 
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
+	return get_blkio_cgroup_id(bio);
 }
 
 struct group_type dm_ioband_group_type[] = {
