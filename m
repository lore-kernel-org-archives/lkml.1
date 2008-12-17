Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1750865AbYLQJw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865AbYLQJw0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbYLQJv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:51:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56476 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756274AbYLQJv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:51:56 -0500
Message-ID: <4948CAE7.107@cn.fujitsu.com>
Date: Wed, 17 Dec 2008 17:48:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: remove unused ring_buffer size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct ring_buffer.size is not set after ring_buffer is initialized
or resized. it is always 0.

we can use "buffer->pages * BUF_PAGE_SIZE" to get ring_buffer's size

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 668bbb5..7c7ec06 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -202,7 +202,6 @@ struct ring_buffer_per_cpu {
 };
 
 struct ring_buffer {
-	unsigned long			size;
 	unsigned			pages;
 	unsigned			flags;
 	int				cpus;
@@ -2090,8 +2089,7 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 		return -EINVAL;
 
 	/* At least make sure the two buffers are somewhat the same */
-	if (buffer_a->size != buffer_b->size ||
-	    buffer_a->pages != buffer_b->pages)
+	if (buffer_a->pages != buffer_b->pages)
 		return -EINVAL;
 
 	cpu_buffer_a = buffer_a->buffers[cpu];



