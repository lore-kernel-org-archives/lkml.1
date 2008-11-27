Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYK0CyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYK0CyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYK0Cxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:53:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYK0Cxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:53:51 -0500
Message-Id: <20081127025349.652180608@goodmis.org>
References: <20081127025227.026028481@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 21:52:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/1] ring-buffer: prevent recursion
Content-Disposition: inline; filename=0001-ring-buffer-prevent-recursion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: fix to recursion in function tracer with schedule

If the resched flag was set before we entered, then don't reschedule.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.6.5

-- 
