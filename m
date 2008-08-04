Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbYHDU4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbYHDU4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYHDU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:56:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbYHDU4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:56:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: kerneldoc fix
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080804205601.4C6ED154252@magilla.localdomain>
Date: Mon,  4 Aug 2008 13:56:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My last change to tracehook.h made it confuse the kerneldoc parser.
Move the #define's before the comment so it's happy again.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 1253283..ab3ef7a 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -487,6 +487,9 @@ static inline int tracehook_notify_jctl(int notify, int why)
 	return notify || (current->ptrace & PT_PTRACED);
 }
 
+#define DEATH_REAP			-1
+#define DEATH_DELAYED_GROUP_LEADER	-2
+
 /**
  * tracehook_notify_death - task is dead, ready to notify parent
  * @task:		@current task now exiting
@@ -501,8 +504,6 @@ static inline int tracehook_notify_jctl(int notify, int why)
  *
  * Called with write_lock_irq(&tasklist_lock) held.
  */
-#define DEATH_REAP			-1
-#define DEATH_DELAYED_GROUP_LEADER	-2
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
