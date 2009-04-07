Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbZDGPJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbZDGPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbZDGPHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48831 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZDGPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:44 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [2/28] x86: MCE: Synchronize core after machine check handling
Message-Id: <20090407150742.038CE1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Spec compliance

The example code in the IA32 SDM recommends to synchronize the CPU
after machine check handling. So do that here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:15.000000000 +0200
@@ -254,6 +254,8 @@
 	 * Don't clear MCG_STATUS here because it's only defined for
 	 * exceptions.
 	 */
+
+	sync_core();
 }
 
 /*
@@ -419,6 +421,7 @@
 	wrmsrl(MSR_IA32_MCG_STATUS, 0);
  out2:
 	atomic_dec(&mce_entry);
+	sync_core();
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
