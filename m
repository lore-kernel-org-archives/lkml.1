Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbXJXMZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbXJXMZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXJXMY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:24:58 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:59404 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbXJXMY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:24:57 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/5] Use wake_up_locked() in eventpoll
Date: Wed, 24 Oct 2007 08:24:54 -0400
Message-Id: <11932286982175-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the uses of __wake_up_locked with wake_up_locked

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/eventpoll.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 34f68f3..81c04ab 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -656,8 +656,7 @@ is_linked:
 	 * wait list.
 	 */
 	if (waitqueue_active(&ep->wq))
-		__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-				 TASK_INTERRUPTIBLE);
+		wake_up_locked(&ep->wq);
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
@@ -780,7 +779,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
-			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
+			wake_up_locked(&ep->wq);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
@@ -854,8 +853,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
-				__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-						 TASK_INTERRUPTIBLE);
+				wake_up_locked(&ep->wq);
 			if (waitqueue_active(&ep->poll_wait))
 				pwake++;
 		}
@@ -978,8 +976,7 @@ errxit:
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

