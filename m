Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbXIBCrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbXIBCrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbXIBCq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:46:59 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:39994 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbXIBCq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:46:58 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/5] Use wake_up_locked() in eventpoll
Date: Sat,  1 Sep 2007 22:46:50 -0400
Message-Id: <11887012141237-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <20070902024348.GJ14130@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the uses of __wake_up_locked with wake_up_locked

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 fs/eventpoll.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 77b9953..72e4cb4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -657,8 +657,7 @@ is_linked:
 	 * wait list.
 	 */
 	if (waitqueue_active(&ep->wq))
-		__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-				 TASK_INTERRUPTIBLE);
+		wake_up_locked(&ep->wq);
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
@@ -781,7 +780,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
-			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
+			wake_up_locked(&ep->wq);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
@@ -855,8 +854,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
-				__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-						 TASK_INTERRUPTIBLE);
+				wake_up_locked(&ep->wq);
 			if (waitqueue_active(&ep->poll_wait))
 				pwake++;
 		}
@@ -979,8 +977,7 @@ errxit:
 		 * wait list (delayed after we release the lock).
 		 */
 		if (waitqueue_active(&ep->wq))
-			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-					 TASK_INTERRUPTIBLE);
+			wake_up_locked(&ep->wq);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
-- 
1.4.4.2

