Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0BAPOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:14:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:35883 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab0BAPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:14:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pnrHUKe2Z6pCI7+8nTEZri+8CT7J//hkb3I/L5IjfN/dAwiFgv09FrK8/ba2qlLdnX
         5DJwfxJo9TcOl/TtFAOSXEg7PdMhUTb09qixdIyDJXgyKuZPomxRoaZUu/7Zc06BPx84
         B/wg1AuFXo+bfFh9ubN0fyW2PnxAUIB2inyCM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/9] sched: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:34 +0900
Message-Id: <1265037040-23413-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: rename for_each_bit to for_each_set_bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_cpupri.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 597b330..82095bf 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -47,9 +47,7 @@ static int convert_prio(int prio)
 }
 
 #define for_each_cpupri_active(array, idx)                    \
-  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
-       idx < CPUPRI_NR_PRIORITIES;                            \
-       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+	for_each_set_bit(idx, array, CPUPRI_NR_PRIORITIES)
 
 /**
  * cpupri_find - find the best (lowest-pri) CPU in the system
-- 
1.6.0.6

