Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZBQJKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZBQJKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZBQJJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:09:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53983 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZBQJJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:09:42 -0500
Message-ID: <499A7E98.4060001@cn.fujitsu.com>
Date: Tue, 17 Feb 2009 17:08:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuhotplug: remove cpu_hotplug_init()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpu_hotplug_init() is almost equal to a dummy function,
this patch remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/cpu.h |    5 -----
 init/main.c         |    1 -
 kernel/cpu.c        |   11 +++--------
 3 files changed, 3 insertions(+), 14 deletions(-)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c2747ac..7579807 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -70,7 +70,6 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
-extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
@@ -85,10 +84,6 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
 
-static inline void cpu_hotplug_init(void)
-{
-}
-
 static inline void cpu_maps_update_begin(void)
 {
 }
diff --git a/init/main.c b/init/main.c
index 8442094..cf35e72 100644
--- a/init/main.c
+++ b/init/main.c
@@ -639,7 +639,6 @@ asmlinkage void __init start_kernel(void)
 	page_cgroup_init();
 	mem_init();
 	enable_debug_pagealloc();
-	cpu_hotplug_init();
 	kmem_cache_init();
 	debug_objects_mem_init();
 	idr_init_cache();
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 79e40f0..0c927ff 100644
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
 


