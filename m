Return-Path: <linux-kernel-owner+w=401wt.eu-S1763726AbZFQX0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763726AbZFQX0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZFQX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZFQX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:28 -0400
Message-Id: <20090617232630.249960331@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:25:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/7] ring-buffer: check for less than two in size allocation
Content-Disposition: inline; filename=0004-ring-buffer-check-for-less-than-two-in-size-allocati.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring buffer must have at least two pages allocated for the
reader page swap to work.

The page count check will miss the case of a zero size passed in.
Even though a zero size ring buffer would probably fail an allocation,
making the min size check for less than two instead of equal to one makes
the code a bit more robust.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 162da23..2e99dba 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -657,8 +657,8 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->reader_lock_key = key;
 
 	/* need at least two pages */
-	if (buffer->pages == 1)
-		buffer->pages++;
+	if (buffer->pages < 2)
+		buffer->pages = 2;
 
 	/*
 	 * In case of non-hotplug cpu, if the ring-buffer is allocated
-- 
1.6.3.1

-- 
