Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZL3LzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZL3LzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZL3LzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:55:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:63682 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZL3LzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:55:17 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] perf_event: add check for group_list if the parent isn't counted
Date: Wed, 30 Dec 2009 19:28:07 +0800
Message-Id: <1262172487-13694-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 30 Dec 2009 11:54:39.0047 (UTC) FILETIME=[DD81D570:01CA8946]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the parent has no entry in group_list, child_ctx will not be
allocated, which will lead dereference of a NULL child_ctx.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 5b987b4..3664c4b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5126,6 +5126,8 @@ int perf_event_init_task(struct task_struct *child)
 	 */
 	mutex_lock(&parent_ctx->mutex);
 
+	if (list_empty(&parent_ctx->group_list))
+		goto exit;
 	/*
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
-- 
1.6.0.3

