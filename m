Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYLJTkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYLJTkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYLJTkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:40:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbYLJTke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:40:34 -0500
Date: Wed, 10 Dec 2008 14:40:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Karsten Keil <kkeil@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] use rwlock runtime init for drivers/isdn/mISDN/tei.c
Message-ID: <alpine.DEB.1.10.0812101438520.11805@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: cleanups


Steven Rostedt (1):
      use rwlock runtime init for drivers/isdn/mISDN/tei.c

----
 drivers/isdn/mISDN/tei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 30bb0d7d6956526eedb5ad30b9d6ff085801d788
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 10 14:25:23 2008 -0500

    use rwlock runtime init for drivers/isdn/mISDN/tei.c
    
    Impact: clean up
    
    __RW_LOCK_UNLOCKED(lock) is meant for compile time initializations.
    rwlock_init(&lock) is used for run time initialization.
    
    This patch converts drivers/isdn/mISDN/tei.c to initialize the
    mrg->lock rwlock.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 6fbae42..d8af45c 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -1287,7 +1287,7 @@ create_teimanager(struct mISDNdevice *dev)
 	if (!mgr)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&mgr->layer2);
-	mgr->lock = __RW_LOCK_UNLOCKED(mgr->lock);
+	rwlock_init(&mgr->lock);
 	skb_queue_head_init(&mgr->sendq);
 	mgr->nextid = 1;
 	mgr->lastid = MISDN_ID_NONE;

