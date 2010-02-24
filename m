Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0BXIpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:45:32 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:59857 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab0BXIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:44:55 -0500
Message-Id: <20100224084453.685334248@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 09:45:01 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 31/32] [PATCH] dasd: correct offline processing
References: <20100224084430.193562869@de.ibm.com>
Content-Disposition: inline; filename=130-dasd-offlining.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Haberland <stefan.haberland@de.ibm.com>

Flushing the dasd ccw request queue may stop the processing of the
block device request queue. Destroy partitions may wait for
outstanding requests and thus hang. 
Swapping dasd_destroy_partitions and dasd_flush_request_queue so that
the request queue is empty before dasd_destroy_partitions is called.

Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/block/dasd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd.c	2010-02-24 09:44:29.000000000 +0100
+++ quilt-2.6/drivers/s390/block/dasd.c	2010-02-24 09:44:29.000000000 +0100
@@ -323,8 +323,8 @@
 			device->state = DASD_STATE_READY;
 			return rc;
 		}
-		dasd_destroy_partitions(block);
 		dasd_flush_request_queue(block);
+		dasd_destroy_partitions(block);
 		block->blocks = 0;
 		block->bp_block = 0;
 		block->s2b_shift = 0;

