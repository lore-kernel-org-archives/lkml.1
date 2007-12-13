Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbXLMJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbXLMJmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXLMJmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:42:16 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32784
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbXLMJmP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:42:15 -0500
Message-Id: <47610CB9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:43:05 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove dead code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither __cpu_disable() nor __cpu_die() are being referenced without
CONFIG_HOTPLUG_CPU.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/smpboot_32.c |   11 -----------
 arch/x86/kernel/smpboot_64.c |   12 ------------
 2 files changed, 23 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/smpboot_32.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpu-die/arch/x86/kernel/smpboot_32.c	2007-12-07 16:12:01.000000000 +0100
@@ -1232,17 +1232,6 @@ void __cpu_die(unsigned int cpu)
 	}
  	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
-#else /* ... !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 int __cpuinit native_cpu_up(unsigned int cpu)
--- linux-2.6.24-rc5/arch/x86/kernel/smpboot_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-cpu-die/arch/x86/kernel/smpboot_64.c	2007-12-07 16:12:17.000000000 +0100
@@ -1084,16 +1084,4 @@ static __init int setup_additional_cpus(
 }
 early_param("additional_cpus", setup_additional_cpus);
 
-#else /* ... !CONFIG_HOTPLUG_CPU */
-
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
 #endif /* CONFIG_HOTPLUG_CPU */



