Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZEVAOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZEVAOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZEVAOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:14:00 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42595 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZEVAN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:13:59 -0400
Message-Id: <6.0.0.20.2.20090522090831.0709b9d0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Fri, 22 May 2009 09:09:25 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND][PATCH] readahead:add blk_run_backing_dev
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.
Following patch improves sequential read performance and does not harm
other performance.
Please merge my patch.
Comments?
Thanks.

#dd if=testdir/testfile of=/dev/null bs=16384
-2.6.30-rc6
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s

-2.6.30-rc6-patched
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.30-rc6.org/mm/readahead.c linux-2.6.30-rc6.unplug/mm/readahead.c
--- linux-2.6.30-rc6.org/mm/readahead.c	2009-05-18 10:46:15.000000000 +0900
+++ linux-2.6.30-rc6.unplug/mm/readahead.c	2009-05-18 13:00:42.000000000 +0900
@@ -490,5 +490,7 @@ page_cache_async_readahead(struct addres
 
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+
+	blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);

