Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZDGPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZDGPKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbZDGPHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48833 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbZDGPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [3/28] x86: MCE: Remove assumption that RIP MSR is exact
Message-Id: <20090407150743.B95051D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Spec compliance

The code assumed that on P4 the extended RIP MSR would
be an exact error location But no P4s have exact EIPVs and also
on rereading the SDM doesn't claim that. So let's drop that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:14.000000000 +0200
@@ -184,11 +184,8 @@
 		m->ip = 0;
 		m->cs = 0;
 	}
-	if (rip_msr) {
-		/* Assume the RIP in the MSR is exact. Is this true? */
-		m->mcgstatus |= MCG_STATUS_EIPV;
+	if (rip_msr)
 		rdmsrl(rip_msr, m->ip);
-	}
 }
 
 /*
