Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbXIKS72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbXIKS72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbXIKS7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:59:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061AbXIKS67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:58:59 -0400
Date: Tue, 11 Sep 2007 14:58:17 -0400 (EDT)
Message-Id: <20070911.145817.80035153.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 06/27] blk_end_request: changing DAC960 (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts DAC960 to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/DAC960.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 05-um-caller-change/drivers/block/DAC960.c 06-dac960-caller-change/drivers/block/DAC960.c
--- 05-um-caller-change/drivers/block/DAC960.c	2007-09-10 17:32:11.000000000 -0400
+++ 06-dac960-caller-change/drivers/block/DAC960.c	2007-09-10 18:00:55.000000000 -0400
@@ -3460,10 +3460,7 @@ static inline bool DAC960_ProcessComplet
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
 
-	 if (!end_that_request_first(Request, UpToDate, Command->BlockCount)) {
-		add_disk_randomness(Request->rq_disk);
- 	 	end_that_request_last(Request, UpToDate);
-
+	 if (!__blk_end_request(Request, UpToDate, Command->BlockCount << 9)) {
 		if (Command->Completion) {
 			complete(Command->Completion);
 			Command->Completion = NULL;
