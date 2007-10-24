Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXJXV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXJXV0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXJXV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:26:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbXJXV0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:26:05 -0400
Message-ID: <471FB86A.2060609@ce.jp.nec.com>
Date: Wed, 24 Oct 2007 17:26:02 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: noflush resizing (3/3) Allow table swapping with different
 size
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the check for whether the loaded table
is going to change the device size and allows resizing of
the dm device suspended with 'noflush'.


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 dm.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.23.work/drivers/md/dm.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm.c
+++ linux-2.6.23.work/drivers/md/dm.c
@@ -1288,11 +1288,6 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
-	/* without bdev, the device size cannot be changed */
-	if (!md->suspended_bdev)
-		if (get_capacity(md->disk) != dm_table_get_size(table))
-			goto out;
-
 	__unbind(md);
 	r = __bind(md, table);
 
