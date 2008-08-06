Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYHFNcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYHFNcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYHFNae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:30:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:48163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311AbYHFNad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:30:33 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Subject: [PATCH 3/3] Fix lockdep warning
Message-Id: <20080806133031.D6BB7BC11C@pingi.kke.suse.de>
Date: Wed,  6 Aug 2008 15:30:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use correct dynamic spinlock init function.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/tei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.6.4

