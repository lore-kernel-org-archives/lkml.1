Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZANG7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZANG7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZANG7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:59:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZANG7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:59:14 -0500
Message-ID: <496D8D07.5080108@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 14:58:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: add __cpuinit to rcu_init_percpu_data()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: rcu_init_percpu_data() is not use after boot when !CONFIG_HOTPLUG_CPU

add __cpuinit to rcu_init_percpu_data(), and this function's text
will be discarded after boot when !CONFIG_HOTPLUG_CPU.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 490934f..bd5a900 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -716,7 +716,7 @@ void rcu_check_callbacks(int cpu, int user)
 	raise_rcu_softirq();
 }
 
-static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
+static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
 	unsigned long flags;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f2d8638..b2fd602 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1314,7 +1314,7 @@ int rcu_needs_cpu(int cpu)
  * access due to the fact that this CPU cannot possibly have any RCU
  * callbacks in flight yet.
  */
-static void
+static void __cpuinit
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;



