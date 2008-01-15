Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYAOCTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYAOCTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYAOCRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:17:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36887 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753690AbYAOCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:17:37 -0500
Message-Id: <20080115021736.895289000@sgi.com>
References: <20080115021735.779102000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jan 2008 18:17:41 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] x86: Change NR_CPUS arrays in topology V2
Content-Disposition: inline; filename=NR_CPUS-arrays-in-topology
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the following static arrays sized by NR_CPUS to
per_cpu data variables:

	i386_cpu cpu_devices[NR_CPUS];

(And change the struct name to x86_cpu.)

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
V1->V2:
    - (none)
---
 arch/x86/kernel/topology.c |    8 ++++----
 include/asm-x86/cpu.h      |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -31,7 +31,7 @@
 #include <linux/mmzone.h>
 #include <asm/cpu.h>
 
-static struct i386_cpu cpu_devices[NR_CPUS];
+static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 int __cpuinit arch_register_cpu(int num)
 {
@@ -46,16 +46,16 @@ int __cpuinit arch_register_cpu(int num)
 	 */
 #ifdef CONFIG_HOTPLUG_CPU
 	if (num)
-		cpu_devices[num].cpu.hotpluggable = 1;
+		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
 #endif
 
-	return register_cpu(&cpu_devices[num].cpu, num);
+	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 void arch_unregister_cpu(int num)
 {
-	return unregister_cpu(&cpu_devices[num].cpu);
+	return unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
 EXPORT_SYMBOL(arch_register_cpu);
 EXPORT_SYMBOL(arch_unregister_cpu);
--- a/include/asm-x86/cpu.h
+++ b/include/asm-x86/cpu.h
@@ -7,7 +7,7 @@
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
 
-struct i386_cpu {
+struct x86_cpu {
 	struct cpu cpu;
 };
 extern int arch_register_cpu(int num);

-- 
