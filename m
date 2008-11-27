Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYK0CY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYK0CY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYK0CYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:24:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYK0CYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:24:50 -0500
Message-ID: <492E043A.9040503@cn.fujitsu.com>
Date: Thu, 27 Nov 2008 10:21:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: prevent recursion
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if the resched flag was set before we entered, then don't reschedule.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f780e95..668bbb5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1215,7 +1215,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 
  out:
 	if (resched)
-		preempt_enable_notrace();
+		preempt_enable_no_resched_notrace();
 	else
 		preempt_enable_notrace();
 	return NULL;


