Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXGSJ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXGSJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbXGSJyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:55 -0400
Received: from mail.suse.de ([195.135.220.2]:35336 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXGSJyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:54 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/58] x86_64: Use string instruction memcpy/memset on AMD Fam10
Message-Id: <20070719095452.4419E14E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -575,6 +575,8 @@ static void __cpuinit init_amd(struct cp
 	level = cpuid_eax(1);
 	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58))
 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
+	if (c->x86 == 0x10)
+		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
 
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
