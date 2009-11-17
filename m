Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZKQHRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZKQHRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZKQHRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:17:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58456 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZKQHRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:17:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] mmc: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117161711.3DDA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:17:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: linux-mmc@vger.kernel.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/mmc/card/queue.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 49e5823..5deb996 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -46,8 +46,6 @@ static int mmc_queue_thread(void *d)
 	struct mmc_queue *mq = d;
 	struct request_queue *q = mq->queue;
 
-	current->flags |= PF_MEMALLOC;
-
 	down(&mq->thread_sem);
 	do {
 		struct request *req = NULL;
-- 
1.6.2.5



