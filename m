Return-Path: <linux-kernel-owner+w=401wt.eu-S1030261AbXBGIQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261AbXBGIQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030440AbXBGIQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:16:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030261AbXBGIQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:16:17 -0500
Date: Wed, 7 Feb 2007 09:16:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: [patch] KVM, hotplug: export register_cpu_notifier
Message-ID: <20070207081633.GA6723@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] KVM, hotplug: export register_cpu_notifier
From: Ingo Molnar <mingo@elte.hu>

KVM-trunk uses register_cpu_notifier() but it's a module and we only 
export this if CONFIG_HOTPLUG_CPU. Export it otherwise too.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c
+++ linux/kernel/cpu.c
@@ -75,10 +75,10 @@ int __cpuinit register_cpu_notifier(stru
 	return ret;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 EXPORT_SYMBOL(register_cpu_notifier);
 
+#ifdef CONFIG_HOTPLUG_CPU
+
 void unregister_cpu_notifier(struct notifier_block *nb)
 {
 	mutex_lock(&cpu_add_remove_lock);
