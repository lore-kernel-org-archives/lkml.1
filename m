Return-Path: <linux-kernel-owner+w=401wt.eu-S944348AbXHMPKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944348AbXHMPKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945468AbXHMMvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:51:41 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:58088 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945635AbXHMMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:51:39 -0400
Subject: [kj] is_power_of_2 in drivers/block/rd.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vigneshbabu@gmail.com
To: axboe@kernel.dk
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Mon, 13 Aug 2007 18:20:57 +0530
Message-Id: <1187009457.7273.1.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 13 Aug 2007 12:51:51.0012 (UTC) FILETIME=[B7BBA240:01C7DDA8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index 65150b5..81821d3 100644
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

