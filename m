Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZDPCjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZDPCjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZDPCjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:39:03 -0400
Received: from ozlabs.org ([203.10.76.45]:51253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZDPCjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:39:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: trivial@kernel.org
Subject: cpuhotplug: remove cpu_hotplug_init()
Date: Thu, 16 Apr 2009 12:08:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161208.57282.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

cpu_hotplug_init() is almost equal to a dummy function,
this patch remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpu.h |    5 -----
 init/main.c         |    1 -
 kernel/cpu.c        |   11 +++--------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -69,7 +69,6 @@ static inline void unregister_cpu_notifi
 
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
-extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
@@ -81,10 +80,6 @@ static inline int register_cpu_notifier(
 }
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
-{
-}
-
-static inline void cpu_hotplug_init(void)
 {
 }
 
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -647,7 +647,6 @@ asmlinkage void __init start_kernel(void
 	page_cgroup_init();
 	mem_init();
 	enable_debug_pagealloc();
-	cpu_hotplug_init();
 	kmem_cache_init();
 	kmemtrace_init();
 	debug_objects_mem_init();
diff --git a/kernel/cpu.c b/kernel/cpu.c
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -34,14 +34,9 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
-} cpu_hotplug;
-
-void __init cpu_hotplug_init(void)
-{
-	cpu_hotplug.active_writer = NULL;
-	mutex_init(&cpu_hotplug.lock);
-	cpu_hotplug.refcount = 0;
-}
+} cpu_hotplug = {
+	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
+};
 
 #ifdef CONFIG_HOTPLUG_CPU
 
