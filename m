Return-Path: <linux-kernel-owner+w=401wt.eu-S935058AbXGTPeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058AbXGTPeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbXGTPcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:54389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212AbXGTPcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:51 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/11] i386: Tune AMD Fam10h/11h like K8
Message-Id: <20070720153250.A41EF14E79@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This mainly changes the nops for alternative, so not very revolutionary.
 
Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
@@ -230,6 +230,9 @@ static void __cpuinit init_amd(struct cp
 	}
 
 	switch (c->x86) {
+		/* Use K8 tuning for Fam10h and Fam11h */
+	case 0x10:	
+	case 0x11:
 	case 15:
 		set_bit(X86_FEATURE_K8, c->x86_capability);
 		break;
