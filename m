Return-Path: <linux-kernel-owner+w=401wt.eu-S936690AbXGTPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936690AbXGTPet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935319AbXGTPcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935108AbXGTPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:53 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/11] x86_64: Set K8 CPUID flag for K8/Fam10h/Fam11h
Message-Id: <20070720153248.85A8714E7B@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Previously this flag was only used on 32bit, but some shared code can use
it now.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -612,6 +612,9 @@ static void __cpuinit init_amd(struct cp
 	else
 		num_cache_leaves = 3;
 
+	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
+		set_bit(X86_FEATURE_K8, &c->x86_capability);
+
 	/* RDTSC can be speculated around */
 	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
 
