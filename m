Return-Path: <linux-kernel-owner+w=401wt.eu-S1030717AbXCFXlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030717AbXCFXlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030718AbXCFXlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:41:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51757 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030717AbXCFXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:41:50 -0500
Date: Wed, 7 Mar 2007 00:41:48 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com, len.brown@intel.com
Subject: [-mm patch] cpu_idle: fix build break
Message-ID: <20070306234148.GX3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

This patch fixes a build breakage with !CONFIG_HOTPLUG_CPU and 
CONFIG_CPU_IDLE.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was sent by Venkatesh Pallipadi on:
- 2 Mar 2007
 
--- linux-2.6.21-rc-mm.orig/drivers/cpuidle/cpuidle.c
+++ linux-2.6.21-rc-mm/drivers/cpuidle/cpuidle.c
@@ -189,10 +189,6 @@ static struct sysdev_driver cpuidle_sysd
 	.remove		= cpuidle_remove_device,
 };
 
-#ifdef CONFIG_SMP
-
-#ifdef CONFIG_HOTPLUG_CPU
-
 static int cpuidle_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
@@ -224,7 +220,7 @@ static struct notifier_block __cpuinitda
     .notifier_call = cpuidle_cpu_callback,
 };
 
-#endif /* CONFIG_HOTPLUG_CPU */
+#ifdef CONFIG_SMP
 
 static void smp_callback(void *v)
 {
