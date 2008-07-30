Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbYG3Mye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbYG3Mye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbYG3MyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:54:11 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:23338 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbYG3MyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:54:10 -0400
Date: Wed, 30 Jul 2008 14:53:53 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] cpu hotplug: s390 doesn't support additional_cpus anymore.
Message-ID: <20080730125352.GA16064@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] cpu hotplug: s390 doesn't support additional_cpus anymore.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

s390 doesn't support the additional_cpus kernel parameter anymore since
a long time. So we better update the code and documentation to reflect
that.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 Documentation/cpu-hotplug.txt |    5 -----
 kernel/cpu.c                  |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -367,7 +367,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (!cpu_isset(cpu, cpu_possible_map)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64) || defined(CONFIG_S390)
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 		printk(KERN_ERR "please check additional_cpus= boot "
 				"parameter\n");
 #endif
Index: linux-2.6/Documentation/cpu-hotplug.txt
===================================================================
--- linux-2.6.orig/Documentation/cpu-hotplug.txt
+++ linux-2.6/Documentation/cpu-hotplug.txt
@@ -59,15 +59,10 @@ apicid values in those tables for disabl
 mark such hot-pluggable cpus as disabled entries, one could use this
 parameter "additional_cpus=x" to represent those cpus in the cpu_possible_map.
 
-s390 uses the number of cpus it detects at IPL time to also the number of bits
-in cpu_possible_map. If it is desired to add additional cpus at a later time
-the number should be specified using this option or the possible_cpus option.
-
 possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
 			This option sets possible_cpus bits in
 			cpu_possible_map. Thus keeping the numbers of bits set
 			constant even if the machine gets rebooted.
-			This option overrides additional_cpus.
 
 CPU maps and such
 -----------------
