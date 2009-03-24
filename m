Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbZCXQIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbZCXQIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbZCXQGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:41800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760406AbZCXQGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:31 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] ide: use blk_run_queue() instead of blk_start_queueing()
Date: Wed, 25 Mar 2009 01:06:06 +0900
Message-Id: <1237910776-10983-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_start_queueing() is being phased out in favor of
[__]blk_run_queue().  Switch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-park.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 9490b44..31d3d32 100644
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

