Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZCNOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZCNOrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZCNOrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:47:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:36012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbZCNOrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:47:03 -0400
Subject: [PATCH -tip] x86: topology.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:16:40 +0530
Message-Id: <1237042000.4546.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: topology.c cleanup

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/topology.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 0fcc95a..a60ad15 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -25,10 +25,10 @@
  *
  * Send feedback to <colpatch@us.ibm.com>
  */
-#include <linux/init.h>
-#include <linux/smp.h>
 #include <linux/nodemask.h>
 #include <linux/mmzone.h>
+#include <linux/init.h>
+#include <linux/smp.h>
 #include <asm/cpu.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
@@ -47,6 +47,7 @@ int __ref arch_register_cpu(int num)
 	 */
 	if (num)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
+
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
 EXPORT_SYMBOL(arch_register_cpu);
@@ -56,7 +57,8 @@ void arch_unregister_cpu(int num)
 	unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
-#else
+#else /* CONFIG_HOTPLUG_CPU */
+
 static int __init arch_register_cpu(int num)
 {
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
@@ -74,7 +76,7 @@ static int __init topology_init(void)
 
 	for_each_present_cpu(i)
 		arch_register_cpu(i);
+
 	return 0;
 }
-
 subsys_initcall(topology_init);
-- 
1.6.0.6



