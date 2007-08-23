Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXHWBjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXHWBjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXHWBjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:39:45 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36673 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXHWBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:39:44 -0400
Date: Wed, 22 Aug 2007 18:44:20 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: use num_online_nodes to get physical cpus numbers for
 powernow_k8
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>, Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708221844.22205.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: use num_online_nodes to get physical cpus numbers for powernow_k8

For opteron based system, don't assume all physical cpus have the same booted cpus even same cores. esp for downcore case.

Signed-off-by: Yinghai Lu <yinghai.sun.com>

diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
index 34ed53a..372df6e 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -1325,21 +1325,16 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
-	unsigned int booted_cores = 1;
 
 	for_each_online_cpu(i) {
 		if (check_supported_cpu(i))
 			supported_cpus++;
 	}
 
-#ifdef CONFIG_SMP
-	booted_cores = cpu_data[0].booted_cores;
-#endif
-
 	if (supported_cpus == num_online_cpus()) {
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
-			supported_cpus/booted_cores,
+			num_online_nodes(),
 			boot_cpu_data.x86_model_id, supported_cpus);
 		return cpufreq_register_driver(&cpufreq_amd64_driver);
 	}
