Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYCRJb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYCRJb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYCRJbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:31:49 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35310 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbYCRJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:31:48 -0400
Date: Tue, 18 Mar 2008 18:31:48 +0900 (JST)
Message-Id: <20080318.183148.87079095.taka@valinux.co.jp>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: [PATCH 4/4] Block I/O tracking
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080318.182251.93858044.taka@valinux.co.jp>
References: <20080318.182251.93858044.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With this patch, dm-ioband can work with the bio cgroup.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25-rc3.ioload/drivers/md/dm-ioband-type.c	2008-03-13 22:27:45.000000000 +0900
+++ linux-2.6.25-rc3-mm1/drivers/md/dm-ioband-type.c	2008-03-17 15:57:32.000000000 +0900
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 #include <linux/bio.h>
+#include <linux/biocontrol.h>
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-ioband.h"
@@ -57,13 +58,7 @@ static int ioband_node(struct bio *bio)
 
 static int ioband_cgroup(struct bio *bio)
 {
-  /*
-   * This function should return the ID of the cgroup which issued "bio".
-   * The ID of the cgroup which the current process belongs to won't be
-   * suitable ID for this purpose, since some BIOs will be handled by kernel
-   * threads like aio or pdflush on behalf of the process requesting the BIOs.
-   */
-	return 0;	/* not implemented yet */
+	return get_bio_cgroup_id(bio->bi_io_vec[0].bv_page);
 }
 
 struct group_type dm_ioband_group_type[] = {
