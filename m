Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZIRP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZIRP0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZIRP0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:26:08 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59281 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbZIRP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:26:05 -0400
Message-ID: <4AB3A39E.9080908@ce.jp.nec.com>
Date: Sat, 19 Sep 2009 00:13:34 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
Subject: [PATCH 3/3] dm: Add a remapping trace to request-based dm
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a remapping trace to request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.31.work/drivers/md/dm.c
===================================================================
--- linux-2.6.31.work.orig/drivers/md/dm.c
+++ linux-2.6.31.work/drivers/md/dm.c
@@ -1503,6 +1503,8 @@ static void map_request(struct dm_target
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
+		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+				     blk_rq_pos(tio->orig));
 		dm_dispatch_request(clone);
 		break;
 	case DM_MAPIO_REQUEUE:
