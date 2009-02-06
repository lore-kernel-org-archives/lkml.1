Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZBFGjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZBFGjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZBFGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:39:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55703 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZBFGjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:39:37 -0500
Message-ID: <498BDB15.6050609@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 14:39:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gautham R Shenoy <ego@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpu hotplug: remove unused cpuhotplug_mutex_lock()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpuhotplug_mutex_lock() is not used. this patch remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 cpu.h |   16 ----------------
 1 file changed, 16 deletions(-)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c2747ac..2643d84 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -23,7 +23,6 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
-#include <linux/mutex.h>
 
 struct cpu {
 	int node_id;		/* The node which contains the CPU */
@@ -103,16 +102,6 @@ extern struct sysdev_class cpu_sysdev_class;
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
 
-static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
-{
-	mutex_lock(cpu_hp_mutex);
-}
-
-static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
-{
-	mutex_unlock(cpu_hp_mutex);
-}
-
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
@@ -126,11 +115,6 @@ int cpu_down(unsigned int cpu);
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
-static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
-{ }
-static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
-{ }
-
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)


