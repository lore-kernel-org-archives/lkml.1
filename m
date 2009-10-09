Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbZJIJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbZJIJbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760546AbZJIJbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:31:16 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52659 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760543AbZJIJbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:31:14 -0400
Subject: [PATCH 1/2] kmemleak: Use GFP_ATOMIC for early_alloc().
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org
Date: Fri, 09 Oct 2009 10:30:28 +0100
Message-ID: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc3-10-g00be
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2009 09:30:28.0934 (UTC) FILETIME=[23C3D660:01CA48C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't use GFP_KERNEL inside rcu_read_lock().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4ea4510..a617518 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -833,7 +833,7 @@ static void early_alloc(struct early_log *log)
 	 */
 	rcu_read_lock();
 	object = create_object((unsigned long)log->ptr, log->size,
-			       log->min_count, GFP_KERNEL);
+			       log->min_count, GFP_ATOMIC);
 	spin_lock_irqsave(&object->lock, flags);
 	for (i = 0; i < log->trace_len; i++)
 		object->trace[i] = log->trace[i];

