Return-Path: <linux-kernel-owner+w=401wt.eu-S1764075AbZFQX1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764075AbZFQX1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbZFQX0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbZFQX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:28 -0400
Message-Id: <20090617232629.878919585@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:25:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/7] ring-buffer: remove useless warn on check
Content-Disposition: inline; filename=0002-ring-buffer-remove-useless-warn-on-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

A check if "write > BUF_PAGE_SIZE" is done right after a

	if (write > BUF_PAGE_SIZE)
		return ...;

Thus the check is actually testing the compiler and not the
kernel. This is useless, remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6b17a11..6cf340e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1334,9 +1334,6 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* We reserved something on the buffer */
 
-	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
-		return NULL;
-
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
 
-- 
1.6.3.1

-- 
