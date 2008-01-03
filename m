Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbYACPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbYACPpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYACPm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:44492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbYACPmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:24 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH x86] [9/16] Remove CPU capabitilites printks on i386
Message-Id: <20080103154223.3AAE814DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't know of any case where they have been useful and they look ugly.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/common.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -432,20 +432,9 @@ void __cpuinit identify_cpu(struct cpuin
 
 	generic_identify(c);
 
-	printk(KERN_DEBUG "CPU: After generic identify, caps:");
-	for (i = 0; i < NCAPINTS; i++)
-		printk(" %08x", c->x86_capability[i]);
-	printk("\n");
-
-	if (this_cpu->c_identify) {
+	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
-		printk(KERN_DEBUG "CPU: After vendor identify, caps:");
-		for (i = 0; i < NCAPINTS; i++)
-			printk(" %08x", c->x86_capability[i]);
-		printk("\n");
-	}
-
 	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
@@ -496,13 +485,6 @@ void __cpuinit identify_cpu(struct cpuin
 				c->x86, c->x86_model);
 	}
 
-	/* Now the feature flags better reflect actual CPU features! */
-
-	printk(KERN_DEBUG "CPU: After all inits, caps:");
-	for (i = 0; i < NCAPINTS; i++)
-		printk(" %08x", c->x86_capability[i]);
-	printk("\n");
-
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
