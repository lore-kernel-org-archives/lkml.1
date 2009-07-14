Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZGNHfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZGNHfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZGNHfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:35:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZGNHfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:35:05 -0400
Message-ID: <4A5C3549.7000905@cn.fujitsu.com>
Date: Tue, 14 Jul 2009 15:35:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] ring_buffer: fix warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kernel/trace/ring_buffer.c: In function 'rb_tail_page_update':
kernel/trace/ring_buffer.c:849: warning: value computed is not used
kernel/trace/ring_buffer.c:850: warning: value computed is not used

Add a "(void)" to fix this warning.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e648ba4..d371279 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -846,8 +846,8 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
 		 * not come in and change it. In which case, we
 		 * do not want to modify it.
 		 */
-		local_cmpxchg(&next_page->write, old_write, val);
-		local_cmpxchg(&next_page->entries, old_entries, eval);
+		(void)local_cmpxchg(&next_page->write, old_write, val);
+		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
 
 		/*
 		 * No need to worry about races with clearing out the commit.


