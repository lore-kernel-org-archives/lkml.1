Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXIUWkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXIUWkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763683AbXIUWcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:40478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763594AbXIUWcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:23 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: satyam@infradead.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [22/50] i386: Misc cpuinit annotations
Message-Id: <20070921223221.4D70B13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Satyam Sharma <satyam@infradead.org>

cpuid_class_cpu_callback() is callback function of a CPU hotplug
notifier_block (that is already marked as __cpuinitdata). Therefore
it can safely be marked as __cpuinit.

cpuid_device_create() is only referenced from other functions that
are __cpuinit or __init. So it can also be safely marked __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpuid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/cpuid.c
===================================================================
--- linux.orig/arch/i386/kernel/cpuid.c
+++ linux/arch/i386/kernel/cpuid.c
@@ -136,7 +136,7 @@ static const struct file_operations cpui
 	.open = cpuid_open,
 };
 
-static int cpuid_device_create(int i)
+static int __cpuinit cpuid_device_create(int i)
 {
 	int err = 0;
 	struct device *dev;
@@ -147,7 +147,9 @@ static int cpuid_device_create(int i)
 	return err;
 }
 
-static int cpuid_class_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
+					      unsigned long action,
+					      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
