Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbXIUWjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbXIUWjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762314AbXIUWca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:57058 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbXIUWcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:21 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: satyam@infradead.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/50] i386: Misc cpuinit annotations
Message-Id: <20070921223220.3F58313DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Satyam Sharma <satyam@infradead.org>

msr_class_cpu_callback() can be marked __cpuinit, being the notifier
callback for a __cpuinitdata notifier_block. So can be marked
msr_device_create() too, called only from the newly-__cpuinit
msr_class_cpu_callback() or from __init-marked msr_init().

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/msr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/msr.c
===================================================================
--- linux.orig/arch/i386/kernel/msr.c
+++ linux/arch/i386/kernel/msr.c
@@ -135,7 +135,7 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int msr_device_create(int i)
+static int __cpuinit msr_device_create(int i)
 {
 	int err = 0;
 	struct device *dev;
@@ -146,7 +146,7 @@ static int msr_device_create(int i)
 	return err;
 }
 
-static int msr_class_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
