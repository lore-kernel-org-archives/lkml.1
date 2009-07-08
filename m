Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZGHWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZGHWd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZGHWbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbZGHWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [8/8] x86: mce: Lower maximum number of banks to architecture limit
Message-Id: <20090708223145.6F76A1D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Intel x86 architecture right now only supports 32 machine check
banks, more would bump into other MSRs.

So lower the max define to 32.

This only affects a few bitmaps, most data structures are dynamically
sized anyways.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h
+++ linux/arch/x86/include/asm/mce.h
@@ -130,10 +130,11 @@ void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
 
 /*
- * To support more than 128 would need to escape the predefined
- * Linux defined extended banks first.
+ * Maximum banks number.
+ * This is the limit of the current register layout on
+ * Intel CPUs.
  */
-#define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
+#define MAX_NR_BANKS 32
 
 #ifdef CONFIG_X86_MCE_INTEL
 extern int mce_cmci_disabled;
