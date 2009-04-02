Return-Path: <linux-kernel-owner+w=401wt.eu-S935223AbZDBGUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935223AbZDBGUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934915AbZDBGUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:20:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50938 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbZDBGUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:20:15 -0400
Message-ID: <49D458B1.5000703@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 14:18:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing: mark get_parent_ip() notrace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: remove redundancy tracing log

When tracer is "function" or "function_graph", too much
"get_parent_ip" are recorded in ring_buffer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 706517c..a0ec10c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4860,7 +4860,7 @@ void scheduler_tick(void)
 #endif
 }
 
-unsigned long get_parent_ip(unsigned long addr)
+notrace unsigned long get_parent_ip(unsigned long addr)
 {
 	if (in_lock_functions(addr)) {
 		addr = CALLER_ADDR2;


