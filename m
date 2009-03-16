Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZCPC3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZCPC3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZCPC3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:44268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZCPC3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:12 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/17] ide: use blk_run_queue() instead of blk_start_queueing()
Date: Mon, 16 Mar 2009 11:28:44 +0900
Message-Id: <1237170540-19130-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_start_queueing() is being phased out in favor of
[__]blk_run_queue().  Switch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-park.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index c875a95..5f121f7 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -24,11 +24,8 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 			start_queue = 1;
 		spin_unlock_irq(&hwif->lock);
 
-		if (start_queue) {
-			spin_lock_irq(q->queue_lock);
-			blk_start_queueing(q);
-			spin_unlock_irq(q->queue_lock);
-		}
+		if (start_queue)
+			blk_run_queue(q);
 		return;
 	}
 	spin_unlock_irq(&hwif->lock);
-- 
1.6.0.2

