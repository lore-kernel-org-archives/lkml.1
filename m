Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZG1NH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZG1NH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZG1NH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:07:56 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:52444 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZG1NHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:07:55 -0400
Date: Tue, 28 Jul 2009 22:06:23 +0900 (JST)
Message-Id: <20090728.220623.39170303.ryov@valinux.co.jp>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [BUGFIX] index of rq.count[]
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch corrects that the index of rq.count[] should use
BLK_RW_SYNC/BLK_RW_ASYNC instead of READ/WRITE.

Thanks,
Ryo Tsuruta

---
 include/trace/events/block.h |    6 ++++--
 kernel/trace/blktrace.c      |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.31-rc4/kernel/trace/blktrace.c
===================================================================
--- linux-2.6.31-rc4.orig/kernel/trace/blktrace.c
+++ linux-2.6.31-rc4/kernel/trace/blktrace.c
@@ -796,7 +796,8 @@ static void blk_add_trace_unplug_io(stru
 	struct blk_trace *bt = q->blk_trace;
 
 	if (bt) {
-		unsigned int pdu = q->rq.count[READ] + q->rq.count[WRITE];
+		unsigned int pdu =
+			q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC];
 		__be64 rpdu = cpu_to_be64(pdu);
 
 		__blk_add_trace(bt, 0, 0, 0, BLK_TA_UNPLUG_IO, 0,
@@ -809,7 +810,8 @@ static void blk_add_trace_unplug_timer(s
 	struct blk_trace *bt = q->blk_trace;
 
 	if (bt) {
-		unsigned int pdu = q->rq.count[READ] + q->rq.count[WRITE];
+		unsigned int pdu =
+			q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC];
 		__be64 rpdu = cpu_to_be64(pdu);
 
 		__blk_add_trace(bt, 0, 0, 0, BLK_TA_UNPLUG_TIMER, 0,
Index: linux-2.6.31-rc4/include/trace/events/block.h
===================================================================
--- linux-2.6.31-rc4.orig/include/trace/events/block.h
+++ linux-2.6.31-rc4/include/trace/events/block.h
@@ -397,7 +397,8 @@ TRACE_EVENT(block_unplug_timer,
 	),
 
 	TP_fast_assign(
-		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
+		__entry->nr_rq	=
+			q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC];
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -416,7 +417,8 @@ TRACE_EVENT(block_unplug_io,
 	),
 
 	TP_fast_assign(
-		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
+		__entry->nr_rq	=
+			q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC];
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
