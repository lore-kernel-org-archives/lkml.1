Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbXFGKe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbXFGKe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXFGKeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:34:17 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:42463 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXFGKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:34:16 -0400
Subject: [KJ][PATCH]is_power_of_2-block/rd.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vignesh.babu@wipro.com
To: axboe@kernel.dk, page0588@sundance.sjsu.edu
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Thu, 07 Jun 2007 15:27:39 +0530
Message-Id: <1181210259.11218.0.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
X-OriginalArrivalTime: 07 Jun 2007 09:57:55.0652 (UTC) FILETIME=[5218D040:01C7A8EA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index a1512da..e57f729 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -56,6 +56,7 @@
 #include <linux/backing-dev.h>
 #include <linux/blkpg.h>
 #include <linux/writeback.h>
+#include <linux/log2.h>
 
 #include <asm/uaccess.h>
 
@@ -422,7 +423,7 @@ static int __init rd_init(void)
 	int err = -ENOMEM;
 
 	if (rd_blocksize > PAGE_SIZE || rd_blocksize < 512 ||
-			(rd_blocksize & (rd_blocksize-1))) {
+			!is_power_of_2(rd_blocksize)) {
 		printk("RAMDISK: wrong blocksize %d, reverting to defaults\n",
 		       rd_blocksize);
 		rd_blocksize = BLOCK_SIZE;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

