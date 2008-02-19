Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbYBSOtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbYBSOtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYBSOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:45:36 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:8124 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYBSOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:45:11 -0500
Message-Id: <20080219144505.490333062@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 15:40:58 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Gerald Schaefer <geraldsc@de.ibm.com>, Stefan Weinhuber <wein@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, Roel Kluin <12o3l@tiscali.nl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 11/13] dcss: Fix Unlikely(x) != y
Content-Disposition: inline; filename=011-dcssblk.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>

Fix Unlikely(x) != y

Cc: Gerald Schaefer <geraldsc@de.ibm.com>
Cc: Stefan Weinhuber <wein@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dcssblk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/block/dcssblk.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dcssblk.c
+++ quilt-2.6/drivers/s390/block/dcssblk.c
@@ -666,7 +666,7 @@ dcssblk_make_request(struct request_queu
 		page_addr = (unsigned long)
 			page_address(bvec->bv_page) + bvec->bv_offset;
 		source_addr = dev_info->start + (index<<12) + bytes_done;
-		if (unlikely(page_addr & 4095) != 0 || (bvec->bv_len & 4095) != 0)
+		if (unlikely((page_addr & 4095) != 0) || (bvec->bv_len & 4095) != 0)
 			// More paranoia.
 			goto fail;
 		if (bio_data_dir(bio) == READ) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

