Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbZDGPNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbZDGPNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbZDGPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbZDGPH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:56 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [12/28] x86: MCE: Rename and align out2 label
Message-Id: <20090407150753.C1DBB1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Minor cleanup, no functional changes

There's only a single out path in do_machine_check now, so rename the label from 
out2 to out.  Also align it at the first column.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:12.000000000 +0200
@@ -287,9 +287,9 @@
 
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
-		goto out2;
+		goto out;
 	if (!banks)
-		goto out2;
+		goto out;
 
 	mce_setup(&m);
 
@@ -418,7 +418,7 @@
 			wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 	wrmsrl(MSR_IA32_MCG_STATUS, 0);
- out2:
+out:
 	atomic_dec(&mce_entry);
 	sync_core();
 }
