Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZCMCky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZCMCky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbZCMCic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47223 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023825.459094605@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 03/16] ring-buffer: use CONFIG_HOTPLUG_CPU not CONFIG_HOTPLUG
Content-Disposition: inline; filename=0003-ring-buffer-use-CONFIG_HOTPLUG_CPU-not-CONFIG_HOTPL.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The hotplug code in the ring buffers is for use with CPU hotplug,
not generic hotplug.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d07c288..035b56c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -303,7 +303,7 @@ struct ring_buffer {
 
 	struct ring_buffer_per_cpu	**buffers;
 
-#ifdef CONFIG_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	struct notifier_block		cpu_notify;
 #endif
 };
@@ -464,7 +464,7 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
  */
 extern int ring_buffer_page_too_big(void);
 
-#ifdef CONFIG_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit rb_cpu_notify(struct notifier_block *self,
 				   unsigned long action, void *hcpu);
 #endif
@@ -523,7 +523,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 			goto fail_free_buffers;
 	}
 
-#ifdef CONFIG_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	buffer->cpu_notify.notifier_call = rb_cpu_notify;
 	buffer->cpu_notify.priority = 0;
 	register_cpu_notifier(&buffer->cpu_notify);
@@ -562,7 +562,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	get_online_cpus();
 
-#ifdef CONFIG_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&buffer->cpu_notify);
 #endif
 
@@ -2757,7 +2757,7 @@ static __init int rb_init_debugfs(void)
 
 fs_initcall(rb_init_debugfs);
 
-#ifdef CONFIG_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit rb_cpu_notify(struct notifier_block *self,
 				   unsigned long action, void *hcpu)
 {
-- 
1.6.1.3

-- 
