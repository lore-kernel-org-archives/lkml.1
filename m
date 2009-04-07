Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbZDGPI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbZDGPI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZDGPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48811 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbZDGPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
In-Reply-To: <20090407506.675031434@firstfloor.org>
To: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
Message-Id: <20090407150656.43E161D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:06:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Huang Ying <ying.huang@intel.com>

Return rip/cs if MCG_STATUS_EIPV is set in mce_get_rip(). Remain m->cs
if RIP is read from rip_msr.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:15.000000000 +0200
@@ -175,7 +175,7 @@
 
 static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 {
-	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
+	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV | MCG_STATUS_EIPV))) {
 		m->ip = regs->ip;
 		m->cs = regs->cs;
 	} else {
@@ -186,7 +186,6 @@
 		/* Assume the RIP in the MSR is exact. Is this true? */
 		m->mcgstatus |= MCG_STATUS_EIPV;
 		rdmsrl(rip_msr, m->ip);
-		m->cs = 0;
 	}
 }
 
