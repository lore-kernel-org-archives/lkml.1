Return-Path: <linux-kernel-owner+w=401wt.eu-S1763837AbXIUUrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763837AbXIUUrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbXIUUov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:51 -0400
Received: from mail.suse.de ([195.135.220.2]:50017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762819AbXIUUou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:50 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/45] x86_64: Use string instruction memcpy on AMD Fam11h
Message-Id: <20070921204449.6C96B14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -575,7 +575,7 @@ static void __cpuinit init_amd(struct cp
 	level = cpuid_eax(1);
 	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58))
 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
-	if (c->x86 == 0x10)
+	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
 
 	/* Enable workaround for FXSAVE leak */
