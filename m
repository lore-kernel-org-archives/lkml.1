Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZIPN14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZIPN14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZIPN1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:27:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57948 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZIPNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:49 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/16] writeback: use schedule_timeout_interruptible()
Date: Wed, 16 Sep 2009 15:24:50 +0200
Message-Id: <1253107494-20160-13-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of a manual set_current_state().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 55f0d4e..3475775 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -884,8 +884,7 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		}
 
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(wait_jiffies);
+		schedule_timeout_interruptible(wait_jiffies);
 		try_to_freeze();
 	}
 
-- 
1.6.4.1.207.g68ea

